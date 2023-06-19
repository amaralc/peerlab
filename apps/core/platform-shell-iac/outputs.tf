# output "secret_id" {
#   description = "secret_id"
#   value       = module.staging.secret_id
# }

output "connection_string" {
  value = module.production.connection_string
}
