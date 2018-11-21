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

variable "avl_zone" {
  description = "availability zone used for the beta"
  default = "us-east-1b"
}

# all variables related to VPC
variable "install_version" {
  description = "version of the infra"
  default = "prodCi"
}

# START all variables related to VPC
variable "vpc_id" {
  description = "Prod VPC ID"
  default = "vpc-a25c7fc6"
}

variable "public_subnet_id" {
  description = "Prod CI Public Subnet ID"
  default = "subnet-f2abd597"
}

# END all variables related to VPC

variable "cidr_private_nat_builds" {
  description = "Private block for nat builds"
  default = "172.31.96.0/20"
}
