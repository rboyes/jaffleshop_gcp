provider "google" {
  project = var.project_id
  region  = var.region
}

import {
  to = google_service_account.dbt_runner
  id = "projects/${var.project_id}/serviceAccounts/dbt-runner@${var.project_id}.iam.gserviceaccount.com"
}

import {
  to = google_bigquery_dataset.prod
  id = "projects/${var.project_id}/datasets/${var.prod_dataset_id}"
}

import {
  to = google_bigquery_dataset.dev
  id = "projects/${var.project_id}/datasets/${var.dev_dataset_id}"
}

resource "google_project_service" "bigquery" {
  project = var.project_id
  service = "bigquery.googleapis.com"
}

resource "google_project_service" "iam" {
  project = var.project_id
  service = "iam.googleapis.com"
}

resource "google_project_service" "storage" {
  project = var.project_id
  service = "storage.googleapis.com"
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

resource "google_storage_bucket" "csv" {
  name                        = var.csv_bucket_name
  project                     = var.project_id
  location                    = var.region
  uniform_bucket_level_access = true

  depends_on = [google_project_service.storage]
}

resource "google_storage_bucket_iam_member" "dbt_runner_object_viewer" {
  bucket = google_storage_bucket.csv.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.dbt_runner.email}"
}
