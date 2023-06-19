
# output "secret_id" {
#   description = "secret_id"
#   value       = module.researchers-peers-svc-rest-api.secret_id
# }

output "connection_string" {
  value = local.database_direct_url
}
