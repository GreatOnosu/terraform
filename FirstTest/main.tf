variable "myvar" {
  type= string
  default = "hello tf"
}

variable "mymap" {
  type= map
  default = {mykey = "my value"}
}

variable "mylist" {
  type= list
  default = ["a",2,3]
}