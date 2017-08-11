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

# MS-G-1 Instance
resource "aws_instance" "ms_g_1" {
  ami = "${var.ami_us_east_1_ubuntu1404_20170310}"
  availability_zone = "${var.avl-zone}"
  instance_type = "${var.in_type_ms2}"
  key_name = "${var.aws_key_name}"
  subnet_id = "${var.sn_ship_install_id}"
  ebs_optimized = true

  vpc_security_group_ids = [
    "${aws_security_group.sg_private_ship_install.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = 30
    delete_on_termination = true
  }

  tags = {
    Name = "ms_g_1_${var.install_version}"
  }
}

output "ms_g_1_ip" {
  value = "${aws_instance.ms_g_1.private_ip}"
}

# MS-G-2 Instance
resource "aws_instance" "ms_g_2" {
  ami = "${var.ami_us_east_1_ubuntu1404_20170310}"
  availability_zone = "${var.avl-zone}"
  instance_type = "${var.in_type_ms2}"
  key_name = "${var.aws_key_name}"
  subnet_id = "${var.sn_ship_install_id}"
  ebs_optimized = true

  vpc_security_group_ids = [
    "${aws_security_group.sg_private_ship_install.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = 30
    delete_on_termination = true
  }

  tags = {
    Name = "ms_g_2_${var.install_version}"
  }
}

output "ms_g_2_ip" {
  value = "${aws_instance.ms_g_2.private_ip}"
}

# MS-G-3 Instance
resource "aws_instance" "ms_g_3" {
  ami = "${var.ami_us_east_1_ubuntu1404_20170310}"
  availability_zone = "${var.avl-zone}"
  instance_type = "${var.in_type_ms2}"
  key_name = "${var.aws_key_name}"
  subnet_id = "${var.sn_ship_install_id}"
  ebs_optimized = true

  vpc_security_group_ids = [
    "${aws_security_group.sg_private_ship_install.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = 30
    delete_on_termination = true
  }

  tags = {
    Name = "ms_g_3_${var.install_version}"
  }
}

output "ms_g_3_ip" {
  value = "${aws_instance.ms_g_3.private_ip}"
}


# MS-G-4 Instance
resource "aws_instance" "ms_g_4" {
  ami = "${var.ami_us_east_1_ubuntu1404_20170310}"
  availability_zone = "${var.avl-zone}"
  instance_type = "${var.in_type_ms2}"
  key_name = "${var.aws_key_name}"
  subnet_id = "${var.sn_ship_install_id}"
  ebs_optimized = true

  vpc_security_group_ids = [
    "${aws_security_group.sg_private_ship_install.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = 30
    delete_on_termination = true
  }

  tags = {
    Name = "ms_g_4_${var.install_version}"
  }
}

output "ms_g_4_ip" {
  value = "${aws_instance.ms_g_4.private_ip}"
}


# MS-G-5 Instance
resource "aws_instance" "ms_g_5" {
  ami = "${var.ami_us_east_1_ubuntu1404_20170310}"
  availability_zone = "${var.avl-zone}"
  instance_type = "${var.in_type_ms2}"
  key_name = "${var.aws_key_name}"
  subnet_id = "${var.sn_ship_install_id}"
  ebs_optimized = true

  vpc_security_group_ids = [
    "${aws_security_group.sg_private_ship_install.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = 30
    delete_on_termination = true
  }

  tags = {
    Name = "ms_g_5_${var.install_version}"
  }
}

output "ms_g_5_ip" {
  value = "${aws_instance.ms_g_5.private_ip}"
}


# MS-G-6 Instance
resource "aws_instance" "ms_g_6" {
  ami = "${var.ami_us_east_1_ubuntu1404_20170310}"
  availability_zone = "${var.avl-zone}"
  instance_type = "${var.in_type_ms2}"
  key_name = "${var.aws_key_name}"
  subnet_id = "${var.sn_ship_install_id}"
  ebs_optimized = true

  vpc_security_group_ids = [
    "${aws_security_group.sg_private_ship_install.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = 30
    delete_on_termination = true
  }

  tags = {
    Name = "ms_g_6_${var.install_version}"
  }
}

output "ms_g_6_ip" {
  value = "${aws_instance.ms_g_6.private_ip}"
}

# MS-G-7 Instance
resource "aws_instance" "ms_g_7" {
  ami = "${var.ami_us_east_1_ubuntu1404_20170310}"
  availability_zone = "${var.avl-zone}"
  instance_type = "${var.in_type_ms2}"
  key_name = "${var.aws_key_name}"
  subnet_id = "${var.sn_ship_install_id}"
  ebs_optimized = true

  vpc_security_group_ids = [
    "${aws_security_group.sg_private_ship_install.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = 30
    delete_on_termination = true
  }

  tags = {
    Name = "ms_g_7_${var.install_version}"
  }
}

output "ms_g_7_ip" {
  value = "${aws_instance.ms_g_7.private_ip}"
}

# MS-G-8 Instance
resource "aws_instance" "ms_g_8" {
  ami = "${var.ami_us_east_1_ubuntu1404_20170310}"
  availability_zone = "${var.avl-zone}"
  instance_type = "${var.in_type_ms2}"
  key_name = "${var.aws_key_name}"
  subnet_id = "${var.sn_ship_install_id}"
  ebs_optimized = true

  vpc_security_group_ids = [
    "${aws_security_group.sg_private_ship_install.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = 30
    delete_on_termination = true
  }

  tags = {
    Name = "ms_g_8_${var.install_version}"
  }
}

output "ms_g_8_ip" {
  value = "${aws_instance.ms_g_8.private_ip}"
}

