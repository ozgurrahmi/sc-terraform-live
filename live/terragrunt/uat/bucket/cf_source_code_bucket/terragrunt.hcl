include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path   = "${get_terragrunt_dir()}/../../../common/bucket/cf_source_code_bucket/terragrunt.hcl"
  expose = true
}