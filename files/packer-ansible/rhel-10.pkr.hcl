packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.1"
      source  = "github.com/hashicorp/amazon"
    }
    ansible = {
      version = ">= 1.1.4"
      source = "github.com/hashicorp/ansible"
    }
  }
}

variable "version" {
  type    = string
  default = "1.0.0"
}

data "amazon-ami" "rhel-10-east" {
  region = "us-east-2"
  filters = {
    name = "amazon/RHEL-10.*_HVM-*-x86_64-0-Hourly2-GP3"
  }
  most_recent = true
  owners      = ["309956199498"]
}

source "amazon-ebs" "rhel-10-east" {
  region         = "us-east-2"
  source_ami     = data.amazon-ami.rhel-10-east.id
  instance_type  = "t2.small"
  ssh_username   = "ec2-user"
  ssh_agent_auth = false
  ami_name       = "packer_AWS_{{timestamp}}_v${var.version}"
}

build {
  name = "learn-packer-rhel"
  sources = [
    "source.amazon-ebs.rhel-10-east"
  ]

  # Install Ansible
  provisioner "shell" {
    script= "scripts/ansible.sh"
  }

  provisioner "ansible-local" {
    playbook_file = "ansible/playbook.yml"
  }

  provisioner "shell" {
    script= "scripts/cleanup.sh"
  }
  

}
