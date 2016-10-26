//#========================== VPC  =============================
//
//# Internet gateway for the public subnet
////resource "aws_internet_gateway" "ig" {
////  vpc_id = "${var.vpc_id}"
////  tags {
////    Name = "ig_${var.install_version}"
////  }
////}
//
//#========================== 0.0 Subnet =============================
//
//# Routing table for public subnet
////resource "aws_route_table" "rt_public" {
////  vpc_id = "${var.vpc_id}"
////  route {
////    cidr_block = "0.0.0.0/0"
////    gateway_id = "${aws_internet_gateway.ig.id}"
////  }
////  tags {
////    Name = "rt-public_${var.install_version}"
////  }
////}
//
////# Associate the routing table to public subnet
////resource "aws_route_table_association" "rt_assn_public" {
////  subnet_id = "${var.sn_public_ship_id}"
////  route_table_id = "${aws_route_table.rt_public.id}"
////}
//
//#========================== inst subnet ======================
//# Routing table for private subnet
//resource "aws_route_table" "rt_ship_install" {
//  vpc_id = "${var.vpc_id}"
//  route {
//    cidr_block = "0.0.0.0/0"
//    instance_id = "${aws_instance.nat.id}"
//  }
//  tags {
//    Name = "rt_ship_install_${var.install_version}"
//  }
//}
//
////# Associate the routing table to private subnet
////resource "aws_route_table_association" "rt_assn_ship_install" {
////  subnet_id = "${var.sn_ship_install_id}"
////  route_table_id = "${aws_route_table.rt_ship_install.id}"
////}
//
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
      "${var.cidr_private_ship_install}"
    ]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "${var.cidr_public_ship}"
    ]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
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

  vpc_id = "${var.vpc_id}"

  tags {
    Name = "sg_public_nat_${var.install_version}"
  }
}

//this is a hack to get around double interpolation issues
//We need this in provisioner file block down below
resource "null_resource" "pemfile" {
  triggers {
    fileName = "${var.aws_key_filename}"
  }
}

//# NAT Server
//resource "aws_instance" "nat" {
//  ami = "${var.ami_us_east_1_nat}"
//  availability_zone = "${var.avl-zone}"
//  instance_type = "${var.in_type_nat}"
//  key_name = "${var.aws_key_name}"
//
//  subnet_id = "${var.sn_public_ship_id}"
//  vpc_security_group_ids = [
//    "${aws_security_group.sg_public_nat.id}"]
//
//  provisioner "file" {
//    source = "${var.aws_key_filename}"
//    destination = "~/.ssh/${var.aws_key_filename}"
//
//    connection {
//      type = "ssh"
//      user = "ec2-user"
//      private_key = "${file(null_resource.pemfile.triggers.fileName)}"
//      agent = true
//    }
//  }
//
//  associate_public_ip_address = true
//  source_dest_check = false
//
//  tags = {
//    Name = "nat_${var.install_version}"
//  }
//}
//
//# Associate EIP, without this private SN wont work
//resource "aws_eip" "nat" {
//  instance = "${aws_instance.nat.id}"
//  vpc = true
//}
//
////# make this routing table the main one
////resource "aws_main_route_table_association" "rt_main_ship_install" {
////  vpc_id = "${var.vpc_id}"
////  route_table_id = "${aws_route_table.rt_ship_install.id}"
////}
