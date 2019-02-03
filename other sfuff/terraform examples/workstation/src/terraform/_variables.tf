## module config
variable "deployment_config" {
  description = "deployment configs for tf module"
  type = "map"
  default = {
    application-name = "devops-workstation",
    aws_account_region="",
    aws_access_key="",
    aws_secret_key=""
  }
}


variable "base_app_tags" {
  description = "A map of tags to add to all resources"
  type = "map"
  default = {
    application-name = "devops-workstation",
    organization = "traiana",
    owner = "danielm",
    owner-email = "dan@danmaxic.com",
    deployment-method = "trf",
  }
}

variable "vpv_hosting_details" {
  description = "vpc config "
  type = "map"
  default = {
    vpc-id = "",
  }
}

variable "cluster_nodes_conf" {
  description = "configs for the cluster nodes"
  type = "map"
  default = {
    service_cluster_min_size =1,
    service_cluster_max_size =1,
    service_cluster_desired_capacity=1,
    volume_type="gp2",
    volume_size=20,
    ecs_cluster_instance_aws_ami_id="",
    ecs_cluster_instance_instance_type="m5.2xlarge",
    ecs_cluster_instance_allow_ssh="",
    associate_public_ip_address=false,
    operational_hours_tag="247"
  }
}

variable "asg_enabeled_metrics" {type="list",default= ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]}
variable "cluster_nodes_userdata_conf" {
  description = "configs for user data"
  type = "map"
  default = {
    defualt_time_zone="UTC",
    userdata_version="1.0.0.0",
  }
}
