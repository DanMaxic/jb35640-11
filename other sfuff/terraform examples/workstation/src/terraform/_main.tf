provider "aws" {
  version = "1.11" ,
  region = "${var.deployment_config["aws_account_region"]}",
  aws_access_key="${var.deployment_config["aws_access_key"]}",
  aws_secret_key="${var.deployment_config["aws_secret_key"]}"
}
provider "template" { version = "1.0" }
provider "null" { version = "1.0" }

terraform {
  backend "s3" {
  }
}