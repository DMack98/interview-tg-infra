locals {
  region_config = read_terragrunt_config(find_in_parent_folders("region.hcl")).locals
}

inputs = {
  namespace = "dcm-playground"
  region = local.region_config.aws_region
  
  vpc_id = dependency.vpc.outputs.vpc_id
  public_subnets = dependency.vpc.outputs.public_subnets
  private_subnets = dependency.vpc.outputs.private_subnets
  
  wordpress_version = "6.2.0"
  
  alb_certificate_arn = dependency.certificate.outputs.arn
  
  db_host = dependency.db.outputs.instance_endpoint
  db_port = "3306"
  db_name = "wordpress"
  db_user = "dcm_admin"
  db_password = run_cmd("--terragrunt-quiet", "chamber", "read", "-q", "dcm-playground/rds", "--", "admin_password")
  
  security_groups = [dependency.db_sg.outputs.id]
}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "certificate" {
  config_path = "../certificate"
}

dependency "db" {
  config_path = "../mariadb"
}

dependency "db_sg" {
  config_path = "../mariadb/security-group"
}

terraform {
  source = "git@github.com:DMack98/interview-tf-modules.git//demo-wordpress?ref=1.0.0"
}
