inputs = {
  name                              = "dcmacke.net"
  domain_name                       = "dcmacke.net"
  process_domain_validation_options = false
  subject_alternative_names         = ["*.dcmacke.net"]
}

terraform {
  source = "git@github.com:cloudposse/terraform-aws-acm-request-certificate.git?ref=0.13.1"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}
