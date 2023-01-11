terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.32.0"
    }
  }

  // variables are not allowed in bucket and prefix!!  
  backend "gcs" {
    bucket = "test-remote-registry"
    prefix = "pubsub/create_topic"
  }
}

provider "google" {
  project = "project-diddy-staging-153"
  region  = "europe-west1"
}

module "pubsub" {
  source  = "terraform-google-modules/pubsub/google"
  version = "~> 5.0"

  topic      = "test-topic"
  project_id = "project-diddy-staging-153"
}

