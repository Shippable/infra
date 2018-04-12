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

#######################################
# one-time migration DB settings
# To be deleted after migration is done
#######################################
## resource "aws_db_parameter_group" "ship-db-prod-pg" {
##   name  = "ship-db-prod-pg"
##   family = "postgres9.5"
##
##   parameter {
##     name = "autovacuum"
##     value = false
##   }
##
##   # 4 GB. The value should be in KB here
##   # pgtune generates the same value based on hardware
##   parameter {
##     name = "maintenance_work_mem"
##     value = "4194304"
##   }
##
##   ## parameter {
##   ##   name = "wal_buffers"
##   ##   value = "8192"
##   ## }
##
##   parameter {
##     name = "synchronous_commit"
##     value = "off"
##   }
##
##   parameter {
##     name = "checkpoint_timeout"
##     value = "1800"
##   }
## }
##
## resource "aws_db_instance" "ship_db_prod" {
##   name                 = "ship_db_prod_${var.install_version}"
##   allocated_storage    = "${var.prod_db_storage}"
##   storage_type         = "gp2"
##   engine               = "postgres"
##   engine_version       = "9.5"
##   port                 = "5432"
##   instance_class       = "${var.in_type_db}"
##   username             = "${var.db_root_username}"
##   password             = "${var.db_root_password}"
##   vpc_security_group_ids = ["${aws_security_group.sg_private_ship_install.id}"]
##   db_subnet_group_name = "${aws_db_subnet_group.sng_ship_db.id}"
##   backup_retention_period = 0
##   multi_az             = false
##   maintenance_window   = "Sat:04:00-Sat:06:00"
##   parameter_group_name = "ship-db-prod-pg"
##
##   #uncomment when upgrading
##   #apply_immediately    = false
##
##   tags {
##     Name = "ship_db_${var.install_version}"
##   }
## }

#######################################
# Database configuration and instance settings
#######################################

resource "aws_db_parameter_group" "ship-db-pg" {
  name  = "ship-db-pg"
  family = "postgres9.5"

  parameter {
    name = "autovacuum"
    value = true
  }

  # 64 MB. the value should be in KB
  # pgtune generates the same value based on hardware
  parameter {
    name = "maintenance_work_mem"
    value = "65536"
  }

  parameter {
    name = "synchronous_commit"
    value = "on"
  }

  parameter {
    name = "checkpoint_timeout"
    value = "30"
  }
}

resource "aws_db_instance" "ship_db" {
  name                 = "ship_db_${var.install_version}"
  allocated_storage    = "${var.db_storage}"
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "9.5"
  port                 = "5432"
  instance_class       = "${var.in_type_db}"
  username             = "${var.db_root_username}"
  password             = "${var.db_root_password}"
  vpc_security_group_ids = ["${aws_security_group.sg_private_ship_install.id}"]
  db_subnet_group_name = "${aws_db_subnet_group.sng_ship_db.id}"
  backup_retention_period = 3
  multi_az             = true
  maintenance_window   = "Sat:04:00-Sat:06:00"
  parameter_group_name = "ship-db-pg"
  final_snapshot_identifier = "ship-db-snapshot"

  tags {
    Name = "ship_db_${var.install_version}"
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

output "cs_1_ip" {
  value = "${aws_instance.cs_1.private_ip}"
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

output "cs_2_ip" {
  value = "${aws_instance.cs_2.private_ip}"
}

# ---------------
# BLUE INSTANCES
# ---------------

# instance MS-B-1
resource "aws_instance" "ms_b_1" {
  ami = "${var.ami_us_east_1_ubuntu1604}"
  availability_zone = "${var.avl-zone}"
  instance_type = "${var.in_type_core}"
  key_name = "${var.aws_key_name}"
  subnet_id = "${aws_subnet.sn_ship_install.id}"

  vpc_security_group_ids = [
    "${aws_security_group.sg_private_ship_install.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = 100
    delete_on_termination = true
  }

  tags = {
    Name = "ms_b_1_${var.install_version}"
  }
}

output "ms_b_1_ip" {
  value = "${aws_instance.ms_b_1.private_ip}"
}

# instance MS-B-2
resource "aws_instance" "ms_b_2" {
  ami = "${var.ami_us_east_1_ubuntu1604}"
  availability_zone = "${var.avl-zone}"
  instance_type = "${var.in_type_core}"
  key_name = "${var.aws_key_name}"
  subnet_id = "${aws_subnet.sn_ship_install.id}"

  vpc_security_group_ids = [
    "${aws_security_group.sg_private_ship_install.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = 100
    delete_on_termination = true
  }

  tags = {
    Name = "ms_b_2_${var.install_version}"
  }
}

output "ms_b_2_ip" {
  value = "${aws_instance.ms_b_2.private_ip}"
}

# ---------------
# GREEN INSTANCES
# ---------------

# instance MS-G-1
resource "aws_instance" "ms_g_1" {
 ami = "${var.ami_us_east_1_ubuntu1604}"
 availability_zone = "${var.avl-zone}"
 instance_type = "${var.in_type_ms_x}"
 key_name = "${var.aws_key_name}"
 subnet_id = "${aws_subnet.sn_ship_install.id}"

 vpc_security_group_ids = [
   "${aws_security_group.sg_private_ship_install.id}"]

 root_block_device {
   volume_type = "gp2"
   volume_size = 100
   delete_on_termination = true
 }

 tags = {
   Name = "ms_g_1_${var.install_version}"
 }
}

output "ms_g_1_ip" {
 value = "${aws_instance.ms_g_1.private_ip}"
}
#
## instance MS-G-2
#resource "aws_instance" "ms_g_2" {
#  ami = "${var.ami_us_east_1_ubuntu1604}"
#  availability_zone = "${var.avl-zone}"
#  instance_type = "${var.in_type_ms}"
#  key_name = "${var.aws_key_name}"
#  subnet_id = "${aws_subnet.sn_ship_install.id}"
#
#  vpc_security_group_ids = [
#    "${aws_security_group.sg_private_ship_install.id}"]
#
#  root_block_device {
#    volume_type = "gp2"
#    volume_size = 100
#    delete_on_termination = true
#  }
#
#  tags = {
#    Name = "ms_g_2_${var.install_version}"
#  }
#}
#
#output "ms_g_2_ip" {
#  value = "${aws_instance.ms_g_2.private_ip}"
#}

# ---------------
# temporary ebs volume for migrating RC db
# ---------------

resource "aws_ebs_volume" "db_migration_volume" {
  size = 30
  type = "gp2"
  availability_zone = "${var.avl-zone}"

  tags = {
    Name = "db_migration_volume_${var.install_version}"
  }
}

resource "aws_volume_attachment" "db_migration_att" {
  device_name = "/dev/sdh"
  volume_id = "${aws_ebs_volume.db_migration_volume.id}"
  instance_id = "${aws_instance.cs_2.id}"
}
