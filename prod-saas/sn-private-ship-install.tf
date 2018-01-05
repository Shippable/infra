resource "aws_security_group" "sg_private_ship_install" {
  name = "sg_private_ship_install_${var.install_version}"
  description = "Private Subnet security group for install"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = "22"
    to_port = "22"
    protocol = "tcp"
    cidr_blocks = [
      "${var.cidr_public_ship}"]
  }
  ingress {
    from_port = "50000"
    to_port = "50000"
    protocol = "tcp"
    cidr_blocks = [
      "${var.cidr_public_ship}"]
  }
  ingress {
    from_port = "50001"
    to_port = "50001"
    protocol = "tcp"
    cidr_blocks = [
      "${var.cidr_public_ship}"]
  }
  ingress {
    from_port = "50002"
    to_port = "50002"
    protocol = "tcp"
    cidr_blocks = [
      "${var.cidr_public_ship}"]
  }
  ingress {
    from_port = "50004"
    to_port = "50004"
    protocol = "tcp"
    cidr_blocks = [
      "${var.cidr_public_ship}"]
  }
  ingress {
    from_port = "50005"
    to_port = "50005"
    protocol = "tcp"
    cidr_blocks = [
      "${var.cidr_public_ship}"]
  }
  ingress {
    from_port = "5672"
    to_port = "5672"
    protocol = "tcp"
    cidr_blocks = [
      "${var.cidr_public_ship}"]
  }
  ingress {
    from_port = "15672"
    to_port = "15672"
    protocol = "tcp"
    cidr_blocks = [
      "${var.cidr_public_ship}"]
  }
  ingress {
    from_port = "80"
    to_port = "80"
    protocol = "tcp"
    cidr_blocks = [
      "${var.cidr_public_ship}"]
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "${var.cidr_private_ship_install}"]
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "${var.cidr_private_ship_ecs}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  tags {
    Name = "sg_private_ship_install_${var.install_version}"
  }
}

# ---------------
# GREEN INSTANCES
# ---------------

# CS-G-1 Instance
resource "aws_instance" "cs_g_1" {
 ami = "${var.ami_us_east_1_ubuntu1404_20170310}"
 availability_zone = "${var.avl-zone}"
 instance_type = "${var.in_type_core}"
 key_name = "${var.aws_key_name}"
 subnet_id = "${var.sn_ship_install_id}"

 vpc_security_group_ids = [
   "${aws_security_group.sg_private_ship_install.id}"]

 root_block_device {
   volume_type = "gp2"
   volume_size = 30
   delete_on_termination = true
 }

 tags = {
   Name = "cs_g_1_${var.install_version}"
 }
}

output "cs_g_1_ip" {
 value = "${aws_instance.cs_g_1.private_ip}"
}


# MS-G-* Instance
resource "aws_instance" "ms_g" {
 ami = "${var.ami_us_east_1_ubuntu1404_20170310}"
 availability_zone = "${var.avl-zone}"
 instance_type = "${var.in_type_ms_box}"
 key_name = "${var.aws_key_name}"
 subnet_id = "${var.sn_ship_install_id}"
 ebs_optimized = true

 count = 6
 vpc_security_group_ids = [
   "${aws_security_group.sg_private_ship_install.id}"]

 root_block_device {
   volume_type = "gp2"
   volume_size = 30
   delete_on_termination = true
 }

 tags = {
   Name = "ms_g_${count.index}_${var.install_version}"
 }
}
output "ms_g_addresses" {
 value = "${formatlist("instance %v has private ip %v", aws_instance.ms_g.*.id, aws_instance.ms_g.*.private_ip)}"
}

# ---------------
# BLUE INSTANCES
# ---------------

# CS-B Instance
resource "aws_instance" "cs_b" {
 ami = "${var.ami_us_east_1_ubuntu1404_20170310}"
 availability_zone = "${var.avl-zone}"
 instance_type = "${var.in_type_core}"
 key_name = "${var.aws_key_name}"
 subnet_id = "${var.sn_ship_install_id}"

 vpc_security_group_ids = [
   "${aws_security_group.sg_private_ship_install.id}"]

 root_block_device {
   volume_type = "gp2"
   volume_size = 30
   delete_on_termination = true
 }

 tags = {
   Name = "cs_b_${var.install_version}"
 }
}

output "cs_b_ip" {
 value = "${aws_instance.cs_b.private_ip}"
}

# MS-B-* Instance
resource "aws_instance" "ms_b" {
 ami = "${var.ami_us_east_1_ubuntu1404_20170310}"
 availability_zone = "${var.avl-zone}"
 instance_type = "${var.in_type_ms_box}"
 key_name = "${var.aws_key_name}"
 subnet_id = "${var.sn_ship_install_id}"
 ebs_optimized = true

 count = 6
 vpc_security_group_ids = [
   "${aws_security_group.sg_private_ship_install.id}"]

 root_block_device {
   volume_type = "gp2"
   volume_size = 30
   delete_on_termination = true
 }

 tags = {
   Name = "ms_b_${count.index}_${var.install_version}"
 }
}
output "ms_b_addresses" {
 value = "${formatlist("instance %v has private ip %v", aws_instance.ms_b.*.id, aws_instance.ms_b.*.private_ip)}"
}
