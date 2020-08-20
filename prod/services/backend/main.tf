terraform {
  backend "s3" {
    bucket  = "memefier-remote-state-s3-azure"
    key     = "prod/services/backend/terraform.tfstate"
    encrypt = true
  }
}

