resource "aws_security_group" "sg_private_ship_install" {
  name = "sg_private_ship_install_${var.install_version}"
  description = "Private Subnet security group for install"
  vpc_id = "${aws_vpc.vpc.id}"

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
    from_port = "50003"
    to_port = "50003"
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

# instance CS-1
resource "aws_instance" "cs_1" {
  ami = "${var.ami_us_east_1_ubuntu1404}"
  availability_zone = "${var.avl-zone}"
  instance_type = "${var.in_type_core}"
  key_name = "${var.aws_key_name}"
  subnet_id = "${aws_subnet.sn_ship_install.id}"

  vpc_security_group_ids = [
    "${aws_security_group.sg_private_ship_install.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = 30
    delete_on_termination = true
  }

  tags = {
    Name = "cs_1_${var.install_version}"
  }
}

# instance CS-2
resource "aws_instance" "cs_2" {
  ami = "${var.ami_us_east_1_ubuntu1404}"
  availability_zone = "${var.avl-zone}"
  instance_type = "${var.in_type_core}"
  key_name = "${var.aws_key_name}"
  subnet_id = "${aws_subnet.sn_ship_install.id}"

  vpc_security_group_ids = [
    "${aws_security_group.sg_private_ship_install.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = 30
    delete_on_termination = true
  }

  tags = {
    Name = "cs_2_${var.install_version}"
  }
}

# instance CS-3 for swarm master
resource "aws_instance" "cs_3" {
  ami = "${var.ami_us_east_1_ubuntu1404}"
  availability_zone = "${var.avl-zone}"
  instance_type = "${var.in_type_core}"
  key_name = "${var.aws_key_name}"
  subnet_id = "${aws_subnet.sn_ship_install.id}"

  vpc_security_group_ids = [
    "${aws_security_group.sg_private_ship_install.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = 30
    delete_on_termination = true
  }

  tags = {
    Name = "cs_3_${var.install_version}"
  }
}

# instance MS-1
resource "aws_instance" "ms_3" {
  ami = "${var.ami_us_east_1_ubuntu1404}"
  availability_zone = "${var.avl-zone}"
  instance_type = "${var.in_type_core}"
  key_name = "${var.aws_key_name}"
  subnet_id = "${aws_subnet.sn_ship_install.id}"

  vpc_security_group_ids = [
    "${aws_security_group.sg_private_ship_install.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = 30
    delete_on_termination = true
  }

  tags = {
    Name = "ms_3_${var.install_version}"
  }
}

# instance MS-4
resource "aws_instance" "ms_4" {
  ami = "${var.ami_us_east_1_ubuntu1404}"
  availability_zone = "${var.avl-zone}"
  instance_type = "${var.in_type_core}"
  key_name = "${var.aws_key_name}"
  subnet_id = "${aws_subnet.sn_ship_install.id}"

  vpc_security_group_ids = [
    "${aws_security_group.sg_private_ship_install.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = 30
    delete_on_termination = true
  }

  tags = {
    Name = "ms_4_${var.install_version}"
  }
}
