include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path   = "${get_terragrunt_dir()}/../../../common/cloudfunction/test_order_delete_cf/terragrunt.hcl"
  expose = true
}




