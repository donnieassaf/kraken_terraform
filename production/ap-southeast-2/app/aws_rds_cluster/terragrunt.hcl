terraform {
  source = "${local.common.module_repo}//aws_rds_cluster"
}
inputs = {
  environment        = local.region.environment
  instance_class     = "db.r5.large"  # Specify the instance class
}

locals {
  common = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
  region = yamldecode(file(find_in_parent_folders("region_vars.yaml")))
}

include "root" {
  path = find_in_parent_folders()
}
