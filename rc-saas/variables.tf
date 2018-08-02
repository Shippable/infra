# main creds for AWS connection
variable "accessKey" {
  description = "AWS access key"
}

variable "secretKey" {
  description = "AWS secert access key"
}

variable "region" {
  description = "AWS region"
  default = "us-east-1"
}

variable "avl-zone" {
  description = "availability zone used for the beta"
  default = "us-east-1b"
}

variable "avl-zone-backup" {
  description = "availability zone used for the beta backup"
  default = "us-east-1c"
}

# this is a keyName for key pairs
variable "aws_key_name" {
  description = "Key Pair Name used to login to the box"
  default = "rc-us-east-1"
}

# this is a PEM key for key pairs
variable "aws_key_filename" {
  description = "Key Pair FileName used to login to the box"
  default = "rc-us-east-1.pem"
}

# all variables related to VPC
variable "install_version" {
  description = "version of the infra"
  default = "rcSaas"
}

variable "cidr_block" {
  description = "Uber IP addressing for the Network"
  default = "80.0.0.0/16"
}

variable "cidr_public_ship" {
  description = "Public 0.0 CIDR for externally accesible subnet"
  default = "80.0.0.0/24"
}

variable "cidr_public_admiral_setup" {
  description = "Public .50.0 block for admiral machines"
  default = "80.0.50.0/24"
}

variable "cidr_private_ship_install" {
  description = "Private 0.2 block for shippable services"
  default = "80.0.100.0/24"
}

variable "cidr_private_ship_backup" {
  description = "Private block for creating database backup"
  default = "80.0.150.0/24"
}

variable "cidr_private_ship_builds" {
  description = "Private 200 block for builds"
  default = "80.0.200.0/24"
}

variable "in_type_core" {
  //make sure it is compatible with AMI, not all AMIs allow all instance types "
  default = "t2.medium"
  description = "AWS Instance type for consul server"
}

variable "in_type_small" {
  //make sure it is compatible with AMI, not all AMIs allow all instance types "
  default = "t2.small"
  description = "AWS Instance type for consul server"
}

variable "in_type_scm" {
  default = "t2.large"
  description = "AWS Instance type for SCM machines"
}

variable "in_type_ms" {
  default = "c4.large"
  description = "AWS Instance type for MS machines"
}

variable "in_type_ms_x" {
  default = "c4.xlarge"
  description = "AWS Instance type for onebox RC machine"
}

variable "in_type_ms_4x" {
  default = "c4.4xlarge"
  description = "AWS Instance type for large onebox RC machine"
}

variable "in_type_bld" {
  //make sure it is compatible with AMI, not all AMIs allow all instance types "
  default = "c3.large"
  description = "AWS Instance type for running builds"
}

variable "in_type_nat" {
  //make sure it is compatible with AMI, not all AMIs allow all instance types "
  default = "t2.small"
  description = "AWS Instance type for consul server"
}

variable "in_type_db" {
  //make sure it is compatible with AMI, not all AMIs allow all instance types "
  //default = "db.m3.2xlarge"
  default = "db.t2.large"
  description = "AWS Instance type for database server"
}

variable "db_root_username" {
  description = "Database root username"
  default = "shiproot"
}

variable "db_root_password" {
  description = "Database root password"
  default = "testing1234"
}

variable "db_storage" {
  description = "Database storage in gb"
  default = 30
}

variable "ami_us_east_1_ubuntu1404"{
  default = "ami-2d39803a"
  description = "AWS AMI for us-east-1 Ubuntu 14.04"
}

variable "ami_us_east_1_ubuntu1604"{
  default = "ami-cd0f5cb6"
  description = "AWS AMI for us-east-1 Ubuntu 16.04"
}

variable "ami_us_east_1_centos7"{
  default = "ami-ae7bfdb8"
  description = "AWS AMI for us-east-1 CentOS 7"
}

variable "ami_us_east_1_rhel7"{
  default = "ami-26ebbc5c"
  description = "AWS AMI for us-east-1 RHEL 7"
}

variable "ami_us_east_1_rancheros"{
  default = "ami-03482379"
  description = "AWS AMI for us-east-1 Rancher OS 1.1.1"
}

# this is a special ami preconfigured to do NAT
variable "ami_us_east_1_nat"{
  default = "ami-d2ee95c5"
  description = "NAT AMI for us-east-1"
}

# this is a ACM certificate for domian *.shippable.com *.qhode.com
variable "acm_cert_arn"{
  default = "arn:aws:acm:us-east-1:754160106182:certificate/463d13d5-8c80-4110-8bb1-092a8694658f"
  description = "acm cert arn"
}
