locals {
  topic_name = "test_product_webhook_topic"
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
    prefix = "pubsub/test_product_webhook_topic"
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
  source     = "git@github.com:ozgurrahmi/sc-terraform-common-modules.git//modules/pubsub?ref=v3.0"
  project_id = module.shared.project
  env_name   = module.shared.env_name
  topic_name = local.topic_name
}
