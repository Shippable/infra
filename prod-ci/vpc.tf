#========================== nat-gateway ======================
# create a EIP, to associate it to NAT gateway
resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = "${aws_eip.nat_eip.id}"
  subnet_id = "${var.public_subnet_id}"
}

#========================== nat-builds private subnet ======================
resource "aws_subnet" "nat_builds" {
  vpc_id = "${var.vpc_id}"
  cidr_block = "${var.cidr_private_nat_builds}"
  availability_zone = "${var.avl_zone}"
  tags {
    Name = "nat_builds_${var.install_version}"
  }
}

# Routing table for nat-builds private subnet
resource "aws_route_table" "rt_nat_builds" {
  vpc_id = "${var.vpc_id}"
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat_gateway.id}"
  }
  tags {
    Name = "rt_nat_builds_${var.install_version}"
  }
}

# Associate the routing table to nat-builds private subnet
resource "aws_route_table_association" "rt_assn_nat_builds" {
  subnet_id = "${aws_subnet.nat_builds.id}"
  route_table_id = "${aws_route_table.rt_nat_builds.id}"
}

# Outputs
output "nat_public_ip" {
 value = "${aws_eip.nat_eip.public_ip}"
}

output "nat_builds_private_subnetId" {
 value = "${aws_subnet.nat_builds.id}"
}
