provider "aws" {
  region                  = var.REGION
  shared_credentials_file = var.CREDENTIALS
  profile                 = var.PROFILE
}