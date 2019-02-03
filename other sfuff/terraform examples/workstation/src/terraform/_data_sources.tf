data "aws_vpc" "vpc" {
  id = "${var.vpv_hosting_details["vpc-id"]}"
}
data "aws_iam_account_alias" "current" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}



