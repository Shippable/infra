resource "aws_security_group" "sg_private_ship_builds" {
  name = "sg_private_ship_builds_${var.install_version}"
  description = "Private Subnet for security group builds"
  vpc_id = "${aws_vpc.vpc.id}"

  ingress {
    from_port = "22"
    to_port = "22"
    protocol = "tcp"
    cidr_blocks = [
      "${var.cidr_public_ship}",
      "${var.cidr_private_ship_install}"
      ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  tags {
    Name = "sg_private_ship_builds_${var.install_version}"
  }
}

# CENTOS 7 test-instance
#resource "aws_instance" "test_inst_1_centos_7_rituraj" {
#  ami = "${var.ami_us_east_1_centos7}"
#  availability_zone = "${var.avl-zone}"
#  instance_type = "${var.in_type_core}"
#  key_name = "${var.aws_key_name}"
#  subnet_id = "${aws_subnet.sn_ship_install.id}"
#
#  vpc_security_group_ids = [
#    "${aws_security_group.sg_private_ship_install.id}"]
#
#  root_block_device {
#    volume_type = "gp2"
#    volume_size = 50
#    delete_on_termination = true
#  }
#
#  tags = {
#    Name = "test_inst_1_centos_7_rituraj"
#  }
#}
#
#output "test_inst_1_centos_7_rituraj" {
#  value = "${aws_instance.test_inst_1_centos_7_rituraj.private_ip}"
#}

## Ubuntu 14.04 test-instance
resource "aws_instance" "grisham_dev_instance_bharath92_u1404" {
  ami = "${var.ami_us_east_1_ubuntu1404}"
  availability_zone = "${var.avl-zone}"
  instance_type = "${var.in_type_core}"
  key_name = "${var.aws_key_name}"
  subnet_id = "${aws_subnet.sn_ship_install.id}"

  vpc_security_group_ids = [
    "${aws_security_group.sg_private_ship_install.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = 50
    delete_on_termination = true
  }

  tags = {
    Name = "grisham_dev_instance_bharath92_u1404_${var.install_version}"
  }
}

output "grisham_dev_instance_bharath92_u1404" {
  value = "${aws_instance.grisham_dev_instance_bharath92_u1404.private_ip}"
}

resource "aws_instance" "grisham_dev_instance_ric03uec_u1604" {
  ami = "${var.ami_us_east_1_ubuntu1604}"
  availability_zone = "${var.avl-zone}"
  instance_type = "${var.in_type_core}"
  key_name = "${var.aws_key_name}"
  subnet_id = "${aws_subnet.sn_ship_install.id}"

  vpc_security_group_ids = [
    "${aws_security_group.sg_private_ship_install.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = 50
    delete_on_termination = true
  }

  tags = {
    Name = "grisham_dev_instance_ric03uec_u1604_${var.install_version}"
  }
}

output "grisham_dev_instance_ric03uec_u1604" {
  value = "${aws_instance.grisham_dev_instance_ric03uec_u1604.private_ip}"
}

## resource "aws_instance" "test_instance_ric03uec_rancherOS" {
##   ami = "${var.ami_us_east_1_rancheros}"
##   availability_zone = "${var.avl-zone}"
##   instance_type = "${var.in_type_core}"
##   key_name = "${var.aws_key_name}"
##   subnet_id = "${aws_subnet.sn_ship_install.id}"
##
##   vpc_security_group_ids = [
##     "${aws_security_group.sg_private_ship_install.id}"]
##
##   root_block_device {
##     volume_type = "gp2"
##     volume_size = 50
##     delete_on_termination = true
##   }
##
##   tags = {
##     Name = "test_instance_ric03uec_rancherOS${var.install_version}"
##   }
## }
##
## output "test_instance_ric03uec_rancherOS" {
##   value = "${aws_instance.test_instance_ric03uec_rancherOS.private_ip}"
## }

resource "aws_instance" "prod_bld_hosts_x86_ubuntu1404" {
  count = 2
  ami = "${var.ami_us_east_1_ubuntu1404}"
  availability_zone = "${var.avl-zone}"
  instance_type = "${var.in_type_bld}"
  key_name = "${var.aws_key_name}"
  subnet_id = "${aws_subnet.sn_ship_builds.id}"

  vpc_security_group_ids = [
    "${aws_security_group.sg_private_ship_builds.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = 50
    delete_on_termination = true
  }

  tags = {
    Name = "bld_${count.index}_${var.install_version}"
  }
}

resource "aws_instance" "prod_bld_hosts_x86_ubuntu1604" {
  count = 1
  ami = "${var.ami_us_east_1_ubuntu1604}"
  availability_zone = "${var.avl-zone}"
  instance_type = "${var.in_type_bld}"
  key_name = "${var.aws_key_name}"
  subnet_id = "${aws_subnet.sn_ship_builds.id}"

  vpc_security_group_ids = [
    "${aws_security_group.sg_private_ship_builds.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = 50
    delete_on_termination = true
  }

  tags = {
    Name = "bld_${count.index}_${var.install_version}"
  }
}
