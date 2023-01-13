include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path   = "${get_terragrunt_dir()}/../../../common/pubsub/order_delete_topic/terragrunt.hcl"
  expose = true
}