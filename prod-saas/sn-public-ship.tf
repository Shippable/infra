# Web Security group
resource "aws_security_group" "sg_public_lb" {
  name = "sg_public_lb_${var.install_version}"
  description = "LB traffic security group"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  ingress {
    from_port = 5671
    to_port = 5671
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  ingress {
    from_port = 15671
    to_port = 15671
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  egress {
    # allow all traffic to private SN
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = [
      "${var.cidr_private_ship_install}",
      "${var.cidr_public_ship}"
    ]
  }

  tags {
    Name = "sg_public_lb_${var.install_version}"
  }
}

# RP Server
resource "aws_instance" "rp" {
  ami = "${var.ami_us_east_1_ubuntu1404_20170310}"
  availability_zone = "${var.avl-zone}"
  instance_type = "${var.in_type_rp}"
  key_name = "${var.aws_key_name}"

  subnet_id = "${var.sn_public_ship_id}"
  vpc_security_group_ids = [
    "${aws_security_group.sg_public_nat.id}"]

  provisioner "file" {
    source = "setupNGINX.sh"
    destination = "~/setupNGINX.sh"

    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = "${file(null_resource.pemfile.triggers.fileName)}"
      agent = true
    }
  }

  provisioner "file" {
    source = "default"
    destination = "~/default"

    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = "${file(null_resource.pemfile.triggers.fileName)}"
      agent = true
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x setupNGINX.sh && sudo ./setupNGINX.sh"
    ]

    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = "${file(null_resource.pemfile.triggers.fileName)}"
      agent = true
    }
  }

  associate_public_ip_address = true
  source_dest_check = false

  tags = {
    Name = "rp_${var.install_version}"
  }
}

# Associate EIP, without this private TF remote wont work
resource "aws_eip" "rp_eip" {
  instance = "${aws_instance.rp.id}"
  vpc = true
}

# --------------
# LOAD BALANCERS
# --------------

# MSG ELB
resource "aws_elb" "lb_msg" {
  name = "lb-msg-${var.install_version}"
  idle_timeout = 3600
  connection_draining = true
  connection_draining_timeout = 3600
  subnets = [
    "${var.sn_public_ship_id}"]
  security_groups = [
    "${aws_security_group.sg_public_lb.id}"]

  listener {
    lb_port = 443
    lb_protocol = "https"
    instance_port = 15672
    instance_protocol = "http"
    ssl_certificate_id = "${var.acm_cert_arn}"
  }

  listener {
    lb_port = 5671
    lb_protocol = "ssl"
    instance_port = 5672
    instance_protocol = "tcp"
    ssl_certificate_id = "${var.acm_cert_arn}"
  }

  listener {
    lb_port = 15671
    lb_protocol = "https"
    instance_port = 15672
    instance_protocol = "http"
    ssl_certificate_id = "${var.acm_cert_arn}"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 10
    target = "HTTP:15672/"
    interval = 30
  }

  instances = [
    "${var.in_msg_id}"]
}

# RP ELB
resource "aws_elb" "lb_rp_n" {
  name = "lb-rp-n-${var.install_version}"
  connection_draining = true
  subnets = [
    "${var.sn_public_ship_id}"]
  security_groups = [
    "${aws_security_group.sg_public_lb.id}"]

  listener {
    lb_port = 443
    lb_protocol = "https"
    instance_port = 80
    instance_protocol = "http"
    ssl_certificate_id = "${var.acm_cert_arn_20170309}"
  }

  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = 80
    instance_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 10
    target = "TCP:80"
    interval = 30
  }

  instances = [
    "${aws_instance.rp.id}"
  ]
}

# ----------
# GREEN ELBS
# ----------

# WWW ELB
resource "aws_elb" "lb_g_www" {
  name = "lb-g-www-${var.install_version}"
  connection_draining = true
  subnets = [
    "${var.sn_public_ship_id}"]
  security_groups = [
    "${aws_security_group.sg_public_lb.id}"]

  listener {
    lb_port = 443
    lb_protocol = "https"
    instance_port = 50002
    instance_protocol = "http"
    ssl_certificate_id = "${var.acm_cert_arn_20170309}"
  }

  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = 50002
    instance_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 10
    target = "TCP:50002"
    interval = 30
  }

  instances = ["${aws_instance.ms_g.*.id}"]
}

# APP ELB
resource "aws_elb" "lb_g_app" {
  name = "lb-g-app-${var.install_version}"
  connection_draining = true
  subnets = [
    "${var.sn_public_ship_id}"]
  security_groups = [
    "${aws_security_group.sg_public_lb.id}"]

  listener {
    lb_port = 443
    lb_protocol = "ssl"
    instance_port = 50001
    instance_protocol = "tcp"
    ssl_certificate_id = "${var.acm_cert_arn_20170309}"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:50001/"
    interval = 5
  }

  instances = ["${aws_instance.ms_g.*.id}"]
}

# API ELB
resource "aws_elb" "lb_g_api" {
  name = "lb-g-api-${var.install_version}"
  connection_draining = true
  subnets = [
    "${var.sn_public_ship_id}"]
  security_groups = [
    "${aws_security_group.sg_public_lb.id}"]

  listener {
    lb_port = 443
    lb_protocol = "https"
    instance_port = 50000
    instance_protocol = "http"
    ssl_certificate_id = "${var.acm_cert_arn_20170309}"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 5
    timeout = 3
    target = "HTTP:50000/"
    interval = 5
  }

  instances = ["${aws_instance.ms_g.*.id}"]
}

