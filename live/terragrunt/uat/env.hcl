locals {
  env_name = "uat"
  project_id = "project-diddy-staging-153"
  region = "europe-west1"
  version = "v3.0"
  source_base_url =  "git@github.com:ozgurrahmi/sc-terraform-common-modules.git//modules"
  bucket_source_url = "${local.source_base_url}/bucket?ref=${local.version}"
  cloud_function_url = "${local.source_base_url}/cloudfunction?ref=${local.version}"
  pubsub_url = "${local.source_base_url}/pubsub?ref=${local.version}"
  runtime = "go116"
  entry_point = "HelloPubSub"
  source_path = "${get_terragrunt_dir()}/../../terraform/${local.env_name}/cf_source_codes/order-webhook-cf-uat.zip"
}


