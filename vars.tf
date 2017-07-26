variable "region" {
  default = "us-west-2"
  }

variable "autoscaling_group_name" {
  default = "ASG_BastionELB_vpcUAT"
}

variable "launch_config_name" {
  default = "LC_BastionELB_vpcUAT"
}

variable "iamrole" {
  default = "UpdateDNS"
}

variable "subnet1" {
  default = "subnet-baade283"
}

variable "subnet2" {
  default = "subnet-c47740b3"
}

variable "subnet3" {
  default = "subnet-d78150fc"
}

variable "min_size" {
  default = "1"
}

variable "max_size" {
  default = "2"
}

variable "asg_desired" {
  default = "1"
}

variable "health_check_grace_period" {
  default = "300"
}

variable "ssl_cert_arn" {
  default = "arn:aws:acm:us-west-2:927946841317:certificate/2e52e8e2-992c-47de-bc87-1eb6805013e5"
}

variable "image_id" {
  default = "ami-49b3d129"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  default = "toai-key"
}

variable "bastionsg" {
  default = "sg-d58db8ae"
}

variable "dbsg" {
  default = "sg-0b83b670"
}

variable "websg" {
  default = "sg-768cb90d"
}

variable "elbsg" {
  default = "sg-bf86b3c4"
}

variable "SG_elbhttp" {
  default = "sg-73aaad08"
}

variable "efssg" {
  default = "sg-b886b3c3"
}

variable "volume_type" {
  default = "gp2"
}

variable "volume_size" {
  default = "16"
}

variable "host_name" {
  default = "bastionelb"
  }

variable "localdomain_name" {
  default = "stanfordaws.com"
  }

variable "http_server_port" {
  default = "80"
  }

variable "bastion_elb" {
  default = "bastion-elb"
  }

variable "FromSSHelb" {
  default = "sg-9a4b4de1"
  }

variable "delete_on_termination" {
  default = "true"
}
