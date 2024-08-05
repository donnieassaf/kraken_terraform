remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    bucket         = "kraken-exercise-terraform-state-bucket"
    dynamodb_table = "kraken-exercise-terraform-locks"
    key            = "production/${local.region.aws_region}/${path_relative_to_include()}/terraform.tfstate"
    region         = "ap-southeast-2"
    encrypt        = true
  }
}

locals {
  common = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
  region = yamldecode(file("region_vars.yaml"))
}

# Generate versions.tf file
generate "versions" {
  path      = "versions.tf"
  if_exists = "overwrite"
  contents  = <<EOF
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "${local.common.aws_provider_version}"
    }

    null = {
      source  = "hashicorp/null"
      version = "${local.common.null_provider_version}"
    }

    random = {
      source = "hashicorp/random"
    }
  }
}

provider "aws" {
  region  = "${local.region.aws_region}"
}
EOF
}
