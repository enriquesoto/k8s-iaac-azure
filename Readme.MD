
# Hybrid Cloud Stack using Terraform 0.12

Code for provisioning a full-production infrastructure (excluding users and its policies that should be created manually and their tokens are used as input). Services from AWS, Digital Ocean, Cloudflare and CircleCI are used: 

- AWS S3 buckets for managing the remote backend  (tfstate files) and other for production files (media and static files)
- AWS Elastic Container Registry aimed to storage docker images to allow  the CI/CD workflow 
- Cloudflare for the DNS management
- Digital Ocean for supplying the Kubernetes Cluster, the managed Database (Postgres), a Loadbalancer (Helm)  and Virtual Private Networks
- CircleCI : CI/CD  


The next version is planned to provisioning another isolated environment 'stage', for testing purposes, using  non-production infrastructure (cheap).

Remenber executing terraform apply within each component for every change. Recomended by [Yevgeniy Brikman](https://blog.gruntwork.io/how-to-manage-terraform-state-28f5697e68fa)


## Executing terraform0.12 within a docker virtual environment 

Hashicorp owns an official terraform image available and you could use like this

```terraform
TERRAFORM_IMAGE=hashicorp/terraform:0.12.3
TERRAFORM_CMD="docker run -ti --rm -w /app -v ${HOME}/.aws:/root/.aws -v ${HOME}/.ssh:/root/.ssh -v `pwd`:/app -w /app ${TERRAFORM_IMAGE}"
${TERRAFORM_CMD} init
${TERRAFORM_CMD} plan
```
