## Jaffle Shop Google Cloud

Introductory code to run DBT on Google Cloud

### Pre-requisites

- Google cloud account
- uv
- Google cloud project created - call it jaffleshop-483809

### Google Cloud Setup

```bash
gcloud auth login
gcloud services enable bigquery.googleapis.com --project jaffleshop-483809

# Create the data sets for prod and dev
bq --location=europe-west2 mk --dataset jaffleshop-483809:jaffleshop
bq --location=europe-west2 mk --dataset jaffleshop-483809:jaffleshop_dev

# Create service account
gcloud iam service-accounts create dbt-runner --project jaffleshop-483809 --display-name "dbt runner"

# Grant BigQuery permissions
gcloud projects add-iam-policy-binding jaffleshop-483809 --member "serviceAccount:dbt-runner@jaffleshop-483809.iam.gserviceaccount.com" --role "roles/bigquery.jobUser"

gcloud projects add-iam-policy-binding jaffleshop-483809 --member "serviceAccount:dbt-runner@jaffleshop-483809.iam.gserviceaccount.com" --role "roles/bigquery.dataEditor"

# Create a key file
gcloud iam service-accounts keys create ./dbt-runner-key.json --project jaffleshop-483809 --iam-account "dbt-runner@jaffleshop-483809.iam.gserviceaccount.com"

# Add key file to .gitignore
echo "dbt-runner-key.json" >> .gitignore

```

### Install uv and synchronise

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
uv sync
source .venv/bin/activate
```

### Run DBT

```bash
dbt debug
dbt build
```
