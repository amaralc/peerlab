# output "neon_project_id" {
#   description = "The Neon Project ID"
#   value       = neon_project.postgresql-dbms.id
# }

output "id" {
  description = "The Database Management System ID"
  value       = cockroach_cluster.dbms.id
}
