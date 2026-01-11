variable "project_id" {
  type        = string
  description = "GCP project id."
  default     = "jaffleshop-483809"
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

variable "internal_dataset_id" {
  type        = string
  description = "BigQuery internal dataset id."
  default     = "internal"
}

variable "presentation_dataset_id" {
  type        = string
  description = "BigQuery presentation dataset id."
  default     = "presentation"
}

variable "project_bucket_name" {
  type        = string
  description = "GCS bucket name for project."
  default     = "jaffleshop-483809"
}
