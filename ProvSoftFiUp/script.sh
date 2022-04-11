#!/bin/bash

# sleep until instance is ready
until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  sleep 1
done

# install nginx
sudo yum update
sudo amazon-linux-extras install nginx1

# make sure nginx is started
service nginx start