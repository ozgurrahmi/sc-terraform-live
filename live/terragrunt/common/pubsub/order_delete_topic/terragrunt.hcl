locals {
  # Load the relevant env.hcl file based on where terragrunt was invoked. This works because find_in_parent_folders
  # always works at the context of the child configuration.
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env_name = get_env("ENV", local.env_vars.locals.env_name)
}

inputs = {
  topic_name = "order-delete-topic-${local.env_name}"
  env_name    = local.env_name
  project_id  = local.env_vars.locals.project_id
}

terraform {
  source = local.env_vars.locals.pubsub_url
}