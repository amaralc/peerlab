terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.65.2" # Adjust the version to match the latest release
    }

    google-beta = {
      source  = "hashicorp/google-beta"
      version = "4.65.2" # Adjust the version to match the latest release
    }

    # neon = {
    #   source  = "kislerdm/neon"
    #   version = "0.1.0"
    # }

    cockroach = {
      source  = "cockroachdb/cockroach"
      version = "0.5.0"
    }
  }
}

# Configure the Google Cloud Provider for Terraform
provider "google" {
  credentials = file(var.credentials_path) # The service account key
  project     = var.project_id             # Your Google Cloud project ID
  region      = var.region                 # The region where resources will be created
}

# The google-beta provider is used for features not yet available in the google provider
provider "google-beta" {
  credentials = file(var.credentials_path) # The service account key
  project     = var.project_id             # Your Google Cloud project ID
  region      = var.region                 # The region where resources will be created
}

# # Neon DB provider
# provider "neon" {
#   api_key = var.neon_api_key
# }

# Cockroach DB Provider
provider "cockroach" {
  apikey = var.cockroach_api_key
}


