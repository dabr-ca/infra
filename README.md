# Terraform code for dabr.ca

This repository contains Terraform code for [dabr.ca](https://dabr.ca/), a microblogging site powered by [Pleroma](https://pleroma.social/).

## Setup

1. Have an AWS account ready.
2. Register a domain and add it to Route 53.
3. [Create a VPC](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest).
4. Use the module in this repository to create infrastructure resources.
5. Run [Ansible playbook](https://github.com/dabr-ca/config) to install and configure Pleroma on the instance.

## Components

* EC2 instance with ELB for TLS termination
* RDS instance with PostgresSQL engine
* S3 bucket with CloudFront for storing user-uploaded files
* Security groups, IAM roles, ACM certificates, Route 53 records, etc

Check [module README](./modules/pleroma/README.md) for details.
