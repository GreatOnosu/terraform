output "instance_ips" {
  value = aws_instance.ec2_ubuntu.public_ip
}

output "securitygroup_ips" {
  value = aws_security_group.allow-ssh.vpc_id
}