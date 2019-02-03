

resource "aws_iam_role" "cluster_nodes_iam_role" {
  name = "${var.deployment_config["application-name"]}_instances_iam_role"
  path = "/"
  assume_role_policy = "${file("${path.module}/templates/iam_role_ec2.json")}"
}


resource "aws_iam_instance_profile" "cluster_instances_iam_instance_profile" {
  name = "${var.deployment_config["application-name"]}_instances_iam_instance_profile"
  path = "/"
  role = "${aws_iam_role.cluster_nodes_iam_role.name}"
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerServiceforEC2Role" {
  role       = "${aws_iam_role.cluster_nodes_iam_role.id}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "CloudWatchLogsFullAccess" {
  role       = "${aws_iam_role.cluster_nodes_iam_role.id}"
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}
resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  role       = "${aws_iam_role.cluster_nodes_iam_role.id}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}




