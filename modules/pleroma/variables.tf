variable "name" {
  description = "Name of the service. It will be used to name EC2, ELB, and RDS instances."
  type        = string
  default     = "pleroma"
}

variable "domain" {
  description = "Domain of the Pleroma instance. This domain points to ELB. The domain must already exist in Route 53."
  type        = string
}

variable "files_domain" {
  description = "Domain for serving user-uploaded files. This domain points to CloudFront, whose origin is an S3 bucket."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the resources are created."
  type        = string
}

variable "private_subnet_ids" {
  description = "List of IDs of subnets to create private resources (e.g. databases) in."
  type        = list(string)
  validation {
    condition     = length(var.private_subnet_ids) >= 3
    error_message = "At least 3 private subnets are required."
  }
}

variable "public_subnet_ids" {
  description = "List of IDs of subnets to create public resources (e.g. load balancers) in."
  type        = list(string)
  validation {
    condition     = length(var.public_subnet_ids) >= 3
    error_message = "At least 3 public subnets are required."
  }
}

variable "ec2_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ec2_key_name" {
  description = "Name of key pair to log into the EC2 instance. The key pair must already exist."
  type        = string
}

variable "rds_instance_class" {
  type    = string
  default = "db.t4g.micro"
}

variable "rds_storage_type" {
  type    = string
  default = "gp2" # gp3 is no eligible for free tier
}

variable "rds_allocated_storage" {
  type    = number
  default = 20
}

variable "domain_spf_record" {
  description = "Customize domain SPF record. By default only SES are allowed to send mails from the domain."
  type        = string
  default     = "v=spf1 include:amazonses.com -all"
}
