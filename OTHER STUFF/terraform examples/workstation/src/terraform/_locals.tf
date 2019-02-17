locals {
  aws_account_id = "${data.aws_caller_identity.current.account_id}"
  aws_account_name = "${data.aws_iam_account_alias.current.account_alias}"
  # ec2 Tags
  environment = "${data.aws_region.current.name}"
}