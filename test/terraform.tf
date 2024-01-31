provider "aws" {
#   version                 = "~> 3.29"
  region  = local.workspace["region"]
  profile = local.workspace["aws_profile"]
  skip_metadata_api_check = true
}

# terraform {
#   backend "s3" {
#     bucket                  = "client-terraform-backend"
#     key                     = "workspace_bundle_updates"
#     region                  = "ap-southeast-2"
#     profile                 = "aws-profile"
#     skip_metadata_api_check = true
#   }
# }

