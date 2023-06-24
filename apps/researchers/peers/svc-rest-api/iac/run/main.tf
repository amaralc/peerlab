data "google_vpc_access_connector" "connector" {
  provider = google-beta
  name     = "vpcconn"
}

# This resource block defines a Google Cloud Run service. This service will host the Docker image created by the Google Cloud Build trigger.
resource "google_cloud_run_service" "instance" {
  # Name of the service
  name = "${var.docker_image_name}-${var.environment_name}-${var.commit_hash}" # Use the commit hash to force a new revision to be created

  # The region where the service will be located
  location = var.gcp_location

  # Depends on secret versions
  depends_on = [var.gcp_pooled_database_connection_url_secret_version, var.gcp_direct_database_connection_url_secret_version, var.gcp_vpc_access_connector_name]


  # Defining the service template
  template {
    spec {
      # The service account to be used by the service
      service_account_name = var.gcp_service_account_email

      # The Docker image to use for the service
      containers {
        # The docker image is pulled from GCR using the project ID, app name and the image tag which corresponds to the commit hash
        image = "${var.gcp_location}-docker.pkg.dev/${var.gcp_project_id}/${var.gcp_docker_artifact_repository_name}/${var.docker_image_name}:${var.environment_name}" # Use the environment to tag the image (staging, production, etc)

        # Set the ENTRYPOINT_PATH environment variable (check the Dockerfile for more details)
        env {
          name  = "ENTRYPOINT_PATH"
          value = "apps/researchers/peers/svc-rest-api/entrypoint.sh"
        }

        # Set the POSTGRES_POOLED_CONNECTION_DATABASE_URL environment variable from the database URL secret
        env {
          name = "POSTGRES_POOLED_CONNECTION_DATABASE_URL"
          value_from {
            secret_key_ref {
              name = var.gcp_pooled_database_connection_url_secret_id # Reference the secret
              key  = "latest"                                         # Use the latest version of the secret
            }
          }
        }

        # Set the POSTGRES_DIRECT_CONNECTION_DATABASE_URL environment variable from the direct URL secret
        env {
          name = "POSTGRES_DIRECT_CONNECTION_DATABASE_URL"
          value_from {
            secret_key_ref {
              name = var.gcp_direct_database_connection_url_secret_id # Reference the secret
              key  = "latest"                                         # Use the latest version of the secret
            }
          }
        }
      }
    }

    # References:
    # https://stackoverflow.com/questions/68018718/terraform-google-cloud-run-add-cloud-sql-connection
    # https://github.com/hashicorp/terraform-provider-google/issues/6004#issuecomment-607282371
    metadata {
      annotations = {
        # Limit scale up to prevent any cost blow outs!
        "autoscaling.knative.dev/maxScale" = "1"
        # Use the VPC Connector
        "run.googleapis.com/vpc-access-connector" = var.gcp_vpc_access_connector_name
        # all egress from the service should go through the VPC Connector
        "run.googleapis.com/vpc-access-egress" = "all-traffic"
        # # Set the Cloud SQL instance to be used by the service
        # "run.googleapis.com/cloudsql-instances" = var.gcp_sql_database_instance_connection_name
      }
      # annotations = {
      #   "run.googleapis.com/cloudsql-instances" = var.gcp_sql_database_instance_connection_name # Set the Cloud SQL instance to be used by the service
      # }
    }

  }

  # Defines the service traffic parameters
  traffic {
    # The percent of traffic this version of the service should receive
    percent = 100

    # Whether traffic should be directed to the latest revision
    latest_revision = true
  }
}

# This block defines a Cloud Run IAM member. This sets the permissions for who can access the Cloud Run service.
resource "google_cloud_run_service_iam_member" "public" {
  service  = google_cloud_run_service.apps_researchers_peers_rest_api.name     # The name of the service to which the IAM policy will be applied
  location = google_cloud_run_service.apps_researchers_peers_rest_api.location # The location of the service to which the IAM policy will be applied
  role     = "roles/run.invoker"                                               # The role to be granted
  member   = "allUsers"                                                        # The user, group, or service account who will have the role granted. In this case, all users.
}