# API INT ELB
resource "aws_elb" "lb_g_api_int" {
  name = "lb-g-api-int-${var.install_version}"
  connection_draining = true
  subnets = [
    "${var.sn_public_ship_id}"]
  security_groups = [
    "${aws_security_group.sg_public_lb.id}"]

  listener {
    lb_port = 443
    lb_protocol = "https"
    instance_port = 50004
    instance_protocol = "http"
    ssl_certificate_id = "${var.acm_cert_arn_20170309}"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 5
    timeout = 3
    target = "HTTP:50004/"
    interval = 5
  }

  instances = ["${aws_instance.ms_g.*.id}"]
}

# API CON ELB
resource "aws_elb" "lb_g_api_con" {
  name = "lb-g-api-con-${var.install_version}"
  connection_draining = true
  idle_timeout = 150
  subnets = [
    "${var.sn_public_ship_id}"]
  security_groups = [
    "${aws_security_group.sg_public_lb.id}"]

  listener {
    lb_port = 443
    lb_protocol = "https"
    instance_port = 50005
    instance_protocol = "http"
    ssl_certificate_id = "${var.acm_cert_arn_20170309}"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 5
    timeout = 3
    target = "HTTP:50005/"
    interval = 5
  }

  instances = ["${aws_instance.ms_g.*.id}"]
}

# ---------
# BLUE ELBS
# ---------

# WWW ELB
resource "aws_elb" "lb_b_www" {
 name = "lb-b-www-${var.install_version}"
 connection_draining = true
 subnets = [
   "${var.sn_public_ship_id}"]
 security_groups = [
   "${aws_security_group.sg_public_lb.id}"]

 listener {
   lb_port = 443
   lb_protocol = "https"
   instance_port = 50002
   instance_protocol = "http"
   ssl_certificate_id = "${var.acm_cert_arn_20170309}"
 }

 listener {
   lb_port = 80
   lb_protocol = "http"
   instance_port = 50002
   instance_protocol = "http"
 }

 health_check {
   healthy_threshold = 2
   unhealthy_threshold = 2
   timeout = 10
   target = "TCP:50002"
   interval = 30
 }

 instances = ["${aws_instance.ms_b.*.id}"]
}

# APP ELB
resource "aws_elb" "lb_b_app" {
 name = "lb-b-app-${var.install_version}"
 connection_draining = true
 subnets = [
   "${var.sn_public_ship_id}"]
 security_groups = [
   "${aws_security_group.sg_public_lb.id}"]

 listener {
   lb_port = 443
   lb_protocol = "ssl"
   instance_port = 50001
   instance_protocol = "tcp"
   ssl_certificate_id = "${var.acm_cert_arn_20170309}"
 }

 health_check {
   healthy_threshold = 2
   unhealthy_threshold = 2
   timeout = 3
   target = "HTTP:50001/"
   interval = 5
 }

 instances = ["${aws_instance.ms_b.*.id}"]
}

# API ELB
resource "aws_elb" "lb_b_api" {
 name = "lb-b-api-${var.install_version}"
 connection_draining = true
 subnets = [
   "${var.sn_public_ship_id}"]
 security_groups = [
   "${aws_security_group.sg_public_lb.id}"]

 listener {
   lb_port = 443
   lb_protocol = "https"
   instance_port = 50000
   instance_protocol = "http"
   ssl_certificate_id = "${var.acm_cert_arn_20170309}"
 }

 health_check {
   healthy_threshold = 2
   unhealthy_threshold = 5
   timeout = 3
   target = "HTTP:50000/"
   interval = 5
 }

 instances = ["${aws_instance.ms_b.*.id}"]
}

# API INT ELB
resource "aws_elb" "lb_b_api_int" {
 name = "lb-b-api-int-${var.install_version}"
 connection_draining = true
 subnets = [
   "${var.sn_public_ship_id}"]
 security_groups = [
   "${aws_security_group.sg_public_lb.id}"]

 listener {
   lb_port = 443
   lb_protocol = "https"
   instance_port = 50004
   instance_protocol = "http"
   ssl_certificate_id = "${var.acm_cert_arn_20170309}"
 }

 health_check {
   healthy_threshold = 2
   unhealthy_threshold = 5
   timeout = 3
   target = "HTTP:50004/"
   interval = 5
 }

 instances = ["${aws_instance.ms_b.*.id}"]
}

# API CON ELB
resource "aws_elb" "lb_b_api_con" {
 name = "lb-b-api-con-${var.install_version}"
 connection_draining = true
 idle_timeout = 150
 subnets = [
   "${var.sn_public_ship_id}"]
 security_groups = [
   "${aws_security_group.sg_public_lb.id}"]

 listener {
   lb_port = 443
   lb_protocol = "https"
   instance_port = 50005
   instance_protocol = "http"
   ssl_certificate_id = "${var.acm_cert_arn_20170309}"
 }

 health_check {
   healthy_threshold = 2
   unhealthy_threshold = 5
   timeout = 3
   target = "HTTP:50005/"
   interval = 5
 }

 instances = ["${aws_instance.ms_b.*.id}"]
}
