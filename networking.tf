resource "cloudflare_zone" "domain" {
  zone = var.domain
}

resource "cloudflare_record" "images" {
  zone_id = cloudflare_zone.domain.id
  name    = var.prod_bucket_subdomain
  value   = local.bucket_prod_cname_value
  proxied = true
  type    = "CNAME"
  ttl     = 1
}

resource "cloudflare_record" "api" {
  zone_id = cloudflare_zone.domain.id
  name    = "api"
  value   = data.kubernetes_service.nginx_ingress.load_balancer_ingress.0.ip
  # value = "164.90.252.31"
  proxied = true
  type    = "A"
  ttl     = 1
}

resource "cloudflare_record" "feed" {
  zone_id = cloudflare_zone.domain.id
  name    = var.frontend_feed_service.subdomain
  value   = data.kubernetes_service.nginx_ingress.load_balancer_ingress.0.ip
  proxied = true
  type    = "A"
  ttl     = 1
}

resource "cloudflare_record" "www" {
  zone_id = cloudflare_zone.domain.id
  name    = "www"
  value   = data.kubernetes_service.nginx_ingress.load_balancer_ingress.0.ip
  # value = "164.90.252.31"
  proxied = true
  type    = "A"
  ttl     = 1
}

resource "cloudflare_record" "naked" {
  zone_id = cloudflare_zone.domain.id
  name    = "@"
  value   = data.kubernetes_service.nginx_ingress.load_balancer_ingress.0.ip
  # value = "164.90.252.31"
  proxied = true
  type    = "A"
  ttl     = 1
}

# AZURE

resource "azurerm_dns_zone" "maindomain" {
  name                = var.domain
  resource_group_name = azurerm_resource_group.main_resource_group.name
}

resource "azurerm_dns_a_record" "feed" {
  name                = var.frontend_feed_service.subdomain
  zone_name           = azurerm_dns_zone.maindomain.name
  resource_group_name = azurerm_resource_group.main_resource_group.name
  ttl                 = 300
  records             = [data.kubernetes_service.nginx_ingress.load_balancer_ingress.0.ip]
}

resource "azurerm_dns_a_record" "naked" {
  name                = "@"
  zone_name           = azurerm_dns_zone.maindomain.name
  resource_group_name = azurerm_resource_group.main_resource_group.name
  ttl                 = 300
  records             = [data.kubernetes_service.nginx_ingress.load_balancer_ingress.0.ip]
}

resource "azurerm_dns_a_record" "www" {
  name                = "www"
  zone_name           = azurerm_dns_zone.maindomain.name
  resource_group_name = azurerm_resource_group.main_resource_group.name
  ttl                 = 300
  records             = [data.kubernetes_service.nginx_ingress.load_balancer_ingress.0.ip]
}
#backend

resource "azurerm_dns_a_record" "api" { 
  name                = var.backend_service.subdomain
  zone_name           = azurerm_dns_zone.maindomain.name
  resource_group_name = azurerm_resource_group.main_resource_group.name
  ttl                 = 300
  records             = [data.kubernetes_service.nginx_ingress.load_balancer_ingress.0.ip]
}

