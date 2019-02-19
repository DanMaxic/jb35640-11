# task1

## JB36540-11 HW: 06 Feb 2019

### TAGS:

\#terraform

## Lesson task 1: basics

* create the files described below
* please note, you will need the private key to access it. 
* run terraform, and answer the following questions: 1. shat changes to the code you needed to perform? 2. how built the state file? 3. run terraform graph, observe it, how it built? why?

  ```text
     terraform init
     terraform plan -var-file='terraform.tfvars' 
     terraform apply -var-file='terraform.tfvars'
  ```

terraform.tfvars

```text
aws_access_key = "<insert access key here>"
aws_secret_key = "<insert secret key here>"
private_key_path = "<path to private key>"
```

terraform file: main.tf

```text
variable "aws_access_key" {} 
variable "aws_secret_key" {} 
variable "private_key_path" {} 
variable "key_name" { 
  default = "defaultKeys" 
} 

provider "aws" { 
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "us-east-1" 
}
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
resource "aws_instance" "nginx" { 
  ami = "ami-c58c1dd3"
  instance_type = "t2.micro"
  key_name = "${var.key_name}" 
  connection { 
  user = "ec2-user"
  private_key = "${file(var.private_key_path)}" }
  provisioner "remote-exec" { 
    inline = ["sudo yum install nginx -y", "sudo service nginx start" ]
  }
}  
output "aws_instance_public_dns" { 
  value = "${aws_instance.nginx.public_dns}"
}
```

