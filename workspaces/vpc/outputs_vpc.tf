output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
}

output "subnet_ids" {
  description = "Map of subnet type => [id]"
  value = {
    private = module.vpc.private_subnets
    public  = module.vpc.public_subnets
  }
}

output "sg_ids" {
  description = "Map of common security group name => id"
  value       = module.vpc.sg_ids
}
