
resource "null_resource" "cluster_instances_asg_tagmap" {
  count = "${length(keys(var.base_app_tags))}"

  triggers = "${map(
      "key", "${element(keys(var.base_app_tags), count.index)}",
      "value", "${element(values(var.base_app_tags), count.index)}",
      "propagate_at_launch", true
    )}"
}
locals {
  asg_tags = ["${null_resource.cluster_instances_asg_tagmap.*.triggers}"]
}



resource "aws_autoscaling_group" "cluster_instances_asg" {
  name_prefix = "${var.deployment_config["application-name"]}_asg"
  max_size             = "${lookup(var.cluster_nodes_conf,"service_cluster_max_size")}"
  min_size             = "${lookup(var.cluster_nodes_conf,"service_cluster_min_size")}"
  desired_capacity     = "${lookup(var.cluster_nodes_conf,"service_cluster_desired_capacity")}"
  force_delete         = true
  termination_policies = ["OldestLaunchConfiguration"]
  launch_configuration = "${aws_launch_configuration.cluster_nodes_launch_configuration.name}"
  vpc_zone_identifier  = ["${data.terraform_remote_state.vpc_bucket_remote_state_file.private_subnets_ids}"]
  default_cooldown = 10
  enabled_metrics = "${var.asg_enabeled_metrics}"
  metrics_granularity = "1Minute"
  health_check_type    = "EC2"
  lifecycle {
    create_before_destroy = true
  }
  tags = ["${concat(
    list(
      map("key", "Name", "value", "${lookup(var.deployment_config,"application-name")}_asg", "propagate_at_launch", true),
      map("key", "name", "value", "${lookup(var.deployment_config,"application-name")}_asg", "propagate_at_launch", true),
      map("key", "launch-configuration-name", "value", "${aws_launch_configuration.cluster_nodes_launch_configuration.name}", "propagate_at_launch", true),
      map("key", "operational-hours", "value", "${lookup(var.cluster_nodes_conf,"operational_hours_tag")}", "propagate_at_launch", true)
    ),
    local.asg_tags)
  }"]
  depends_on = [
    "null_resource.cluster_instances_asg_tagmap"
  ]
}
