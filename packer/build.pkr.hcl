packer {
  required_plugins {
    ansible = {
      source          = "github.com/hashicorp/ansible"
      version         = "~> 1"
    }
    amazon = {
      source          = "github.com/hashicorp/amazon"
      version         = "~> 1"
    }
  }
}

variable "ami_name" {
  type                = string
  default             = ""
}

variable "aws_profile" {
    type    = string
      default = ""
}

variable "aws_region" {
    type    = string
      default = ""
}

variable "source_ami_id" {
  type                = string
  default             = ""
}

variable "tag_name" {
  type                = string
  default             = ""
}

source "amazon-ebs" "centos" {
  ami_name            = "${var.ami_name}"
  instance_type       = "t2.medium"
  launch_block_device_mappings {
    device_name       = "/dev/sda1"
    volume_size       = "20"
    volume_type       = "gp2"
    delete_on_termination = true
  }
  source_ami          = "${var.source_ami_id}"
  ssh_username        = "centos"
  tags = {
    Name              = "${var.tag_name}"
  }
}

build {
  name = "redmica_ansible-test-image_builder"
  sources = [
    "source.amazon-ebs.centos"
  ]

  provisioner "ansible" {
     galaxy_file      = "./ansible/roles/requirements.yml"
     playbook_file    = "./ansible/install.yml"
  }
}
