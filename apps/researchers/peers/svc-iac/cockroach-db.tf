locals {
  sql_user_name     = local.app_name
  sql_user_password = "${local.app_name}-1x26ys47"
}

# variable "sql_user_name" {
#   type     = string
#   nullable = false
#   default  = local.app_name
# }

# # Remember that even variables marked sensitive will show up
# # in the Terraform state file. Always follow best practices
# # when managing sensitive info.
# # https://developer.hashicorp.com/terraform/tutorials/configuration-language/sensitive-variables#sensitive-values-in-state
# variable "sql_user_password" {
#   type      = string
#   nullable  = false
#   sensitive = true
#   default   = "${local.app_name}-1x26ys47"
# }

resource "cockroach_database" "db" {
  name       = local.app_name
  cluster_id = var.database_management_system_id
}

data "cockroach_connection_string" "db" {
  id       = var.database_management_system_id
  database = cockroach_database.db.name
  sql_user = local.sql_user_name
  password = local.sql_user_password
  os       = "LINUX"
}
