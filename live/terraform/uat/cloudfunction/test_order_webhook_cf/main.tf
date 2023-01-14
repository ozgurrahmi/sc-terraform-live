locals {
  name        = "test-order-webhook"
  runtime     = "go116"
  entry_point = "HelloPubSub"
  source_path = "../../cf_source_codes/order-webhook-cf-uat.zip"
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
    bucket = "test-terraform-backend-store-uat"
    prefix = "cloudfunction/test_order_webhook_cf"
  }
}

provider "google" {
  project = module.shared.project
  region  = module.shared.region
}

// passing common constants (project,region,env_name) 
module "shared" {
  source = "../../shared"
}


data "terraform_remote_state" "test_order_webhook_topic" {
  backend = "gcs"
  config = {
    bucket = "test-terraform-backend-store-uat"
    prefix = "pubsub/test_order_webhook_topic"
  }
}

data "terraform_remote_state" "cloud_function_source_bucket" {
  backend = "gcs"
  config = {
    bucket = "test-terraform-backend-store-uat"
    prefix = "cloudfunction/cf_source_code_bucket"
  }
}

module "cloudfunction" {
  source      = "git@github.com:ozgurrahmi/sc-terraform-common-modules.git//modules/cloudfunction?ref=v3.0"
  project_id  = module.shared.project
  region_id   = module.shared.region
  env_name    = module.shared.env_name
  bucket_name = data.terraform_remote_state.cloud_function_source_bucket.outputs.bucket_name
  name        = local.name
  runtime     = local.runtime
  entry_point = local.entry_point
  source_path = local.source_path
  // module dependency 
  topic_name = data.terraform_remote_state.test_order_webhook_topic.outputs.topic_name
}
