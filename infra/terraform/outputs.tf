output "dbt_service_account_email" {
  description = "Email for the dbt runner service account."
  value       = google_service_account.dbt_runner.email
}

output "bigquery_datasets" {
  description = "Provisioned BigQuery datasets."
  value = {
    prod = google_bigquery_dataset.prod.dataset_id
    dev  = google_bigquery_dataset.dev.dataset_id
  }
}

output "csv_bucket_name" {
  description = "GCS bucket for CSV seed files."
  value       = google_storage_bucket.csv.name
}
