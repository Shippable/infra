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

# this is a keyName for key pairs
variable "aws_key_name" {
  description = "Key Pair Name used to login to the box"
  default = "prod-us-east-1"
}

# this is a PEM key for key pairs
variable "aws_key_filename" {
  description = "Key Pair FileName used to login to the box"
  default = "prod-us-east-1.pem"
}

# all variables related to VPC
variable "install_version" {
  description = "version of the infra"
  default = "prodSaas"
}

# START all variables related to VPC !!! HARD CODEDED !!!
# we need to hard code it as we dont want to create it from scratch due to mongo

variable "vpc_id" {
  description = "Prod VPC ID"
  default = "vpc-2d9a894f"
}

variable "sn_public_ship_id" {
  description = "Prod Public Subnet ID"
  default = "subnet-42bfef04"
}

variable "sn_ship_install_id" {
  description = "Prod Public Subnet ID"
  default = "subnet-45bfef03"
}

variable "in_msg_id" {
  description = "Prod MSGBus Instance ID"
  default = "i-a380068e"
}

# END all variables related to VPC !!! HARD CODEDED !!!

variable "cidr_block" {
  description = "Uber IP addressing for the Network"
  default = "20.0.0.0/16"
}

variable "cidr_public_ship" {
  description = "Public 0.0 CIDR for externally accesible subnet"
  default = "20.0.0.0/24"
}

variable "cidr_private_ship_install" {
  description = "Private 0.2 block for shippable services"
  default = "20.0.10.0/24"
}

variable "cidr_private_ship_ecs" {
  description = "Private 0.200 block for old shippable ecs"
  default = "20.0.150.0/24"
}

variable "cidr_private_nat_builds" {
  description = "Private 0.250 block for nat builds"
  default = "20.0.250.0/24"
}

variable "in_type_core" {
  //make sure it is compatible with AMI, not all AMIs allow all instance types "
  default = "t2.medium"
  description = "AWS Instance type for Core server"
}

variable "in_type_ms_box" {
  //make sure it is compatible with AMI, not all AMIs allow all instance types "
  default = "c4.xlarge"
  description = "AWS Instance type for Core server"
}

variable "in_type_nat" {
  //make sure it is compatible with AMI, not all AMIs allow all instance types "
  default = "t2.medium"
  description = "AWS Instance type for NAT server"
}

variable "in_type_db" {
  //make sure it is compatible with AMI, not all AMIs allow all instance types "
  default = "m4.2xlarge"
  description = "AWS Instance type for postgres database"
}

variable "ami_us_east_1_ubuntu1404_20170310"{
  default = "ami-49c9295f"
  description = "AWS AMI for us-east-1 Ubuntu 14.04 from 2017-03-10"
}

variable "ami_us_east_1_ubuntu1604"{
  default = "ami-cd0f5cb6"
  description = "AWS AMI for us-east-1 Ubuntu 16.04"
}

# this is a special ami preconfigured to do NAT
variable "ami_us_east_1_nat"{
  default = "ami-d2ee95c5"
  description = "NAT AMI for us-east-1"
}

# this is a ACM certificate for domian *.shippable.com *.qhode.com
variable "acm_cert_arn"{
  default = "arn:aws:acm:us-east-1:983672658014:certificate/592e0545-d0a2-4da2-a1fe-c3d7c0e332c0"
  description = "acm cert arn"
}

variable "acm_cert_arn_20170309"{
  default = "arn:aws:acm:us-east-1:983672658014:certificate/c35c40e2-9093-429e-a0c6-fc79f53db136"
  description = "acm cert arn 2017-03-10"
}

variable "in_type_rp" {
  //make sure it is compatible with AMI, not all AMIs allow all instance types "
  default = "t2.small"
  description = "AWS Instance type for Reverse Proxy server"
}
