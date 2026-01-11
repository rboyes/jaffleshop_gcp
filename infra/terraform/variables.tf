variable "project_id" {
  type        = string
  description = "GCP project id."
}

variable "region" {
  type        = string
  description = "GCP region for regional resources."
  default     = "europe-west2"
}

variable "location" {
  type        = string
  description = "BigQuery dataset location."
  default     = "europe-west2"
}

variable "prod_dataset_id" {
  type        = string
  description = "BigQuery prod dataset id."
  default     = "jaffleshop"
}

variable "dev_dataset_id" {
  type        = string
  description = "BigQuery dev dataset id."
  default     = "jaffleshop_dev"
}

variable "project_bucket_name" {
  type        = string
  description = "GCS bucket name for project."
  default     = "jaffleshop-483809"
}
