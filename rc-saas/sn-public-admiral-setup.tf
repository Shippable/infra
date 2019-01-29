resource "aws_subnet" "sn_admiral_setup" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.cidr_public_admiral_setup}"
  availability_zone = "${var.avl-zone}"
  map_public_ip_on_launch = true
  tags {
    Name = "sn_admiral_setup_${var.install_version}"
  }
}

# Associate the routing table to admiral subnet
resource "aws_route_table_association" "rt_assn_admiral" {
  subnet_id = "${aws_subnet.sn_admiral_setup.id}"
  route_table_id = "${aws_route_table.rt_public.id}"
}

resource "aws_security_group" "sg_public_admiral_setup" {
  name = "sg_public_admiral_setup_${var.install_version}"
  description = "admiral security group"
  vpc_id = "${aws_vpc.vpc.id}"

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
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
      "0.0.0.0/0",
      "${var.cidr_public_ship}"]
  }

  ingress {
    from_port = "8200"
    to_port = "8200"
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = "6379"
    to_port = "6379"
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = "2377"
    to_port = "2377"
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = "5432"
    to_port = "5432"
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = "50000"
    to_port = "50000"
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = "50001"
    to_port = "50001"
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = "50002"
    to_port = "50002"
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = "50003"
    to_port = "50003"
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = "50004"
    to_port = "50004"
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = "50005"
    to_port = "50005"
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = "5672"
    to_port = "5672"
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = "15672"
    to_port = "15672"
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = "80"
    to_port = "80"
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  # for windows RDP
  ingress {
    from_port = "3389"
    to_port = "3389"
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
    Name = "sg_public_admiral_${var.install_version}"
  }
}

##################### Instances #########################
## ric03uec: x86/64 Ubuntu 16.04 Instances
##  resource "aws_instance" "admiral_ric03uec_u1604" {
##   ami = "${var.ami_us_east_1_ubuntu1604}"
##   availability_zone = "${var.avl-zone}"
##   instance_type = "${var.in_type_ms_x}"
##   key_name = "${var.aws_key_name}"
##   subnet_id = "${aws_subnet.sn_admiral_setup.id}"
##
##   vpc_security_group_ids = [
##     "${aws_security_group.sg_public_admiral_setup.id}"]
##
##   count = 2
##   root_block_device {
##     volume_type = "gp2"
##     volume_size = 50
##     delete_on_termination = true
##   }
##
##   tags = {
##     Name = "admiral_ric03uec_u1604_${count.index}_${var.install_version}"
##   }
## }
##
## output "admiral_ric03uec_u1604" {
##   value = "${formatlist("instance %v has private ip %v", aws_instance.admiral_ric03uec_u1604.*.id, aws_instance.admiral_ric03uec_u1604.*.private_ip)}"
## }


## # ric03uec: x86/64 Ubuntu 14.04 Instances
## resource "aws_instance" "admiral_ric03uec_u1404" {
##   ami = "${var.ami_us_east_1_ubuntu1404}"
##   availability_zone = "${var.avl-zone}"
##   instance_type = "${var.in_type_ms_x}"
##   key_name = "${var.aws_key_name}"
##   subnet_id = "${aws_subnet.sn_admiral_setup.id}"
##
##   count = 1
##   vpc_security_group_ids = [
##     "${aws_security_group.sg_public_admiral_setup.id}"]
##
##   root_block_device {
##     volume_type = "gp2"
##     volume_size = 100
##     delete_on_termination = true
##   }
##
##   tags = {
##     Name = "admiral_ric03uec_u1404_${count.index}_${var.install_version}"
##   }
## }
##
## output "admiral_ric03uec_u1404" {
##   value = "${formatlist("instance %v has private ip %v", aws_instance.admiral_ric03uec_u1404.*.id, aws_instance.admiral_ric03uec_u1404.*.private_ip)}"
## }

# ric03uec: x86/64 Centos 7 Instances
resource "aws_instance" "admiral_ric03uec_centos7" {
  ami = "${var.ami_us_east_1_centos7}"
  availability_zone = "${var.avl-zone}"
  instance_type = "${var.in_type_ms_x}"
  key_name = "${var.aws_key_name}"
  subnet_id = "${aws_subnet.sn_admiral_setup.id}"

  count = 2
  vpc_security_group_ids = [
    "${aws_security_group.sg_public_admiral_setup.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = 100
    delete_on_termination = true
  }

  tags = {
    Name = "admiral_ric03uec_centos7_${count.index}_${var.install_version}"
  }
}

