locals {
  bucket_name = format("test-cloudfunction-sources-%s", module.shared.env_name)
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }

  // variables are not allowed in bucket and prefix!!  
  backend "gcs" {
    bucket = "test-terraform-backend-store-stg"
    prefix = "cloudfunction/cf_source_code_bucket"
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
  project_id  = module.shared.project
}
