provider "circleci" {
  api_token    = var.circle_ci.token
  vcs_type     = "github"
  organization = var.circle_ci.organization
}
provider "azurerm" {
  version = "=2.23.0"
  features {}
}