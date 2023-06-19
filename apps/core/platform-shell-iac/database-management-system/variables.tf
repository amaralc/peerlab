variable "project_id" {
  description = "The Project ID"
  type        = string
  sensitive   = true
}

# variable "neon_project_location" {
#   description = "The Neon Project Location"
#   type        = string
#   sensitive   = true
# }

# variable "neon_api_key" {
#   description = "Neon API key"
#   type        = string
#   sensitive   = true
# }

variable "cockroach_api_key" {
  description = "Cockroach API key"
  type        = string
  sensitive   = true
}
