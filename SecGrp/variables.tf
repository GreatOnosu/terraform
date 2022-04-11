variable "AWS_REGION" {
  type = string
  default = "us-east-1"
}
variable "AMIS" {
  type = map
  default = {
    us-east-1 = "ami-0b0ea68c435eb488d"
    us-west-2 = "ami-0688ba7eeeeefe3cd"
  }
}