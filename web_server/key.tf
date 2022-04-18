resource "aws_key_pair" "main_key" {
  key_name   = "main-key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}