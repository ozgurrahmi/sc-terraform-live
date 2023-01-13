locals {
  # Load the relevant env.hcl file based on where terragrunt was invoked. This works because find_in_parent_folders
  # always works at the context of the child configuration.
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl")) 
  global_env_vars = read_terragrunt_config(find_in_parent_folders("global_env.hcl"))
  env_name = local.env_vars.locals.env_name
  project_id = local.env_vars.locals.project_id
  region = local.env_vars.locals.region
  bucket_name = "${local.global_env_vars.locals.bucket_name}-${local.env_name}"
} 

// Advantage : common remote state file
remote_state {
  backend = "gcs" 

   config    = {
    bucket   = local.bucket_name
    prefix   = "${path_relative_to_include()}/terraform.tfstate"
    project  = local.project_id
    location = local.env_vars.locals.region
  }

   generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}


// Advantage : common provider file
generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "google" {
  project = "project-diddy-staging-153"
  region  = "europe-west1"
}
EOF
}