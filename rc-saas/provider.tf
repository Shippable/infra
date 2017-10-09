# Setup our aws provider
provider "aws" {
  access_key  = "${var.accessKey}"
  secret_key  = "${var.secretKey}"
  region      = "${var.region}"
}
