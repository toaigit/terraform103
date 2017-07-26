provider "aws" {
  region = "${var.region}"
}

data "aws_availability_zones" "all" {}

resource "aws_elb" "bastionELB" {
  name = "bastionELB"
  security_groups = ["${var.SG_elbhttp}"]
  subnets = ["${var.subnet1}","${var.subnet2}","${var.subnet3}"]
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:${var.http_server_port}/"
  }
  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "${var.http_server_port}"
    instance_protocol = "http"
  }
 listener {
    instance_port = "${var.http_server_port}"
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "${var.ssl_cert_arn}"
  }
}

resource "aws_lb_cookie_stickiness_policy" "SSLstickiness" {
  name                     = "SSLsticky"
  load_balancer            = "${aws_elb.bastionELB.id}"
  lb_port                  = 443
  cookie_expiration_period = 600
}

resource "aws_lb_cookie_stickiness_policy" "HTTPstickiness" {
  name                     = "HTTPsticky"
  load_balancer            = "${aws_elb.bastionELB.id}"
  lb_port                  = 80
  cookie_expiration_period = 600
}

resource "aws_autoscaling_group" "ServerGroup" {
  name                      = "${var.autoscaling_group_name}"
  max_size                  = "${var.max_size}"
  min_size                  = "${var.min_size}"
  desired_capacity          = "${var.asg_desired}"
  health_check_grace_period = "${var.health_check_grace_period}"
  vpc_zone_identifier       = ["${var.subnet1}","${var.subnet2}","${var.subnet3}"]
  launch_configuration      = "${aws_launch_configuration.LaunchConfig.name}"
  load_balancers            = ["${aws_elb.bastionELB.name}"]

  tag {
    key = "Name"
    value = "${var.host_name}"
    propagate_at_launch = true    
  }
}

resource "aws_launch_configuration" "LaunchConfig" {
  name                        = "${var.launch_config_name}"
  image_id                    = "${var.image_id}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key_name}"
  security_groups             = ["${var.FromSSHelb}"]
  iam_instance_profile        = "${var.iamrole}"
  associate_public_ip_address = true

  root_block_device {
    volume_type           = "${var.volume_type}"
    volume_size           = "${var.volume_size}"
    delete_on_termination = "${var.delete_on_termination}"
  }

user_data = <<EOF
#cloud-config
runcmd:
- /bin/timedatectl set-timezone America/Los_Angeles
- mkdir -p /efs/share ; chmod 700 /efs/share
- /bin/domainname "${var.localdomain_name}"  
- /bin/hostname "${var.host_name}"
EOF
}

output "elb_dns_name" {
  value = "${aws_elb.bastionELB.dns_name}"
}
