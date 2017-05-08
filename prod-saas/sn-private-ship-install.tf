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

// # CS-G-1 Instance
// resource "aws_instance" "cs_g_1" {
//   ami = "${var.ami_us_east_1_ubuntu1404_20170310}"
//   availability_zone = "${var.avl-zone}"
//   instance_type = "${var.in_type_core}"
//   key_name = "${var.aws_key_name}"
//   subnet_id = "${var.sn_ship_install_id}"
//
//   vpc_security_group_ids = [
//     "${aws_security_group.sg_private_ship_install.id}"]
//
//   root_block_device {
//     volume_type = "gp2"
//     volume_size = 30
//     delete_on_termination = true
//   }
//
//   tags = {
//     Name = "cs_g_1_${var.install_version}"
//   }
//
//   provisioner "remote-exec" {
//     inline = [
//       "(sudo crontab -l; echo '0 */2 * * * docker service update --force api') | sudo crontab -"
//     ]
//
//     connection {
//       type = "ssh"
//       user = "ubuntu"
//       private_key = "${file(null_resource.pemfile.triggers.fileName)}"
//       agent = true
//     }
//   }
// }
//
// # MS-G-1 Instance
// resource "aws_instance" "ms_g_1" {
//   ami = "${var.ami_us_east_1_ubuntu1404_20170310}"
//   availability_zone = "${var.avl-zone}"
//   instance_type = "${var.in_type_ms2}"
//   key_name = "${var.aws_key_name}"
//   subnet_id = "${var.sn_ship_install_id}"
//   ebs_optimized = true
//
//   vpc_security_group_ids = [
//     "${aws_security_group.sg_private_ship_install.id}"]
//
//   root_block_device {
//     volume_type = "gp2"
//     volume_size = 30
//     delete_on_termination = true
//   }
//
//   tags = {
//     Name = "ms_g_1_${var.install_version}"
//   }
// }
//
// # MS-G-2 Instance
// resource "aws_instance" "ms_g_2" {
//   ami = "${var.ami_us_east_1_ubuntu1404_20170310}"
//   availability_zone = "${var.avl-zone}"
//   instance_type = "${var.in_type_ms2}"
//   key_name = "${var.aws_key_name}"
//   subnet_id = "${var.sn_ship_install_id}"
//   ebs_optimized = true
//
//   vpc_security_group_ids = [
//     "${aws_security_group.sg_private_ship_install.id}"]
//
//   root_block_device {
//     volume_type = "gp2"
//     volume_size = 30
//     delete_on_termination = true
//   }
//
//   tags = {
//     Name = "ms_g_2_${var.install_version}"
//   }
// }
//
// # MS-G-3 Instance
// resource "aws_instance" "ms_g_3" {
//   ami = "${var.ami_us_east_1_ubuntu1404_20170310}"
//   availability_zone = "${var.avl-zone}"
//   instance_type = "${var.in_type_ms2}"
//   key_name = "${var.aws_key_name}"
//   subnet_id = "${var.sn_ship_install_id}"
//   ebs_optimized = true
//
//   vpc_security_group_ids = [
//     "${aws_security_group.sg_private_ship_install.id}"]
//
//   root_block_device {
//     volume_type = "gp2"
//     volume_size = 30
//     delete_on_termination = true
//   }
//
//   tags = {
//     Name = "ms_g_3_${var.install_version}"
//   }
// }
//
// # MS-G-4 Instance
// resource "aws_instance" "ms_g_4" {
//   ami = "${var.ami_us_east_1_ubuntu1404_20170310}"
//   availability_zone = "${var.avl-zone}"
//   instance_type = "${var.in_type_ms2}"
//   key_name = "${var.aws_key_name}"
//   subnet_id = "${var.sn_ship_install_id}"
//   ebs_optimized = true
//
//   vpc_security_group_ids = [
//     "${aws_security_group.sg_private_ship_install.id}"]
//
//   root_block_device {
//     volume_type = "gp2"
//     volume_size = 30
//     delete_on_termination = true
//   }
//
//   tags = {
//     Name = "ms_g_4_${var.install_version}"
//   }
// }
//
// # MS-G-5 Instance
// resource "aws_instance" "ms_g_5" {
//   ami = "${var.ami_us_east_1_ubuntu1404_20170310}"
//   availability_zone = "${var.avl-zone}"
//   instance_type = "${var.in_type_ms2}"
//   key_name = "${var.aws_key_name}"
//   subnet_id = "${var.sn_ship_install_id}"
//   ebs_optimized = true
//
//   vpc_security_group_ids = [
//     "${aws_security_group.sg_private_ship_install.id}"]
//
//   root_block_device {
//     volume_type = "gp2"
//     volume_size = 30
//     delete_on_termination = true
//   }
//
//   tags = {
//     Name = "ms_g_5_${var.install_version}"
//   }
// }
//
// # MS-G-6 Instance
// resource "aws_instance" "ms_g_6" {
//   ami = "${var.ami_us_east_1_ubuntu1404_20170310}"
//   availability_zone = "${var.avl-zone}"
//   instance_type = "${var.in_type_ms2}"
//   key_name = "${var.aws_key_name}"
//   subnet_id = "${var.sn_ship_install_id}"
//   ebs_optimized = true
//
//   vpc_security_group_ids = [
//     "${aws_security_group.sg_private_ship_install.id}"]
//
//   root_block_device {
//     volume_type = "gp2"
//     volume_size = 30
//     delete_on_termination = true
//   }
//
//   tags = {
//     Name = "ms_g_6_${var.install_version}"
//   }
// }

# ---------------
# BLUE INSTANCES
# ---------------

# CS-B-1 Instance
resource "aws_instance" "cs_b_1" {
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
    Name = "cs_b_1_${var.install_version}"
  }

  provisioner "remote-exec" {
    inline = [
      "(sudo crontab -l; echo '0 */2 * * * docker service update --force api') | sudo crontab -"
    ]

    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = "${file(null_resource.pemfile.triggers.fileName)}"
      agent = true
    }
  }
}

# MS-B-1 Instance
resource "aws_instance" "ms_b_1" {
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
    Name = "ms_b_1_${var.install_version}"
  }
}

# MS-B-2 Instance
resource "aws_instance" "ms_b_2" {
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
    Name = "ms_b_2_${var.install_version}"
  }
}

# MS-B-3 Instance
resource "aws_instance" "ms_b_3" {
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
    Name = "ms_b_3_${var.install_version}"
  }
}

# MS-B-4 Instance
resource "aws_instance" "ms_b_4" {
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
    Name = "ms_b_4_${var.install_version}"
  }
}

# MS-B-5 Instance
resource "aws_instance" "ms_b_5" {
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
    Name = "ms_b_5_${var.install_version}"
  }
}

# MS-B-6 Instance
resource "aws_instance" "ms_b_6" {
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
    Name = "ms_b_6_${var.install_version}"
  }
}
