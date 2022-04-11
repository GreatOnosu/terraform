variable "AWS_ACCESS_KEY" {
}
variable "AWS_SECRET_KEY" {
}
variable "AWS_REGION" {
  default = "us-east-1"
}
variable "AMIS" {
  type = map(any)
  default = {
    us-east-1 = "ami-0c02fb55956c7d316"
    us-west-2 = "ami-03e0b06f01d45a4eb"
  }
}
variable "PATH_TO_PRIVATE_KEY" {
  default = "keys/mykey"
}
variable "PATH_TO_PUBLIC_KEY" {
  default = "keys/mykey.pub"
}
variable "INSTANCE_USERNAME" {
  default = "ec2-user"
}