output "admiral_ric03uec_centos7" {
  value = "${formatlist("instance %v has private ip %v", aws_instance.admiral_ric03uec_centos7.*.id, aws_instance.admiral_ric03uec_centos7.*.private_ip)}"
}

## ric03uec:  x86/64 RHEL7 instance
## resource "aws_instance" "admiral_ric03uec_rhel7" {
##   ami = "${var.ami_us_east_1_rhel7}"
##   availability_zone = "${var.avl-zone}"
##   instance_type = "${var.in_type_ms_x}"
##   key_name = "${var.aws_key_name}"
##   subnet_id = "${aws_subnet.sn_admiral_setup.id}"
##
##   count = 2
##   vpc_security_group_ids = [
##     "${aws_security_group.sg_public_admiral_setup.id}"]
##
##   root_block_device {
##     volume_type = "gp2"
##     volume_size = 100
##     delete_on_termination = true
##   }
##
##   tags = {
##     Name = "admiral_ric03uec_rhel7_${count.index}_${var.install_version}"
##   }
## }
##
## output "admiral_ric03uec_rhel7" {
##   value = "${formatlist("instance %v has private ip %v", aws_instance.admiral_ric03uec_rhel7.*.id, aws_instance.admiral_ric03uec_rhel7.*.private_ip)}"
## }

## ric03uec:  x86/64 WindowsServer
## resource "aws_instance" "admiral_ric03uec_win16" {
##   ami = "${var.ami_us_east_1_win16}"
##   availability_zone = "${var.avl-zone}"
##   instance_type = "${var.in_type_bld}"
##   key_name = "${var.aws_key_name}"
##   subnet_id = "${aws_subnet.sn_admiral_setup.id}"
##
##   count = 1
##   vpc_security_group_ids = [
##     "${aws_security_group.sg_public_admiral_setup.id}"]
##
##   root_block_device {
##     volume_type = "gp2"
##     volume_size = 100
##     delete_on_termination = true
##   }
##
##   tags = {
##     Name = "admiral_ric03uec_win16_${count.index}_${var.install_version}"
##   }
## }
##
## output "admiral_ric03uec_win16" {
##   value = "${formatlist("instance %v has private ip %v", aws_instance.admiral_ric03uec_win16.*.id, aws_instance.admiral_ric03uec_win16.*.private_ip)}"
## }

## trriplejay: x86/64 Ubuntu 16.04 Instances
# resource "aws_instance" "admiral_trriplejay_u1604" {
#   ami = "${var.ami_us_east_1_ubuntu1604}"
#   availability_zone = "${var.avl-zone}"
#   instance_type = "${var.in_type_ms_x}"
#   key_name = "${var.aws_key_name}"
#   subnet_id = "${aws_subnet.sn_admiral_setup.id}"

#   vpc_security_group_ids = [
#     "${aws_security_group.sg_public_admiral_setup.id}"]

#   count = 1
#   root_block_device {
#     volume_type = "gp2"
#     volume_size = 50
#     delete_on_termination = true
#   }

#   tags = {
#     Name = "admiral_trriplejay_u1604_${count.index}_${var.install_version}"
#   }
# }

# output "admiral_trriplejay_u1604" {
#   value = "${formatlist("instance %v has public ip %v", aws_instance.admiral_trriplejay_u1604.*.id, aws_instance.admiral_trriplejay_u1604.*.public_ip)}"
# }

## bharath92:  x86/64 RHEL7 instance
## resource "aws_instance" "admiral_bharath92_rhel7" {
##   ami = "${var.ami_us_east_1_rhel7}"
##   availability_zone = "${var.avl-zone}"
##   instance_type = "${var.in_type_ms_x}"
##   key_name = "${var.aws_key_name}"
##   subnet_id = "${aws_subnet.sn_admiral_setup.id}"
##   count = 2
##   vpc_security_group_ids = [
##     "${aws_security_group.sg_public_admiral_setup.id}"]
##   root_block_device {
##     volume_type = "gp2"
##     volume_size = 100
##     delete_on_termination = true
##   }
##   tags = {
##     Name = "admiral_bharath92_rhel7_${count.index}_${var.install_version}"
##   }
## }
##
## output "admiral_bharath92_rhel7" {
##   value = "${formatlist("instance %v has private ip %v", aws_instance.admiral_bharath92_rhel7.*.id, aws_instance.admiral_bharath92_rhel7.*.private_ip)}"
## }
