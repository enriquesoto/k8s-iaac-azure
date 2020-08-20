resource "kubernetes_secret" "docker_credentials_backend" {
  metadata {
    name      = "docker-credentials-backend"
    namespace = data.kubernetes_namespace.backend.metadata.0.name
  }

  data = {
    ".dockerconfigjson" = file("${path.module}/../../../config/docker-aws.json")
  }
  type = "kubernetes.io/dockerconfigjson"
}


resource "kubernetes_secret" "tls_credentials_backend" {
  type = "kubernetes.io/tls"


  metadata {
    name      = "tls-credentials-backend"
    namespace = data.kubernetes_namespace.backend.metadata.0.name
  }

  data = {
    "tls.crt" = file("${path.module}/../../../config/cred.crt")
    "tls.key" = file("${path.module}/../../../config/cred.key")
  }
}

resource "kubernetes_secret" "google_service_account" {
  metadata {
    name      = "google-service-account"
    namespace = data.kubernetes_namespace.backend.metadata.0.name
  }
  data = {
    "google_service_account" = file("${path.module}/../../../config/google-service-account.json")
  }
}

resource "kubernetes_secret" "prod_env_variables" {
  metadata {
    name      = "prod-env-variables"
    namespace = data.kubernetes_namespace.backend.metadata.0.name
  }
  data = {
    ALLOWED_HOSTS                  = var.allowed_hosts
    AWS_STORAGE_BUCKET_NAME        = local.prod_bucket_name
    CORS_ORIGIN_WHITELIST_STRINGS  = var.cors_origin_whitelist_strings
    DATABASE_URL                   = local.conection_string
    DJANGO_MEDIA_HOST              = "https://${local.prod_bucket_name}"
    DJANGO_STATIC_HOST             = "https://${local.prod_bucket_name}"
    DJANGO_SETTINGS_MODULE         = "settings.heroku"
    GOOGLE_APPLICATION_CREDENTIALS = "/etc/gcp/google-service-account.json"
    SITE_ID                        = 1
    # GS_BUCKET_NAME                 = local.prod_bucket_name
    FACEBOOK_APP_ID                = "844162512769377"
    "AWS_ACCESS_KEY_ID"            = var.aws_access_key_id_backend_user
    "AWS_SECRET_ACCESS_KEY"        = var.aws_secret_key_backend_user
    "GOOGLE_API_KEY"               = var.google_api_key_backend_account
    "GOOGLE_CLOUD_VISION"          = var.google_api_cloud_vision_backend_account
    "SENDGRID_API_KEY"             = var.sendgrid_api_key
    "SENTRY_DSN"                   = var.sentry_dsn
    "FACEBOOK_APP_SECRET"          = var.facebook_app_secret
  }
}

