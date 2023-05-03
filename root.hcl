locals {
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl", "not_found"), {})
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl", "not_found"), {})
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl", "not_found"), {})
  
  account_name = try(local.account_vars.locals.aws_account_alias, null)
  account_id   = try(local.account_vars.locals.aws_account_id, "")
  aws_region   = try(local.region_vars.locals.aws_region, "")
  environment  = try(local.environment_vars.locals.environment, "")
  
}

terraform {
  extra_arguments "init_args" {
    commands = [
      "init"
    ]
    
    arguments = [
      "-upgrade"
    ]
  }
}

remote_state {
  backend = "s3"
  config = {
    bucket         = "dcm-terraform-state-files"
    region         = "us-east-2"
    external_id    = "TerraformStateManager"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    encrypt        = true
    dynamodb_table = "terraform_lock"
  }
}


generate "remote_backend" {
  path      = "versions_override.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  backend "s3" {}
  
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.0"
    }
    github = {
      source = "integrations/github"
      version = "~> 5.0"
    }
  }
}
EOF
}

generate "provider" {
  path      = "providers_override.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.aws_region}"
  allowed_account_ids = ["${local.account_id}"]
  
  default_tags {
    tags = {
      terraform = true
      tg-infra-path = "${path_relative_to_include("root")}"
    }
  }
}

provider "github" {}
EOF
}
