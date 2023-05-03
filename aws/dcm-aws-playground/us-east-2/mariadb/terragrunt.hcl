inputs = {
  namespace = "dcm-playground"
  stage     = "demo"
  
  database_name = "wordpress"
  database_user = "dcm_admin"
  database_password = run_cmd("--terragrunt-quiet", "chamber", "read", "-q", "dcm-playground/rds", "--", "admin_password")
  database_port = 3306
  db_parameter_group = "mariadb10.6"
  allocated_storage = "20"
  
  engine         = "mariadb"
  instance_class  = "db.t3.small"
  engine_version = "10.6.12"
  
  storage_encrypted = true
  
  backup_window = "07:00-09:00"
  
  skip_final_snapshot = false
  deletion_protection = true
  
  allow_major_version_upgrade = false
  
  vpc_id = dependency.vpc.outputs.vpc_id
  subnet_ids = dependency.vpc.outputs.database_subnets
  security_group_ids = [dependency.security_group.outputs.id]
}

terraform {
  source = "git@github.com:cloudposse/terraform-aws-rds.git?ref=0.42.0"
}


dependency "vpc" {
  config_path = "../vpc"
}

dependency "security_group" {
  config_path = "./security-group"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}
