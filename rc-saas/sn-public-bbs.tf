resource "aws_security_group" "sg_public_lb_bbs" {
  name = "sg_public_lb_bbs_${var.install_version}"
  description = "BBS ELB security group"
  vpc_id = "${aws_vpc.vpc.id}"

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
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
    from_port = "22"
    to_port = "22"
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ## Allow all outbound traffic
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  tags {
    Name = "sg_public_lb_bbs_${var.install_version}"
  }
}

# BBS Load balancer
resource "aws_elb" "lb_bbs" {
 name = "lb-bbs-${var.install_version}"
 connection_draining = true
 subnets = [
   "${aws_subnet.sn_public.id}"]
 security_groups = [
   "${aws_security_group.sg_public_bbs.id}",
   "${aws_security_group.sg_public_lb_bbs.id}"
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
