provider "aws" {
  region                  = var.region
  shared_credentials_file = var.credentials
  profile                 = var.profile

  default_tags {
    tags = {
      "Environmet" = "Codex"
      "Owner"      = "Sixnines"
      "Project"    = "SSO Test"
    }
  }

}