terraform {
  required_version = ">= 1.5.0"

  backend "gcs" {
    bucket = "jaffleshop-483809-tfstate"
    prefix = "terraform/state"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}
