## Jaffle Shop Google Cloud

Introductory code to run DBT on Google Cloud

### Pre-requisites

- Google cloud project created - call it jaffleshop-483809
  ```bash
  gcloud projects create jaffleshop-483809 --name="jaffleshop"
  ```
- Terraform
- Google cloud admin service account created for project deployment - call it terraform-runner
  ```bash
  # Create service account
  gcloud iam service-accounts create terraform-runner \
    --project jaffleshop-483809 \
    --display-name "Terraform runner"

  # Grant full project permissions (broad)
  gcloud projects add-iam-policy-binding jaffleshop-483809 \
    --member "serviceAccount:terraform-runner@jaffleshop-483809.iam.gserviceaccount.com" \
    --role "roles/owner"

  # Storage bucket to maintain state
  gcloud storage buckets create gs://jaffleshop-483809-tfstate \
    --project=jaffleshop-483809 \
    --location=europe-west2 \
    --uniform-bucket-level-access

  gcloud storage buckets update gs://jaffleshop-483809-tfstate --versioning

  ```
- Workload identity federation for GitHub Actions
  ```bash
  PROJECT_NUMBER=$(gcloud projects describe jaffleshop-483809 --format="get(projectNumber)")
  OWNER="rboyes"
  REPO="jaffleshop_gcp"

  gcloud iam workload-identity-pools create "github-actions" \
    --project jaffleshop-483809 \
    --location "global" \
    --display-name "GitHub Actions"

  gcloud iam workload-identity-pools providers create-oidc "github-actions" \
    --project jaffleshop-483809 \
    --location "global" \
    --workload-identity-pool "github-actions" \
    --display-name "GitHub Actions" \
    --issuer-uri "https://token.actions.githubusercontent.com" \
    --attribute-mapping "google.subject=assertion.sub,attribute.repository=assertion.repository" \
    --attribute-condition "attribute.repository=='${OWNER}/${REPO}'"

  gcloud iam service-accounts add-iam-policy-binding \
    "terraform-runner@jaffleshop-483809.iam.gserviceaccount.com" \
    --project "jaffleshop-483809" \
    --role "roles/iam.workloadIdentityUser" \
    --member "principalSet://iam.googleapis.com/projects/${PROJECT_NUMBER}/locations/global/workloadIdentityPools/github-actions/attribute.repository/${OWNER}/${REPO}"
  ```
- uv https://docs.astral.sh/uv/



### Terraform provisioning

Deploy the terraform:
```bash
cd infra/terraform
terraform init
terraform apply
```
Done by github action in .github/workflows/terraform-apply.yml

Terraform provisions:
- BigQuery API enablement
- `jaffleshop` + `jaffleshop_dev` datasets in `europe-west2`
- `dbt-runner` service account with `bigquery.jobUser` + `bigquery.dataEditor`

### Set up DBT and excecute

Install uv and synchronise
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
uv sync
source .venv/bin/activate
```

Copy the raw csv files to the storage bucket
```bash
gcloud storage cp --recursive csv gs://jaffleshop-483809/
```

Create a key for dbt to execute. Note `profiles.yml` refers to the file `dbt-runner-key.json` for authentication.

```bash
gcloud iam service-accounts keys create ./dbt-runner-key.json \
  --project jaffleshop-483809 \
  --iam-account "dbt-runner@jaffleshop-483809.iam.gserviceaccount.com"
```

Run DBT
```bash
# Ensure this runs in the repo root as some paths are relative
dbt deps
dbt run-operation stage_external_sources
dbt debug
dbt build
bq  --project_id=jaffleshop-483809 query 'SELECT order_id,customer_id,order_date,status FROM jaffleshop_dev.orders'
```
