locals {
  topic_name = "test-product-webhook-topic"
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }

  // parameters are not allowed in bucket and prefix!!  
  backend "gcs" {
    bucket = "test-terraform-backend-store-stg"
    // change prefix - this can not be paramaterized
    prefix = "pubsub/product_webhook_topic"
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

module "pubsub" {
  source     = "git@github.com:ozgurrahmi/sc-terraform-common-modules.git//modules/pubsub"
  project_id = module.shared.project
  env_name   = module.shared.env_name
  topic_name = local.topic_name
}
