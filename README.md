# Terraform code for dabr.ca

This repository contains Terraform code for [dabr.ca](https://dabr.ca/), a microblogging site powered by [Pleroma](https://pleroma.social/).

In the event that the administrator of dabr.ca is unable to fulfil their responsibilities, anyone interested can use this repo to set up as a successor. If you want to run your own instance, you may need to do a find-and-replace for hard-coded values such as domain names.

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

## Cost

Most of the AWS resources are eligible for 12-month Free Tier, [after which cost is approximately 500 USD/y](https://calculator.aws/#/estimate?id=45a11934bdf6900573ad46263707edfc2ad4d44c).
