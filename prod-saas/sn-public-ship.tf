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

# ========================Load Balancers=======================

# MSG Load balancer
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

# New ELBs for Docker 1.13 rollout

# RP Load balancer
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

#GREEN ELBS

# WWW Load balancer
resource "aws_elb" "lb_www_n" {
  name = "lb-www-n-${var.install_version}"
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

  instances = [
    "${aws_instance.ms_g_1.id}",
    "${aws_instance.ms_g_2.id}",
    "${aws_instance.ms_g_3.id}",
    "${aws_instance.ms_g_4.id}",
    "${aws_instance.ms_g_5.id}",
    "${aws_instance.ms_g_6.id}"
  ]
}

# APP Load balancer
resource "aws_elb" "lb_app_n" {
  name = "lb-app-n-${var.install_version}"
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

  instances = [
    "${aws_instance.ms_g_1.id}",
    "${aws_instance.ms_g_2.id}",
    "${aws_instance.ms_g_3.id}",
    "${aws_instance.ms_g_4.id}",
    "${aws_instance.ms_g_5.id}",
    "${aws_instance.ms_g_6.id}"
  ]
}

//# API Load balancer
resource "aws_elb" "lb_api_n" {
  name = "lb-api-n-${var.install_version}"
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

  instances = [
    "${aws_instance.ms_g_1.id}",
    "${aws_instance.ms_g_2.id}",
    "${aws_instance.ms_g_3.id}",
    "${aws_instance.ms_g_4.id}",
    "${aws_instance.ms_g_5.id}",
    "${aws_instance.ms_g_6.id}"
  ]
}

### BLUE ELBS

# WWW Load balancer
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

  instances = [
    "${aws_instance.ms_b_1.id}",
    "${aws_instance.ms_b_2.id}",
    "${aws_instance.ms_b_3.id}",
    "${aws_instance.ms_b_4.id}",
    "${aws_instance.ms_b_5.id}",
    "${aws_instance.ms_b_6.id}"
  ]
}

# APP Load balancer
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

  instances = [
    "${aws_instance.ms_b_1.id}",
    "${aws_instance.ms_b_2.id}",
    "${aws_instance.ms_b_3.id}",
    "${aws_instance.ms_b_4.id}",
    "${aws_instance.ms_b_5.id}",
    "${aws_instance.ms_b_6.id}"
  ]
}

//# API Load balancer
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

  instances = [
    "${aws_instance.ms_b_1.id}",
    "${aws_instance.ms_b_2.id}",
    "${aws_instance.ms_b_3.id}",
    "${aws_instance.ms_b_4.id}",
    "${aws_instance.ms_b_5.id}",
    "${aws_instance.ms_b_6.id}"
  ]
}
