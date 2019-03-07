locals {
  cluster_nodes_log_group = {
    application-role = "log_group"
    name = "${var.deployment_config["application-name"]}"
    Name = "${var.deployment_config["application-name"]}"
    location = "${data.aws_region.current.name}"
    environment = "${data.aws_iam_account_alias.current.account_alias}"
  }
}

resource "aws_cloudwatch_log_group" "cluster_nodes_log_group" {
  name              = "${local.cluster_nodes_log_group["name"]}"
  retention_in_days = 14

  tags = "${merge(var.base_app_tags,local.cluster_nodes_log_group)}"
}
