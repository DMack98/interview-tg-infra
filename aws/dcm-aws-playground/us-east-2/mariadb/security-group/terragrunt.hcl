inputs = {
  enabled               = true
  create_before_destroy = true

  namespace = "dcm-playground"
  name      = "maria-db"

  vpc_id = dependency.vpc.outputs.vpc_id

  allow_all_egress = true
  rules = [
    {
      self        = true
      description = "Allow inbound traffic within security group on database port",
      from_port   = 3306,
      protocol    = "tcp",
      to_port     = 3306,
      type        = "ingress"
    }
  ]
}

dependency "vpc" {
  config_path = "../../vpc"
}

terraform {
  source = "git@github.com:cloudposse/terraform-aws-security-group.git?ref=0.4.0"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}
