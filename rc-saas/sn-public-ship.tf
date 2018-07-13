# Web Security group
resource "aws_security_group" "sg_public_lb" {
  name = "sg_public_lb_${var.install_version}"
  description = "LB traffic security group"
  vpc_id = "${aws_vpc.vpc.id}"

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
      "${var.cidr_private_ship_install}"]
  }
  tags {
    Name = "sg_public_lb_${var.install_version}"
  }
}

# BBS Load balancer
resource "aws_elb" "lb_bbs" {
 name = "lb-bbs-${var.install_version}"
 connection_draining = true
 subnets = [
   "${aws_subnet.sn_public.id}"]
 security_groups = [
   "${aws_security_group.sg_public_bbs.id}"
  ]

 listener {
   lb_port = 22
   lb_protocol = "tcp"
   instance_port = 7999
   instance_protocol = "tcp"
 }

 listener {
   lb_port = 443
   lb_protocol = "https"
   instance_port = 7990
   instance_protocol = "http"
   ssl_certificate_id = "${var.acm_cert_arn}"
 }

 health_check {
   healthy_threshold = 2
   unhealthy_threshold = 2
   timeout = 3
   target = "HTTP:7990/status"
   interval = 5
 }

 instances = [
   "${aws_instance.rcbbs-2.id}"
 ]
}

# ========================Load Balancers=======================

# ----------
# BLUE ELBS
# ----------

# # MKTG Load balancer
# resource "aws_elb" "lb_b_mktg" {
#   name = "lb-b-mktg-${var.install_version}"
#   connection_draining = true
#   subnets = [
#     "${aws_subnet.sn_public.id}"]
#   security_groups = [
#     "${aws_security_group.sg_public_lb.id}"]

#   listener {
#     lb_port = 443
#     lb_protocol = "ssl"
#     instance_port = 50002
#     instance_protocol = "tcp"
#     ssl_certificate_id = "${var.acm_cert_arn}"
#   }

#   health_check {
#     healthy_threshold = 2
#     unhealthy_threshold = 2
#     timeout = 3
#     target = "HTTP:50002/"
#     interval = 5
#   }

#   instances = [
#     "${aws_instance.ms_b_1.id}",
#     "${aws_instance.ms_b_2.id}"
#   ]
# }

# # WWW Load balancer
# resource "aws_elb" "lb_b_www" {
#   name = "lb-b-www-${var.install_version}"
#   connection_draining = true
#   subnets = [
#     "${aws_subnet.sn_public.id}"]
#   security_groups = [
#     "${aws_security_group.sg_public_lb.id}"]

#   listener {
#     lb_port = 443
#     lb_protocol = "ssl"
#     instance_port = 50001
#     instance_protocol = "tcp"
#     ssl_certificate_id = "${var.acm_cert_arn}"
#   }

#   health_check {
#     healthy_threshold = 2
#     unhealthy_threshold = 2
#     timeout = 3
#     target = "HTTP:50001/"
#     interval = 5
#   }

#   instances = [
#     "${aws_instance.ms_b_1.id}",
#     "${aws_instance.ms_b_2.id}"
#   ]
# }

# //# API Load balancer
# resource "aws_elb" "lb_b_api" {
#   name = "lb-b-api-${var.install_version}"
#   connection_draining = true
#   subnets = [
#     "${aws_subnet.sn_public.id}"]
#   security_groups = [
#     "${aws_security_group.sg_public_lb.id}"]

#   listener {
#     lb_port = 443
#     lb_protocol = "https"
#     instance_port = 50000
#     instance_protocol = "http"
#     ssl_certificate_id = "${var.acm_cert_arn}"
#   }

#   health_check {
#     healthy_threshold = 2
#     unhealthy_threshold = 2
#     timeout = 3
#     target = "HTTP:50000/"
#     interval = 5
#   }

#   instances = [
#     "${aws_instance.ms_b_1.id}",
#     "${aws_instance.ms_b_2.id}"
#   ]
# }

# # API INT ELB
# resource "aws_elb" "lb_b_api_int" {
#   name = "lb-b-api-int-${var.install_version}"
#   connection_draining = true
#   subnets = [
#     "${aws_subnet.sn_public.id}"]
#   security_groups = [
#     "${aws_security_group.sg_public_lb.id}"]

#   listener {
#     lb_port = 443
#     lb_protocol = "https"
#     instance_port = 50004
#     instance_protocol = "http"
#     ssl_certificate_id = "${var.acm_cert_arn}"
#   }

#   health_check {
#     healthy_threshold = 2
#     unhealthy_threshold = 2
#     timeout = 3
#     target = "HTTP:50004/"
#     interval = 5
#   }

#   instances = [
#     "${aws_instance.ms_b_1.id}",
#     "${aws_instance.ms_b_2.id}"
#   ]
# }

