# AWS EKS
This repo contains the terraform script on deploying kubernetes cluster on AWS eks.
prerequisite needed
- AWS account 
- AWS CLI
- terraform CLI
- kubernetes CLI

# Note
Before creating cluster you need we create private key(for ssh access) in aws console manually. And use that name in eks-node-group.tf . In this repo, I have used `my-test-ssh-key-pair` as my key pair name. 

## Deploy using Terraform
1. terraform init
2. terraform plan
3. terraform apply
