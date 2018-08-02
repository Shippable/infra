resource "aws_security_group" "sg_private_ship_builds" {
  name = "sg_private_ship_builds_${var.install_version}"
  description = "Private Subnet for security group builds"
  vpc_id = "${aws_vpc.vpc.id}"

  # For Windows RDP access
  ingress {
    from_port = "3389"
    to_port   = "3389"
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

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

resource "aws_instance" "shared_pool_x86_u1404_01" {
  ami = "${var.ami_us_east_1_ubuntu1404}"
  availability_zone = "${var.avl-zone}"
  instance_type = "${var.in_type_core}"
  key_name = "${var.aws_key_name}"
  subnet_id = "${aws_subnet.sn_public.id}"

  vpc_security_group_ids = [
    "${aws_security_group.sg_private_ship_builds.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = 100
    delete_on_termination = true
  }

  tags = {
    Name = "shared_pool_x86_u1404_01_${var.install_version}"
  }
}

output "shared_pool_x86_u1404_01" {
  value = "${aws_instance.shared_pool_x86_u1404_01.private_ip}"
}

resource "aws_instance" "shared_pool_x86_u1604_01" {
  ami = "${var.ami_us_east_1_ubuntu1604}"
  availability_zone = "${var.avl-zone}"
  instance_type = "${var.in_type_core}"
  key_name = "${var.aws_key_name}"
  subnet_id = "${aws_subnet.sn_public.id}"

  vpc_security_group_ids = [
    "${aws_security_group.sg_private_ship_builds.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = 100
    delete_on_termination = true
  }

  tags = {
    Name = "shared_pool_x86_u1604_01_${var.install_version}"
  }
}

output "shared_pool_x86_u1604_01" {
  value = "${aws_instance.shared_pool_x86_u1604_01.private_ip}"
}

resource "aws_instance" "drydock_builder" {
  ami = "${var.ami_us_east_1_ubuntu1604}"
  availability_zone = "${var.avl-zone}"
  instance_type = "${var.in_type_bld}"
  key_name = "${var.aws_key_name}"
  subnet_id = "${aws_subnet.sn_public.id}"

  vpc_security_group_ids = [
    "${aws_security_group.sg_private_ship_builds.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = 100
    delete_on_termination = true
  }

  tags = {
    Name = "drydock_builder_${var.install_version}"
  }
}

output "drydock_builder" {
  value = "${aws_instance.drydock_builder.private_ip}"
}

########################################################################
############################# user instances ###########################
########################################################################

## resource "aws_instance" "admiral_test_u1604_bharath92" {
##   ami = "${var.ami_us_east_1_ubuntu1604}"
##   availability_zone = "${var.avl-zone}"
##   instance_type = "${var.in_type_core}"
##   key_name = "${var.aws_key_name}"
##   subnet_id = "${aws_subnet.sn_public.id}"
##
##   vpc_security_group_ids = [
##     "${aws_security_group.sg_private_ship_builds.id}"]
##
##   root_block_device {
##     volume_type = "gp2"
##     volume_size = 100
##     delete_on_termination = true
##   }
##
##   tags = {
##     Name = "admiral_test_u1604_bharath92_${var.install_version}"
##   }
## }
##
## output "admiral_test_u1604_bharath92" {
##   value = "${aws_instance.admiral_test_u1604_bharath92.private_ip}"
## }

## resource "aws_instance" "rancher_dev_bharath92" {
##   ami = "${var.ami_us_east_1_rancheros}"
##   availability_zone = "${var.avl-zone}"
##   instance_type = "${var.in_type_core}"
##   key_name = "${var.aws_key_name}"
##   subnet_id = "${aws_subnet.sn_ship_install.id}"
##   vpc_security_group_ids = [
##    "${aws_security_group.sg_private_ship_builds.id}"]
##   root_block_device {
##    volume_type = "gp2"
##    volume_size = 50
##    delete_on_termination = true
##   }
##   tags = {
##    Name = "rancher_dev_bharath92_${var.install_version}"
##   }
## }
##
## output "rancher_dev_bharath92" {
##   value = "${aws_instance.rancher_dev_bharath92.private_ip}"
## }


## CENTOS 7 test-instance
##resource "aws_instance" "test_instance_centos_7_rituraj_test_td_1" {
##  ami = "${var.ami_us_east_1_centos7}"
##  availability_zone = "${var.avl-zone}"
##  instance_type = "${var.in_type_core}"
## key_name = "${var.aws_key_name}"
##  subnet_id = "${aws_subnet.sn_ship_install.id}"
##
##  vpc_security_group_ids = [
##   "${aws_security_group.sg_private_ship_builds.id}"]
##
##  root_block_device {
##    volume_type = "gp2"
##   volume_size = 50
##    delete_on_termination = true
##  }
##
##  tags = {
##    Name = "test_instance_centos_7_rituraj_test_td_1"
## }
##}
##
##output "test_instance_centos_7_rituraj_test_td_1" {
##  value = "${aws_instance.test_instance_centos_7_rituraj_test_td_1.private_ip}"
##}
##
## RHEL 7 test instance Rituraj
##resource "aws_instance" "rituraj_x86_64_rhel7_new_test_td_1" {
##  ami = "${var.ami_us_east_1_rhel7}"
##  availability_zone = "${var.avl-zone}"
##  instance_type = "${var.in_type_core}"
##  key_name = "${var.aws_key_name}"
##  subnet_id = "${aws_subnet.sn_public.id}"
##
##  vpc_security_group_ids = [
##    "${aws_security_group.sg_private_ship_builds.id}"]
##
##  root_block_device {
##    volume_type = "gp2"
##    volume_size = 50
##    delete_on_termination = true
##  }
##
##  tags = {
##    Name = "rituraj_x86_64_rhel7_new_test_td_1"
##  }
##}
##
##output "rituraj_x86_64_rhel7_new_test_td_1" {
##  value = "${aws_instance.rituraj_x86_64_rhel7_new_test_td_1.private_ip}"
##}

# ric03uec: x86/64 Ubuntu 16.04 Instances
resource "aws_instance" "test_ric03uec_u1604" {
  ami = "${var.ami_us_east_1_ubuntu1604}"
  availability_zone = "${var.avl-zone}"
  instance_type = "${var.in_type_core}"
  key_name = "${var.aws_key_name}"
  subnet_id = "${aws_subnet.sn_public.id}"

  vpc_security_group_ids = [
    "${aws_security_group.sg_private_ship_builds.id}"]

  count = 2
  root_block_device {
    volume_type = "gp2"
    volume_size = 50
    delete_on_termination = true
  }

  tags = {
    Name = "test_ric03uec_u1604_${count.index}_${var.install_version}"
  }
}

output "test_ric03uec_u1604" {
  value = "${formatlist("instance %v has private ip %v", aws_instance.test_ric03uec_u1604.*.id, aws_instance.test_ric03uec_u1604.*.private_ip)}"
}

# ric03uec: x86/64 Ubuntu 14.04 Instances
resource "aws_instance" "test_ric03uec_u1404" {
  ami = "${var.ami_us_east_1_ubuntu1404}"
  availability_zone = "${var.avl-zone}"
  instance_type = "${var.in_type_core}"
  key_name = "${var.aws_key_name}"
  subnet_id = "${aws_subnet.sn_public.id}"

  count = 2
  vpc_security_group_ids = [
    "${aws_security_group.sg_private_ship_builds.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = 100
    delete_on_termination = true
  }

  tags = {
    Name = "test_ric03uec_u1404_${count.index}_${var.install_version}"
  }
}

output "test_ric03uec_u1404" {
  value = "${formatlist("instance %v has private ip %v", aws_instance.test_ric03uec_u1404.*.id, aws_instance.test_ric03uec_u1404.*.private_ip)}"
}

# ric03uec: x86/64 Centos 7 Instances
resource "aws_instance" "test_ric03uec_centos7" {
  ami = "${var.ami_us_east_1_centos7}"
  availability_zone = "${var.avl-zone}"
  instance_type = "${var.in_type_core}"
  key_name = "${var.aws_key_name}"
  subnet_id = "${aws_subnet.sn_public.id}"

  count = 2
  vpc_security_group_ids = [
   "${aws_security_group.sg_private_ship_builds.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = 100
    delete_on_termination = true
  }

  tags = {
    Name = "test_ric03uec_centos7_${count.index}_${var.install_version}"
  }
}

output "test_ric03uec_centos7" {
  value = "${formatlist("instance %v has private ip %v", aws_instance.test_ric03uec_centos7.*.id, aws_instance.test_ric03uec_centos7.*.private_ip)}"
}

## resource "aws_instance" "test_instance_rituraj_u1604" {
##   ami = "${var.ami_us_east_1_ubuntu1604}"
##   availability_zone = "${var.avl-zone}"
##   instance_type = "${var.in_type_core}"
##   key_name = "${var.aws_key_name}"
##   subnet_id = "${aws_subnet.sn_public.id}"
##
##   vpc_security_group_ids = [
##     "${aws_security_group.sg_private_ship_builds.id}"]
##
##   root_block_device {
##     volume_type = "gp2"
##     volume_size = 50
##     delete_on_termination = true
##   }
##
##   tags = {
##     Name = "test_instance_rituraj_u1604_${var.install_version}"
##   }
## }
##
## output "test_instance_rituraj_u1604" {
##   value = "${aws_instance.test_instance_rituraj_u1604.private_ip}"
## }
