resource "kubernetes_cron_job" "refresh_token_aws_ecr_backend" {
  metadata {
    name = "refresh-token-aws-ecr-backend"
    namespace = kubernetes_namespace.backend.metadata.0.name
  }
  spec {
    concurrency_policy            = "Replace"
    failed_jobs_history_limit     = 5
    schedule                      = "* */12 * * *"
    successful_jobs_history_limit = 2
    job_template {
      metadata {}
      spec {
        backoff_limit = 2
        ttl_seconds_after_finished    = 10
        template {
          metadata {
            labels = {
                app = "cronjobs"
            }
        }
          spec {
            container {
                env_from {
                    secret_ref {
                        name = kubernetes_secret.cicd_aws_credentials_backend.metadata.0.name
                    }
                }
              name    = "refresh-token-aws-ecr"
              image   = "circleci/buildpack-deps:stretch"
              
              command = ["/bin/sh", "-c"]
              args = [
                <<EOF
                  cd tmp/ \
                  && echo "$KUBERNETES_KUBECONFIG" | base64 --decode > kubeconfig.yml \
                  && curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip \
                  && unzip awscliv2.zip && sudo ./aws/install \
                  && curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
                  && chmod u+x ./kubectl \
                  && aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $AWS_CR_URI \
                  && ./kubectl --kubeconfig=kubeconfig.yml delete secret $DOCKER_CRED_NAME -n $NAMESPACE || true \
                  && ./kubectl --kubeconfig=kubeconfig.yml create secret generic $DOCKER_CRED_NAME -n $NAMESPACE \
                  --from-file=.dockerconfigjson=/home/circleci/.docker/config.json --type=kubernetes.io/dockerconfigjson
                EOF
                ]
            }
            restart_policy = "OnFailure"
          }
        }
      }
    }
  }
}


resource "kubernetes_cron_job" "refresh_token_aws_ecr_frontend" {
  metadata {
    name = "refresh-token-aws-ecr-frontend"
    namespace = kubernetes_namespace.frontend.metadata.0.name
  }
  spec {
    concurrency_policy            = "Replace"
    failed_jobs_history_limit     = 5
    schedule                      = "* */12 * * *"
    successful_jobs_history_limit = 2
    job_template {
      metadata {}
      spec {
        backoff_limit = 2
        ttl_seconds_after_finished    = 10
        template {
          metadata {
            labels = {
                app = "cronjobs"
            }
        }
          spec {
            container {
                env_from {
                    secret_ref {
                        name = kubernetes_secret.cicd_aws_credentials_frontend.metadata.0.name
                    }
                }
              name    = "refresh-token-aws-ecr"
              image   = "circleci/buildpack-deps:stretch"
              
              command = ["/bin/sh", "-c"]
              args = [
                <<EOF
                  cd tmp/ \
                  && echo "$KUBERNETES_KUBECONFIG" | base64 --decode > kubeconfig.yml \
                  && curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip \
                  && unzip awscliv2.zip && sudo ./aws/install \
                  && curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
                  && chmod u+x ./kubectl \
                  && aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $AWS_CR_URI \
                  && ./kubectl --kubeconfig=kubeconfig.yml delete secret $DOCKER_CRED_NAME -n $NAMESPACE || true \
                  && ./kubectl --kubeconfig=kubeconfig.yml create secret generic $DOCKER_CRED_NAME -n $NAMESPACE \
                  --from-file=.dockerconfigjson=/home/circleci/.docker/config.json --type=kubernetes.io/dockerconfigjson
                EOF
                ]
            }
            restart_policy = "OnFailure"
          }
        }
      }
    }
  }
}


resource "kubernetes_cron_job" "refresh_token_aws_ecr_frontend_feed" {
  metadata {
    name = "refresh-token-aws-ecr-frontend-feed"
    namespace = kubernetes_namespace.frontend_feed.metadata.0.name
  }
  spec {
    concurrency_policy            = "Replace"
    failed_jobs_history_limit     = 5
    schedule                      = "* */12 * * *"
    successful_jobs_history_limit = 2
    job_template {
      metadata {}
      spec {
        backoff_limit = 2
        ttl_seconds_after_finished    = 10
        template {
          metadata {
            labels = {
                app = "cronjobs"
            }
        }
          spec {
            container {
                env_from {
                    secret_ref {
                        name = kubernetes_secret.cicd_aws_credentials_frontend_feed.metadata.0.name
                    }
                }
              name    = "refresh-token-aws-ecr"
              image   = "circleci/buildpack-deps:stretch"
              
              command = ["/bin/sh", "-c"]
              args = [
                <<EOF
                  cd tmp/ \
                  && echo "$KUBERNETES_KUBECONFIG" | base64 --decode > kubeconfig.yml \
                  && curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip \
                  && unzip awscliv2.zip && sudo ./aws/install \
                  && curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
                  && chmod u+x ./kubectl \
                  && aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $AWS_CR_URI \
                  && ./kubectl --kubeconfig=kubeconfig.yml delete secret $DOCKER_CRED_NAME -n $NAMESPACE || true \
                  && ./kubectl --kubeconfig=kubeconfig.yml create secret generic $DOCKER_CRED_NAME -n $NAMESPACE \
                  --from-file=.dockerconfigjson=/home/circleci/.docker/config.json --type=kubernetes.io/dockerconfigjson
                EOF
                ]
            }
            restart_policy = "OnFailure"
          }
        }
      }
    }
  }
}