locals {
  bucket_name = "test-terraform-backend-store-stg"
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  project = module.shared.project
  region  = module.shared.region
}

// passing common constants (project,region,env_name) 
module "shared" {
  source = "../shared"
}

module "bucket" {
  source      = "git@github.com:ozgurrahmi/sc-terraform-common-modules.git//modules/bucket"
  bucket_name = local.bucket_name
  location    = module.shared.region
}
