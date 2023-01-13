locals {
  # Load the relevant env.hcl file based on where terragrunt was invoked. This works because find_in_parent_folders
  # always works at the context of the child configuration.
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env_name = get_env("ENV", local.env_vars.locals.env_name)
}

dependency "cf_source_code_bucket" {
  config_path = "${get_terragrunt_dir()}/../../bucket/cf_source_code_bucket"
}

dependency "topic_to_trigger" {
  config_path = "${get_terragrunt_dir()}/../../pubsub/order_delete_topic"
}

inputs = {
  project_id = local.env_vars.locals.project_id
  env_name = local.env_name
  region_id = local.env_vars.locals.region
  bucket_name = dependency.cf_source_code_bucket.outputs.bucket_name
  name = "test-order-delete-cf-${local.env_name}"
  runtime = local.env_vars.locals.runtime
  entry_point = local.env_vars.locals.entry_point
  source_path = local.env_vars.locals.source_path
  topic_name = dependency.topic_to_trigger.outputs.topic_name
}

terraform {
  source = local.env_vars.locals.cloud_function_url
}