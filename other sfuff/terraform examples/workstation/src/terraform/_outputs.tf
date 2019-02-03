
output "depoyment_application_name" {
  value = "${var.deployment_config["application-name"]}"
}

output "deployment_account_alias" {
  value = "${data.aws_iam_account_alias.current.account_alias}"
}
output "deployment_account_id" {
  value = "${data.aws_iam_account_alias.current.id}"
}
output "deployment_region" {
  value = "${data.aws_iam_account_alias.current.id}"
}


output "source_deployment_dir" {
  value = "${dirname(path.module)}"
}

output "nodes_security_group_id" {
  value = "${aws_security_group.cluster_instances_security_group.id}"
}

output "nodes_luanch_configuration_id" {
  value = "${aws_launch_configuration.cluster_nodes_launch_configuration.id}"
}

output "s3_bucket_name" {
  value = "${aws_s3_bucket.s3_bucket.bucket}"
}


output "hosted_cidr_block" {
  value = "${data.aws_vpc.vpc.cidr_block}"
}
output "aws_ecs_cluster" {
  value = "${var.deployment_config["application-name"]}"
}