# # API CONSOLE ELB
# resource "aws_elb" "lb_b_api_con" {
#   name = "lb-b-api-con-${var.install_version}"
#   connection_draining = true
#   subnets = [
#     "${aws_subnet.sn_public.id}"]
#   security_groups = [
#     "${aws_security_group.sg_public_lb.id}"]

#   listener {
#     lb_port = 443
#     lb_protocol = "https"
#     instance_port = 50005
#     instance_protocol = "http"
#     ssl_certificate_id = "${var.acm_cert_arn}"
#   }

#   health_check {
#     healthy_threshold = 2
#     unhealthy_threshold = 2
#     timeout = 3
#     target = "HTTP:50005/"
#     interval = 5
#   }

#   instances = [
#     "${aws_instance.ms_b_1.id}",
#     "${aws_instance.ms_b_2.id}"
#   ]
# }

# ----------
# GREEN ELBS
# ----------

# MKTG Load balancer
resource "aws_elb" "lb_g_mktg" {
 name = "lb-g-mktg-${var.install_version}"
 connection_draining = true
 subnets = [
   "${aws_subnet.sn_public.id}"]
   security_groups = [
   "${aws_security_group.sg_public_lb.id}"]

 listener {
   lb_port = 443
   lb_protocol = "ssl"
   instance_port = 50002
   instance_protocol = "tcp"
   ssl_certificate_id = "${var.acm_cert_arn}"
 }

 health_check {
   healthy_threshold = 2
   unhealthy_threshold = 2
   timeout = 3
   target = "HTTP:50002/"
   interval = 5
 }

 instances = [
   "${aws_instance.ms_g_1.id}"
 ]
}

# WWW Load balancer
resource "aws_elb" "lb_g_www" {
 name = "lb-g-www-${var.install_version}"
 connection_draining = true
 subnets = [
   "${aws_subnet.sn_public.id}"]
 security_groups = [
   "${aws_security_group.sg_public_lb.id}"]

 listener {
   lb_port = 443
   lb_protocol = "ssl"
   instance_port = 50001
   instance_protocol = "tcp"
   ssl_certificate_id = "${var.acm_cert_arn}"
 }

 health_check {
   healthy_threshold = 2
   unhealthy_threshold = 2
   timeout = 3
   target = "HTTP:50001/"
   interval = 5
 }

 instances = [
   "${aws_instance.ms_g_1.id}"
 ]
}

# API Load balancer
resource "aws_elb" "lb_g_api" {
 name = "lb-g-api-${var.install_version}"
 connection_draining = true
 subnets = [
   "${aws_subnet.sn_public.id}"]
 security_groups = [
   "${aws_security_group.sg_public_lb.id}"]

 listener {
   lb_port = 443
   lb_protocol = "https"
   instance_port = 50000
   instance_protocol = "http"
   ssl_certificate_id = "${var.acm_cert_arn}"
 }

 health_check {
   healthy_threshold = 2
   unhealthy_threshold = 2
   timeout = 3
   target = "HTTP:50000/"
   interval = 5
 }

 instances = [
   "${aws_instance.ms_g_1.id}"
 ]
}

# API INT ELB
resource "aws_elb" "lb_g_api_int" {
 name = "lb-g-api-int-${var.install_version}"
 connection_draining = true
 subnets = [
   "${aws_subnet.sn_public.id}"]
 security_groups = [
   "${aws_security_group.sg_public_lb.id}"]

 listener {
   lb_port = 443
   lb_protocol = "https"
   instance_port = 50004
   instance_protocol = "http"
   ssl_certificate_id = "${var.acm_cert_arn}"
 }

 health_check {
   healthy_threshold = 2
   unhealthy_threshold = 2
   timeout = 3
   target = "HTTP:50004/"
   interval = 5
 }

 instances = [
   "${aws_instance.ms_g_1.id}"
 ]
}

#API CONSOLE ELB
resource "aws_elb" "lb_g_api_con" {
 name = "lb-g-api-con-${var.install_version}"
 connection_draining = true
 subnets = [
   "${aws_subnet.sn_public.id}"]
 security_groups = [
   "${aws_security_group.sg_public_lb.id}"]

 listener {
   lb_port = 443
   lb_protocol = "https"
   instance_port = 50005
   instance_protocol = "http"
   ssl_certificate_id = "${var.acm_cert_arn}"
 }

 health_check {
   healthy_threshold = 2
   unhealthy_threshold = 2
   timeout = 3
   target = "HTTP:50005/"
   interval = 5
 }

 instances = [
   "${aws_instance.ms_g_1.id}"
 ]
}

# MSG Load balancer
resource "aws_elb" "lb_msg" {
  name = "lb-msg-${var.install_version}"
  idle_timeout = 3600
  connection_draining = true
  connection_draining_timeout = 3600
  subnets = [
    "${aws_subnet.sn_public.id}"]
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
    timeout = 3
    target = "HTTP:15672/"
    interval = 5
  }

  instances = [
    "${aws_instance.ms_g_1.id}"]
}

