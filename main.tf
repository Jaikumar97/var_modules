# 1. VPC
module "vpc" {
  source     = "./modules/vpc"
  cidr_block = var.vpc_cidr
}

# 2. Subnets
module "subnets" {
  source       = "./modules/subnets"
  vpc_id       = module.vpc.vpc_id
  public_cidr  = var.public_subnet_cidr
  private_cidr = var.private_subnet_cidr
  azs          = var.azs
}

# 3. Internet Gateway
module "igw" {
  source = "./modules/igw"
  vpc_id = module.vpc.vpc_id
}

# 4. NAT Gateway
module "nat" {
  source           = "./modules/nat"
  public_subnet_id = module.subnets.public_subnets[0]
}

# 5. Route Tables
module "routes" {
  source          = "./modules/routes"
  vpc_id          = module.vpc.vpc_id
  igw_id          = module.igw.igw_id
  nat_id          = module.nat.nat_id
  public_subnets  = module.subnets.public_subnets
  private_subnets = module.subnets.private_subnets
}

# 6. EC2 (Private)
module "ec2" {
  source          = "./modules/ec2"
  ami             = var.ami_id
  instance_type   = var.instance_type
  private_subnets = module.subnets.private_subnets
  key_name        = var.key_name
}