output "private_ips" {
  value = aws_autoscaling_group.asg.instances[*].private_ip
}

