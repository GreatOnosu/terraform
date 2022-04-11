resource "aws_instance" "ec2_ubuntu" {
  ami           = lookup(var.AMIS, var.AWS_REGION)
  instance_type = "t2.micro"

  subnet_id = aws_subnet.main-public-1.id

  vpc_security_group_ids = [aws_security_group.allow-ssh.id]

  key_name = aws_key_pair.mykey.key_name

  user_data = "#!/bin/bash\nwget http://swupdate.openvpn.org/as/openvpn-as-2.1.2-Ubuntu14.amd_64.deb\ndpkg -i openvpn-as-2.1.2-Ubuntu14.amd_64.deb"
}