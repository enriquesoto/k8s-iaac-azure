# dev purposes

FROM alpine:latest

ENV TERRAFORM_VERSION 0.12.28

WORKDIR /app

RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip

RUN unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip

COPY terraform /bin/