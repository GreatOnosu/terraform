output "instance_ips" {
  value = aws_instance.ec2_ubuntu.public_ip
}