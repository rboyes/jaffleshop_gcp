## Jaffle Shop Google Cloud

Introductory code to run DBT on Google Cloud

### Pre-requisites

- Google cloud project created - call it jaffleshop-483809
  ```bash
  gcloud projects create jaffleshop-483809 --name="jaffleshop"
  ```
- Terraform
- Google cloud admin service account created for project - call it terraform-runner
  ```bash
  # Create service account
  gcloud iam service-accounts create terraform-runner \
    --project jaffleshop-483809 \
    --display-name "Terraform runner"

  # Grant full project permissions (broad)
  gcloud projects add-iam-policy-binding jaffleshop-483809 \
    --member "serviceAccount:terraform-runner@jaffleshop-483809.iam.gserviceaccount.com" \
    --role "roles/owner"

  # Create a key file
  gcloud iam service-accounts keys create ./terraform-runner-key.json \
    --project jaffleshop-483809 \
    --iam-account "terraform-runner@jaffleshop-483809.iam.gserviceaccount.com"
  ```
- uv https://docs.astral.sh/uv/



### Terraform provisioning

Done by github action in .github/workflows/terraform-apply

Terraform provisions:
- BigQuery API enablement
- `jaffleshop` + `jaffleshop_dev` datasets in `europe-west2`
- `dbt-runner` service account with `bigquery.jobUser` + `bigquery.dataEditor`

Key creation is intentionally left out of Terraform to avoid storing secrets in state.
Create a key only if you need one:

```bash
gcloud iam service-accounts keys create ../dbt-runner-key.json \
  --project jaffleshop-483809 \
  --iam-account "dbt-runner@jaffleshop-483809.iam.gserviceaccount.com"
```

### Install uv and synchronise

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
uv sync
source .venv/bin/activate
```

### Run DBT

```bash
# Ensure this runs in the repo root as some paths are relative
dbt debug
dbt build
bq query 'SELECT order_id,customer_id,order_date,status FROM jaffleshop_dev.orders' --project_id=jaffleshop-483809
```
