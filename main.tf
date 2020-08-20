terraform {
  required_version = "~> 0.12"
  backend "s3" {
    bucket  = "memefier-remote-state-s3-azure"
    key     = "global/s3/terraform.tfstate"
    encrypt = true
  }
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = var.terraform_remote_state_bucket
  # Enable versioning so we can see the full revision history of our
  # state files
  acl = "private"
  versioning {
    enabled = true
  }
  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

# Create a resource group
resource "azurerm_resource_group" "main_resource_group" {
  name     = "main_resource_group"
  location = "East US"
}