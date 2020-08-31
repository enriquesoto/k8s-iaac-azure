terraform {
  backend "s3" {
    bucket  = "memefier-remote-state-s3-azure"
    key     = "prod/data-stores/terraform.tfstate"
    encrypt = true
  }
}

resource "aws_s3_bucket" "prod_bucket" {
  bucket = local.prod_bucket_name
  # Enable versioning so we can see the full revision history of our
  # state files
  acl = "public-read"
  cors_rule {
    allowed_headers = ["Authorization"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = [
      "https://${var.domain}",
      "https://${var.backend_service.subdomain}.${var.domain}",
    "https://${var.frontend_feed_service.subdomain}.${var.domain}"]
    max_age_seconds = 86400 # a day
  }
  tags = {
    environment = var.environment
  }
}

resource "aws_s3_bucket_policy" "policy" {
  bucket = aws_s3_bucket.prod_bucket.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "publicpolicybucket",
  "Statement": [
    {
      "Sid": "PublicRead",
      "Effect": "Allow",
      "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource": "arn:aws:s3:::${local.prod_bucket_name}/*"
    },
    {
      "Sid": "PrivateWriting",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${var.arn_user_backend}"
      },
      "Action": "s3:*",
      "Resource": [
          "arn:aws:s3:::${local.prod_bucket_name}",
          "arn:aws:s3:::${local.prod_bucket_name}/*"
      ]
    }
  ]
}
POLICY
}

resource "azurerm_postgresql_server" "pgsql_server_main" {
  name                = "pgsql-server-main"
  location            = data.azurerm_resource_group.main_resource_group.location
  resource_group_name = data.azurerm_resource_group.main_resource_group.name

  sku_name = "B_Gen5_1"

  storage_mb                   = 10240
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = true

  administrator_login          = var.postgresql_admin_username
  administrator_login_password = var.postgresql_admin_password
  version                      = var.pg_version
  ssl_enforcement_enabled      = true
}

resource "azurerm_postgresql_database" "main_database" {
  name                = var.database_name
  resource_group_name = data.azurerm_resource_group.main_resource_group.name
  server_name         = azurerm_postgresql_server.pgsql_server_main.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}

output "azure_psql" {
  value = azurerm_postgresql_server.pgsql_server_main
}

output "azure_psql_database" {
  value = azurerm_postgresql_database.main_database
}
