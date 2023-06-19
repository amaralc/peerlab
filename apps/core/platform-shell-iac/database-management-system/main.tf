# Cockroach

locals {
  cluster_name           = var.project_id   # Use the same project ID as in the Google Cloud provider
  serverless_spend_limit = 500              # Cents of dollars
  cloud_provider         = "GCP"            # Cloud provider initials
  cloud_provider_regions = ["europe-west1"] # Cloud provider location
}

# variable "cluster_name" {
#   type     = string
#   nullable = false
#   default  = var.project_id
# }

# variable "serverless_spend_limit" {
#   type     = number
#   nullable = false
#   default  = 5
# }

# variable "cloud_provider" {
#   type     = string
#   nullable = false
#   default  = "GCP"
# }

# variable "cloud_provider_regions" {
#   type     = list(string)
#   nullable = false
#   default  = ["europe-west1"]
# }

resource "cockroach_cluster" "dbms" {
  name           = local.cluster_name
  cloud_provider = local.cloud_provider
  serverless = {
    spend_limit = local.serverless_spend_limit
  }
  regions = [for r in local.cloud_provider_regions : { name = r }]
}

# Neon Database
# # PostgreSQL Database Management System
# # Reference: https://registry.terraform.io/providers/kislerdm/neon/latest/docs
# resource "neon_project" "postgresql-dbms" {
#   name                     = var.project_id            # Use the same project ID as in the Google Cloud provider
#   region_id                = var.neon_project_location #"aws-eu-central-1"
#   autoscaling_limit_max_cu = 1
# }

# # PostgreSql Database
# # Reference: https://registry.terraform.io/providers/kislerdm/neon/latest/docs
# resource "neon_project" "peerlab-platform" {
#   name                     = "peerlab-platform"        # Use the same project ID as in the Google Cloud provider
#   region_id                = var.neon_project_location #"aws-eu-central-1"
#   autoscaling_limit_max_cu = 1
# }

# resource "neon_branch" "peerlab-platform-production" {
#   project_id = neon_project.peerlab-platform.id
#   name       = var.environment
# }

# locals {
#   host_parts  = split(".", neon_branch.peerlab-platform-production.host)
#   pooler_host = join(".", [format("%s-pooler", local.host_parts[0]), join(".", slice(local.host_parts, 1, length(local.host_parts)))])
# }


