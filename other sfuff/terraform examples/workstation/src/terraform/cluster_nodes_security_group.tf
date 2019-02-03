locals {
  cluster_instances_security_group = {
    application-role = "security-group"
    name = "${var.deployment_config["application-name"]}_nodes_sg"
    Name = "${var.deployment_config["application-name"]}_nodes_sg"
    location = "${data.aws_region.current.name}"
    environment = "${data.aws_iam_account_alias.current.account_alias}"
  }
}


resource "aws_security_group" "cluster_instances_security_group" {
  name        = "${local.cluster_instances_security_group["name"]}"
  description = "security group for the ECS instances cluster"
  vpc_id      = "${data.aws_vpc.vpc.id}"

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    self = true
  }
  ingress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["${data.aws_vpc.vpc.cidr_block}"]
  }
  tags = "${merge(var.base_app_tags,local.cluster_instances_security_group)}"
}