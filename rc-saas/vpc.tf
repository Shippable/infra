#========================== VPC  =============================

# Define a vpc
resource "aws_vpc" "vpc" {
  cidr_block = "${var.cidr_block}"
  enable_dns_hostnames = true
  tags {
    Name = "${var.install_version}"
  }
}

# Internet gateway for the public subnet
resource "aws_internet_gateway" "ig" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags {
    Name = "ig_${var.install_version}"
  }
}

#========================== 0.0 Subnet =============================

# Public subnet
resource "aws_subnet" "sn_public" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.cidr_public_ship}"
  availability_zone = "${var.avl-zone}"
  map_public_ip_on_launch = true
  tags {
    Name = "sn-public_${var.install_version}"
  }
}

# Routing table for public subnet
resource "aws_route_table" "rt_public" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.ig.id}"
  }
  tags {
    Name = "rt-public_${var.install_version}"
  }
}

# Associate the routing table to public subnet
resource "aws_route_table_association" "rt_assn_public" {
  subnet_id = "${aws_subnet.sn_public.id}"
  route_table_id = "${aws_route_table.rt_public.id}"
}

#========================== inst subnet ======================
resource "aws_subnet" "sn_ship_install" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.cidr_private_ship_install}"
  availability_zone = "${var.avl-zone}"
  tags {
    Name = "sn_ship_install_${var.install_version}"
  }
}

# Routing table for private subnet
resource "aws_route_table" "rt_ship_install" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    instance_id = "${aws_instance.nat.id}"
  }
  tags {
    Name = "rt_ship_install_${var.install_version}"
  }
}

# Associate the routing table to private subnet
resource "aws_route_table_association" "rt_assn_ship_install" {
  subnet_id = "${aws_subnet.sn_ship_install.id}"
  route_table_id = "${aws_route_table.rt_ship_install.id}"
}

#========================== backup subnet ===========================
resource "aws_subnet" "sn_ship_backup" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.cidr_private_ship_backup}"
  availability_zone = "${var.avl-zone-backup}"
  tags {
    Name = "sn_ship_backup_${var.install_version}"
  }
}

# Routing table for backup subnet
resource "aws_route_table" "rt_ship_backup" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    instance_id = "${aws_instance.nat.id}"
  }
  tags {
    Name = "rt_ship_backup_${var.install_version}"
  }
}

# Associate the routing table to private subnet
resource "aws_route_table_association" "rt_assn_ship_backup" {
  subnet_id = "${aws_subnet.sn_ship_backup.id}"
  route_table_id = "${aws_route_table.rt_ship_backup.id}"
}

#========================== database subnet group  ==================
resource "aws_db_subnet_group" "sng_ship_db" {
  name       = "sng_ship_db"
  subnet_ids = ["${aws_subnet.sn_ship_install.id}", "${aws_subnet.sn_ship_backup.id}"]

  tags {
    Name = "sng_ship_db_${var.install_version}"
  }
}

#========================== ship-builds subnet ======================
resource "aws_subnet" "sn_ship_builds" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.cidr_private_ship_builds}"
  availability_zone = "${var.avl-zone}"
  tags {
    Name = "sn_ship_builds_${var.install_version}"
  }
}

# Routing table for private subnet
resource "aws_route_table" "rt_ship_builds" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    instance_id = "${aws_instance.nat.id}"
  }
  tags {
    Name = "rt_ship_builds_${var.install_version}"
  }
}

# Associate the routing table to private subnet
resource "aws_route_table_association" "rt_assn_ship_builds" {
  subnet_id = "${aws_subnet.sn_ship_builds.id}"
  route_table_id = "${aws_route_table.rt_ship_builds.id}"
}

#========================== NAT =============================

# NAT SG
resource "aws_security_group" "sg_public_nat" {
  name = "sg_public_nat_${var.install_version}"
  description = "Allow traffic to pass from the private subnet to the internet"

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "${var.cidr_private_ship_builds}",
      "${var.cidr_private_ship_install}",
    ]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  egress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "${var.cidr_block}"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "sg_public_nat_${var.install_version}"
  }
}

//this is a hack to get around double interpolation issues
//We need this in provisioner file block down below
resource "null_resource" "pemfile" {
  triggers{
    fileName ="${var.aws_key_filename}"
  }
}

# NAT Server
# resource "aws_instance" "nat" {
#   ami = "${var.ami_us_east_1_nat}"
#   availability_zone = "${var.avl-zone}"
#   instance_type = "${var.in_type_nat}"
#   key_name = "${var.aws_key_name}"

#   subnet_id = "${aws_subnet.sn_public.id}"
#   vpc_security_group_ids = [
#     "${aws_security_group.sg_public_nat.id}"]

#   provisioner "file" {
#     source = "${var.aws_key_filename}"
#     destination = "~/.ssh/${var.aws_key_filename}"

#     connection {
#       type = "ssh"
#       user = "ec2-user"
#       private_key = "${file(null_resource.pemfile.triggers.fileName)}"
#       agent = true
#     }
#   }

#   associate_public_ip_address = true
#   source_dest_check = false

#   tags = {
#     Name = "nat_${var.install_version}"
#   }
# }

# # Associate EIP, without this private SN wont work
# resource "aws_eip" "nat" {
#   instance = "${aws_instance.nat.id}"
#   vpc = true
# }

# make this routing table the main one
resource "aws_main_route_table_association" "rt_main_ship_install" {
  vpc_id = "${aws_vpc.vpc.id}"
  route_table_id = "${aws_route_table.rt_ship_install.id}"
}
