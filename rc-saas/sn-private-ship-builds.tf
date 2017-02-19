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

//resource "aws_instance" "bld_hosts" {
//  count = 2
//  ami = "${var.ami_us_east_1_ubuntu1404}"
//  availability_zone = "${var.avl-zone}"
//  instance_type = "${var.in_type_core}"
//  key_name = "${var.aws_key_name}"
//  subnet_id = "${aws_subnet.sn_ship_builds.id}"
//
//  vpc_security_group_ids = [
//    "${aws_security_group.sg_private_ship_builds.id}"]
//
//  root_block_device {
//    volume_type = "gp2"
//    volume_size = 30
//    delete_on_termination = true
//  }
//
//  tags = {
//    Name = "bld_${count.index}_${var.install_version}"
//  }
//}