# MS-G-9 Instance
resource "aws_instance" "ms_g_9" {
  ami = "${var.ami_us_east_1_ubuntu1404_20170310}"
  availability_zone = "${var.avl-zone}"
  instance_type = "${var.in_type_ms2}"
  key_name = "${var.aws_key_name}"
  subnet_id = "${var.sn_ship_install_id}"
  ebs_optimized = true

  vpc_security_group_ids = [
    "${aws_security_group.sg_private_ship_install.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = 30
    delete_on_termination = true
  }

  tags = {
    Name = "ms_g_9_${var.install_version}"
  }
}

output "ms_g_9_ip" {
  value = "${aws_instance.ms_g_9.private_ip}"
}

# MS-G-10 Instance
resource "aws_instance" "ms_g_10" {
  ami = "${var.ami_us_east_1_ubuntu1404_20170310}"
  availability_zone = "${var.avl-zone}"
  instance_type = "${var.in_type_ms2}"
  key_name = "${var.aws_key_name}"
  subnet_id = "${var.sn_ship_install_id}"
  ebs_optimized = true

  vpc_security_group_ids = [
    "${aws_security_group.sg_private_ship_install.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = 30
    delete_on_termination = true
  }

  tags = {
    Name = "ms_g_10_${var.install_version}"
  }
}

output "ms_g_10_ip" {
  value = "${aws_instance.ms_g_10.private_ip}"
}

# MS-G-11 Instance
resource "aws_instance" "ms_g_11" {
  ami = "${var.ami_us_east_1_ubuntu1404_20170310}"
  availability_zone = "${var.avl-zone}"
  instance_type = "${var.in_type_ms2}"
  key_name = "${var.aws_key_name}"
  subnet_id = "${var.sn_ship_install_id}"
  ebs_optimized = true

  vpc_security_group_ids = [
    "${aws_security_group.sg_private_ship_install.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = 30
    delete_on_termination = true
  }

  tags = {
    Name = "ms_g_11_${var.install_version}"
  }
}

output "ms_g_11_ip" {
  value = "${aws_instance.ms_g_11.private_ip}"
}

# MS-G-12 Instance
resource "aws_instance" "ms_g_12" {
  ami = "${var.ami_us_east_1_ubuntu1404_20170310}"
  availability_zone = "${var.avl-zone}"
  instance_type = "${var.in_type_ms2}"
  key_name = "${var.aws_key_name}"
  subnet_id = "${var.sn_ship_install_id}"
  ebs_optimized = true

  vpc_security_group_ids = [
    "${aws_security_group.sg_private_ship_install.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = 30
    delete_on_termination = true
  }

  tags = {
    Name = "ms_g_12_${var.install_version}"
  }
}

output "ms_g_12_ip" {
  value = "${aws_instance.ms_g_12.private_ip}"
}

# MS-G-13 Instance
resource "aws_instance" "ms_g_13" {
  ami = "${var.ami_us_east_1_ubuntu1404_20170310}"
  availability_zone = "${var.avl-zone}"
  instance_type = "${var.in_type_ms2}"
  key_name = "${var.aws_key_name}"
  subnet_id = "${var.sn_ship_install_id}"
  ebs_optimized = true

  vpc_security_group_ids = [
    "${aws_security_group.sg_private_ship_install.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = 30
    delete_on_termination = true
  }

  tags = {
    Name = "ms_g_13_${var.install_version}"
  }
}

output "ms_g_13_ip" {
  value = "${aws_instance.ms_g_13.private_ip}"
}

# MS-G-14 Instance
resource "aws_instance" "ms_g_14" {
  ami = "${var.ami_us_east_1_ubuntu1404_20170310}"
  availability_zone = "${var.avl-zone}"
  instance_type = "${var.in_type_ms2}"
  key_name = "${var.aws_key_name}"
  subnet_id = "${var.sn_ship_install_id}"
  ebs_optimized = true

  vpc_security_group_ids = [
    "${aws_security_group.sg_private_ship_install.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = 30
    delete_on_termination = true
  }

  tags = {
    Name = "ms_g_14_${var.install_version}"
  }
}

output "ms_g_14_ip" {
  value = "${aws_instance.ms_g_14.private_ip}"
}

# MS-G-15 Instance
resource "aws_instance" "ms_g_15" {
  ami = "${var.ami_us_east_1_ubuntu1404_20170310}"
  availability_zone = "${var.avl-zone}"
  instance_type = "${var.in_type_ms2}"
  key_name = "${var.aws_key_name}"
  subnet_id = "${var.sn_ship_install_id}"
  ebs_optimized = true

  vpc_security_group_ids = [
    "${aws_security_group.sg_private_ship_install.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = 30
    delete_on_termination = true
  }

  tags = {
    Name = "ms_g_15_${var.install_version}"
  }
}

output "ms_g_15_ip" {
  value = "${aws_instance.ms_g_15.private_ip}"
}

# MS-G-16 Instance
resource "aws_instance" "ms_g_16" {
  ami = "${var.ami_us_east_1_ubuntu1404_20170310}"
  availability_zone = "${var.avl-zone}"
  instance_type = "${var.in_type_ms2}"
  key_name = "${var.aws_key_name}"
  subnet_id = "${var.sn_ship_install_id}"
  ebs_optimized = true

  vpc_security_group_ids = [
    "${aws_security_group.sg_private_ship_install.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = 30
    delete_on_termination = true
  }

  tags = {
    Name = "ms_g_16_${var.install_version}"
  }
}

output "ms_g_16_ip" {
  value = "${aws_instance.ms_g_16.private_ip}"
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
  instance_type = "${var.in_type_ms}"
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
