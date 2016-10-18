# main creds for AWS connection
variable "aws_access_key_id" {
  description = "AWS access key"
}

variable "aws_secret_access_key" {
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
  default = "alpha-us-east-1"
}

# this is a PEM key for key pairs
variable "aws_key_filename" {
  description = "Key Pair FileName used to login to the box"
  default = "alpha-us-east-1.pem"
}

# all variables related to VPC
variable "vpc" {
  description = "VPC for the cluster system"
  default = "vpc_alpha_server"
}

variable "cidr_block" {
  description = "Uber IP addressing for the Network"
  default = "80.0.0.0/16"
}

variable "cidr_public_ship" {
  description = "Public 0.0 CIDR for externally accesible subnet"
  default = "80.0.0.0/24"
}

variable "cidr_private_ship_install" {
  description = "Private 0.2 block for shippable services"
  default = "80.0.100.0/24"
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

variable "in_type_nat" {
  //make sure it is compatible with AMI, not all AMIs allow all instance types "
  default = "t2.small"
  description = "AWS Instance type for consul server"
}

variable "ami_us_east_1_ubuntu1404"{
  default = "ami-2d39803a"
  description = "AWS AMI for us-east-1 Ubuntu 14.04"
}

# this is a special ami preconfigured to do NAT
variable "ami_us_east_1_nat"{
  default = "ami-d2ee95c5"
  description = "NAT AMI for us-east-1"
}

# this is a ACM certificate for domian *.shippable.com *.qhode.com
variable "acm_cert_arn"{
  default = "arn:aws:acm:us-east-1:752326595591:certificate/e4dc19a2-2858-4d3c-aa4b-071ca7ee7a94"
  description = "acm cert arn"
}
