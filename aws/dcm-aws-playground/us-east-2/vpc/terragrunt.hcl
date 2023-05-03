inputs = {
  name = "dcm-playground-vpc"
  cidr = "172.30.0.0/16"
  
  azs = [
    "us-east-2a",
    "us-east-2b",
    "us-east-2c"
  ]
  
  private_subnets = [
    "172.30.64.0/20",
    "172.30.80.0/20",
    "172.30.96.0/20"
  ]
  
  public_subnets = [
    "172.30.0.0/20",
    "172.30.16.0/20",
    "172.30.32.0/20",
  ]
  
  create_database_subnet_group = false
  
  database_subnets = [
    "172.30.224.0/20",
    "172.30.240.0/20",
  ]
  
  enable_dns_hostnames = true
  enable_nat_gateway     = true
  one_nat_gateway_per_az = true 
  map_public_ip_on_launch = false
  
  manage_default_route_table = false
}

terraform {
  source = "git@github.com:terraform-aws-modules/terraform-aws-vpc.git?ref=v2.77.0"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}
