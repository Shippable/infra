resource "aws_security_group" "sg_public_bbs" {
  name = "sg_public_bbs_${var.install_version}"
  description = "BBS instance security group"
  vpc_id = "${aws_vpc.vpc.id}"

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "${var.cidr_public_ship}",
    ]
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
    Name = "sg_public_bbs_${var.install_version}"
  }
}

## allow ssh only traffic from nat security group
# resource "aws_security_group_rule" "allow_nat_ssh" {
#  type            = "ingress"
#  from_port       = 22
#  to_port         = 22
#  protocol        = "tcp"
#
#  security_group_id = "${aws_security_group.sg_public_bbs.id}"
#  source_security_group_id = "${aws_security_group.sg_public_nat.id}"
# }

## allow http traffic from lb on port 7990
#resource "aws_security_group_rule" "allow_lb_https_bbs" {
#  type            = "ingress"
#  from_port       = 7990
#  to_port         = 7990
#  protocol        = "tcp"
#
#  security_group_id = "${aws_security_group.sg_public_bbs.id}"
#  source_security_group_id = "${aws_security_group.sg_public_lb_bbs.id}"
#}

## allow ssh traffic from lb on port 7999
#resource "aws_security_group_rule" "allow_lb_ssh_bbs" {
#  type            = "ingress"
#  from_port       = 7999
#  to_port         = 7999
#  protocol        = "tcp"
#
#  security_group_id = "${aws_security_group.sg_public_bbs.id}"
#  source_security_group_id = "${aws_security_group.sg_public_lb_bbs.id}"
#}

resource "aws_instance" "rcbbs-2" {
  ami = "${var.ami_us_east_1_ubuntu1604}"
  availability_zone = "${var.avl-zone}"
  instance_type = "${var.in_type_scm}"
  key_name = "${var.aws_key_name}"
  subnet_id = "${aws_subnet.sn_public.id}"

  vpc_security_group_ids = [
    "${aws_security_group.sg_public_bbs.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = 30
    delete_on_termination = true
  }

  tags = {
    Name = "rcbbs_2_${var.install_version}"
  }
}
