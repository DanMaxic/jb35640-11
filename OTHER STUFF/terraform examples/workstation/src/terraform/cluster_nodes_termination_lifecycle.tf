resource "aws_autoscaling_lifecycle_hook" "cluster_instances_termination_lifecycle_hook" {
  name                    = "${aws_autoscaling_group.cluster_instances_asg.name}_termination_lifecycle_hook"
  autoscaling_group_name  = "${aws_autoscaling_group.cluster_instances_asg.name}"
  default_result          = "CONTINUE"
  heartbeat_timeout       = 1
  lifecycle_transition    = "autoscaling:EC2_INSTANCE_TERMINATING"
}