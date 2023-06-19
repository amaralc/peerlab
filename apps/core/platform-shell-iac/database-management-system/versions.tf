terraform {
  required_providers {
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

# # Neon DB provider
# provider "neon" {
#   api_key = var.neon_api_key
# }

# Cockroach DB Provider
provider "cockroach" {
  apikey = var.cockroach_api_key
}

