# PostgreSQL Database Management System
module "database-management-system" {
  source            = "../database-management-system"
  project_id        = var.project_id
  cockroach_api_key = var.cockroach_api_key
}

# # PostgreSQL Database Branch Environment
# module "postgresql-dbms-environment" {
#   source           = "../postgresql-dbms-environment"
#   environment_name = var.environment_name
#   neon_project_id  = module.postgresql-dbms.neon_project_id
#   neon_api_key     = var.neon_api_key
# }

# Researchers Peers Service
module "researchers-peers-svc" {
  source                              = "../../../researchers/peers/svc-iac"
  commit_hash                         = var.commit_hash
  environment_name                    = var.environment_name
  project_id                          = var.project_id
  region                              = var.region
  gcp_docker_artifact_repository_name = var.gcp_docker_artifact_repository_name
  cockroach_api_key                   = var.cockroach_api_key
  credentials_path                    = var.credentials_path
  database_management_system_id       = module.database-management-system.id
}

# # Application Shell
# module "core-platform-shell-browser" {
#   source           = "../../../core/platform-shell-browser/iac/production" # The path to the module
#   environment_name = var.environment_name                                  # The deployment environment (branch-name, commit-hash, etc.)
#   vercel_api_token = var.vercel_api_token                                  # The Vercel API token
#   # depends_on       = [module.researchers-peers-svc]
# }

# # Documentation with Docusaurus
# module "dx-dev-docs-browser" {
#   source           = "../../../dx/dev-docs-browser/iac/production" # The path to the module
#   environment_name = var.environment_name                          # The deployment environment (branch-name, commit-hash, etc.)
#   vercel_api_token = var.vercel_api_token                          # The Vercel API token
#   # depends_on       = [module.researchers-peers-svc]
# }

