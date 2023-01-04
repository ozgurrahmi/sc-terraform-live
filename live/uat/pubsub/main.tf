locals {
  project    = "project-diddy-staging-153"
  region     = "europe-west1"
  env_name   = "uat"
  topic_name = "example-topiccc"
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }

  backend "gcs" {
    bucket = "test-terraform-backend-store"
    prefix = "terraform/state"
  }
}

module "pubsub" {
  source     = "git@github.com:ozgurrahmi/sc-terraform-common-modules.git//modules/pubsub"
  project_id = local.project
  topic_name = local.topic_name
  env_name   = local.env_name
}

provider "google" {
  project = local.project
  region  = local.region
}






