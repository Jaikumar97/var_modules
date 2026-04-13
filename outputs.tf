output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnets" {
  value = module.subnets.private_subnets
}