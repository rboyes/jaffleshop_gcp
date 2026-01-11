output "dbt_service_account_email" {
  description = "Email for the dbt runner service account."
  value       = google_service_account.dbt_runner.email
}

output "bigquery_datasets" {
  description = "Provisioned BigQuery datasets."
  value = {
    internal     = google_bigquery_dataset.internal.dataset_id
    presentation = google_bigquery_dataset.presentation.dataset_id
  }
}

output "project_bucket_name" {
  description = "GCS bucket for project."
  value       = google_storage_bucket.project.name
}
