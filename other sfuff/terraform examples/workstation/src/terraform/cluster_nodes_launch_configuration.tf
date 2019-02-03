

data "template_file" "cluster_instances_launch_configuration_user_data_template" {
  template = "${file("${path.module}/templates/user_data.sh")}"
  vars {

  }
}


resource "aws_launch_configuration" "cluster_nodes_launch_configuration" {
  name_prefix          = "${var.deployment_config["application-name"]}"
  image_id             = "${var.cluster_nodes_conf["ecs_cluster_instance_aws_ami_id"]}"
  instance_type        = "${var.cluster_nodes_conf["ecs_cluster_instance_instance_type"]}"
  security_groups      = ["${aws_security_group.cluster_instances_security_group.id}"]
  user_data            = "${data.template_file.cluster_instances_launch_configuration_user_data_template.rendered}"
  iam_instance_profile = "${aws_iam_instance_profile.cluster_instances_iam_instance_profile.name}"
  key_name             = "${aws_key_pair.luminate_public_key.key_name}"
  associate_public_ip_address = "${var.cluster_nodes_conf["associate_public_ip_address"]}"
  ebs_optimized = false

  root_block_device = {
    volume_type           = "${lookup(var.cluster_nodes_conf,"volume_type")}"
    volume_size           = "${lookup(var.cluster_nodes_conf,"volume_size")}"
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }
}