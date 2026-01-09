provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_project_service" "bigquery" {
  project = var.project_id
  service = "bigquery.googleapis.com"
}

resource "google_project_service" "iam" {
  project = var.project_id
  service = "iam.googleapis.com"
}

resource "google_service_account" "dbt_runner" {
  account_id   = "dbt-runner"
  display_name = "dbt runner"
  project      = var.project_id

  depends_on = [google_project_service.iam]
}

resource "google_project_iam_member" "dbt_job_user" {
  project = var.project_id
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.dbt_runner.email}"
}

resource "google_project_iam_member" "dbt_data_editor" {
  project = var.project_id
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:${google_service_account.dbt_runner.email}"
}

resource "google_bigquery_dataset" "prod" {
  dataset_id = var.prod_dataset_id
  project    = var.project_id
  location   = var.location
  default_table_expiration_ms = 5184000000
  default_partition_expiration_ms = 5184000000

  depends_on = [google_project_service.bigquery]
}

resource "google_bigquery_dataset" "dev" {
  dataset_id = var.dev_dataset_id
  project    = var.project_id
  location   = var.location
  default_table_expiration_ms = 5184000000
  default_partition_expiration_ms = 5184000000

  depends_on = [google_project_service.bigquery]
}
