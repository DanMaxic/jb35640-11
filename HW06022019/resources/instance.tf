
variable "instance_config" {
  type = "map"
  defualt ={
    source_image_name="amazon/amzn2-ami-hvm-2.0.20190115-x86_64-gp2"
    instance_type="t2.micro",
    associate_public_ip_address ="true",
    
    enable_monitoring="true",
    disable_api_termination ="false"
    root_volume_size="30"
    subnet_placement=""
    vpc_id=""
    ssh_username="meme"
    ssh_password="Letitbe123!"
  }
}


data "aws_caller_identity" "default" {}
data "aws_region" "default" {}
data "aws_subnet" "subnet" { id = "${var.instance_config["subnet_placement"]}" }
data "aws_vpc" "vpc" { id = "${var.instance_config["vpc_id"]}" }
data "aws_iam_policy_document" "default_iam_policy" {
  statement {
    sid = ""
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    effect = "Allow"
  }
}

data "aws_ami" "amazon_linux2" {
  most_recent = "true"
  filter {
    name   = "name"
    values = ["${var.instance_config["source_image_name"]}"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["137112412989"]
}

resource "aws_iam_instance_profile" "iam_instance_profile" {
  name  = "my_iam_instance_profile"
  role  = "${aws_iam_role.iam_role.name}"
}

resource "aws_iam_role" "iam_role" {
  name               = "my_iam_instance_role1"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.default_iam_policy.json}"
}

data "template_file" "service_instances_launch_configuration_user_data_template" {
  template = "${file("${path.module}/user_data.sh")}"
  vars {
    TERRAFORM_SSH_USERNAME="${var.instance_config["ssh_username"]}",
    TERRAFORM_SSH_PSSWORD ="${var.instance_config["ssh_password"]}"
  }
}

resource "aws_instance" "my_aws_instance" {
  ami                         = "${data.aws_ami.amazon_linux2.id}"
  instance_type               = "${var.instance_config["instance_type"]}"
  ebs_optimized               = "false"
  disable_api_termination     = "${var.instance_config["disable_api_termination"]}"
  user_data                   = "${data.template_file.service_instances_launch_configuration_user_data_template.rendered}"
  iam_instance_profile        = "${aws_iam_instance_profile.iam_instance_profile.name}"
  associate_public_ip_address = "${var.instance_config["associate_public_ip_address"]}"
  key_name                    = "${var.instance_config["keypair_name"]}"
  subnet_id                   = "${data.aws_subnet.subnet.id}"
  monitoring                  = "${var.instance_config["enable_monitoring"]}"
  security_groups = []

  root_block_device {
    volume_type           = "$gp2"
    volume_size           = "${var.instance_config["enable_monitoring"]}"
    delete_on_termination = "true"
  }

}
resource "aws_security_group" "service_instances_security_group" {
  name        = "my instance_sg"
  vpc_id      = "${data.aws_vpc.vpc.id}"

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow access everywhere"
  }
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow access everywhere"
  }

}
