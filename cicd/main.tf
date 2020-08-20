terraform {
  required_version = "~> 0.12"
  backend "s3" {
    bucket  = "memefier-remote-state-s3-azure"
    key     = "global/cicd/terraform.tfstate"
    encrypt = true
  }
}
