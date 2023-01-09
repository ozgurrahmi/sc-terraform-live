locals {
  bucket_name = format("test-cloudfunction-%s", module.shared.env_name)
  name        = "order-webhook"
  topic_name  = "test-order-webhook-topic"
  runtime     = "go116"
  entry_point = "HelloPubSub"
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
    prefix = "cloudfunction/order_webhook_cf"
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

module "cloudfunction" {
  source      = "git@github.com:ozgurrahmi/sc-terraform-common-modules.git//modules/cloudfunction"
  project_id  = module.shared.project
  region_id   = module.shared.region
  env_name    = module.shared.env_name
  bucket_name = local.bucket_name
  name        = local.name
  runtime     = local.runtime
  entry_point = local.entry_point
  source_path = "git@github.com:ozgurrahmi/sc-terraform-common-modules.git//modules/cloudfunction"
  // module dependency 
  topic_name = module.pubsub.topic_name
}
