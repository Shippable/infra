resource "aws_subnet" "sn_proxy_install" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.cidr_private_proxy_install}"
  availability_zone = "${var.avl-zone}"
  map_public_ip_on_launch = true
  tags {
    Name = "sn_private_proxy_install_${var.install_version}"
  }
}

resource "aws_security_group" "sg_private_proxy_install" {
  name = "sg_private_proxy_install_${var.install_version}"
  description = "Security group for machines running behind proxy"
  vpc_id = "${aws_vpc.vpc.id}"

  ## Allow inbound traffic from proxy only
  ingress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = [
      "${var.cidr_public_proxy}",
      "${var.cidr_private_proxy_install}"]
  }

  ## Allow outbound traffic to proxy only
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "${var.cidr_public_proxy}",
      "${var.cidr_private_proxy_install}"]
  }

  ## Allow inbound ssh from public subnet
  ingress {
    from_port = "22"
    to_port = "22"
    protocol = "tcp"
    cidr_blocks = [
      "${var.cidr_public_ship}"]
  }

  tags {
    Name = "sg_private_proxy_install_${var.install_version}"
  }
}

##################### Proxy Instances #########################
# resource "aws_instance" "proxy_onebox" {
#   ami = "${var.ami_us_east_1_ubuntu1604}"
#   availability_zone = "${var.avl-zone}"
#   instance_type = "${var.in_type_ms_x}"
#   key_name = "${var.aws_key_name}"
#   subnet_id = "${aws_subnet.sn_proxy_install.id}"
#
#   vpc_security_group_ids = [
#     "${aws_security_group.sg_private_proxy_install.id}"]
#
#   root_block_device {
#     volume_type = "gp2"
#     volume_size = 20
#     delete_on_termination = true
#   }
#
#   tags = {
#     Name = "proxy_onebox_${var.install_version}"
#   }
# }
#
# output "proxy_onebox_ip" {
#   value = "${aws_instance.proxy_onebox.private_ip}"
# }
#
# resource "aws_instance" "proxy_build" {
#   ami = "${var.ami_us_east_1_ubuntu1604}"
#   availability_zone = "${var.avl-zone}"
#   instance_type = "${var.in_type_ms_x}"
#   key_name = "${var.aws_key_name}"
#   subnet_id = "${aws_subnet.sn_proxy_install.id}"
#
#   vpc_security_group_ids = [
#     "${aws_security_group.sg_private_proxy_install.id}"]
#
#   root_block_device {
#     volume_type = "gp2"
#     volume_size = 20
#     delete_on_termination = true
#   }
#
#   tags = {
#     Name = "proxy_build_${var.install_version}"
#   }
# }
#
# output "proxy_build_ip" {
#   value = "${aws_instance.proxy_build.private_ip}"
# }
