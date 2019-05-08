resource "aws_subnet" "sn_proxy_setup" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.cidr_public_proxy}"
  availability_zone = "${var.avl-zone}"
  map_public_ip_on_launch = true
  tags {
    Name = "sn_public_proxy_${var.install_version}"
  }
}

# Associate the routing table to admiral subnet
resource "aws_route_table_association" "rt_assn_proxy" {
  subnet_id = "${aws_subnet.sn_proxy_setup.id}"
  route_table_id = "${aws_route_table.rt_public.id}"
}

resource "aws_security_group" "sg_public_proxy" {
  name = "sg_public_proxy_${var.install_version}"
  description = "proxy machines security group"
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

  # api
  ingress {
    from_port = "30000"
    to_port = "30000"
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  # www
  ingress {
    from_port = "30001"
    to_port = "30001"
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  # rabbitmq server
  ingress {
    from_port = "30200"
    to_port = "30200"
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  # rabbitmq admin
  ingress {
    from_port = "30201"
    to_port = "30201"
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  # ribbit
  ingress {
    from_port = "50003"
    to_port = "50003"
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
    Name = "sg_public_proxy_${var.install_version}"
  }
}

##################### Proxy Instances #########################
resource "aws_instance" "artifactory_proxy" {
  ami = "${var.ami_us_east_1_ubuntu1604}"
  availability_zone = "${var.avl-zone}"
  instance_type = "${var.in_type_small}"
  key_name = "${var.aws_key_name}"
  subnet_id = "${aws_subnet.sn_proxy_setup.id}"

  vpc_security_group_ids = [
    "${aws_security_group.sg_public_proxy.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = 10
    delete_on_termination = true
  }

  tags = {
    Name = "artifactory_proxy_${var.install_version}"
  }
}

output "artifactory_proxy_ip" {
  value = "${aws_instance.artifactory_proxy.private_ip}"
}
