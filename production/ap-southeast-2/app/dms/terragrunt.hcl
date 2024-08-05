terraform {
  source = "${local.common.module_repo}//dms"
}

dependency "rds" {
  config_path = "../aws_rds_cluster"
}

inputs = {
  environment          = local.region.environment
  db_endpoint          = dependency.rds.outputs.db_endpoint
  db_username          = dependency.rds.outputs.db_username
  db_password          = dependency.rds.outputs.db_password
  db_name              = dependency.rds.outputs.db_name
  db_security_group_id = [dependency.rds.outputs.security_group_id]
}

locals {
  common = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
  region = yamldecode(file(find_in_parent_folders("region_vars.yaml")))
}

include "root" {
  path = find_in_parent_folders()
}


