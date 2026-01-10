# AGENTS

## Project summary
- dbt project configured for BigQuery (GCP project: `jaffleshop-483809`).
- Profiles live in the repo root as `profiles.yml` and use a service account key file.
- Terraform provisioning uses GitHub Actions workload identity federation.

## Local setup
- Use `uv sync` to install dependencies and `source .venv/bin/activate`.
- Run dbt from the repo root so relative paths in `profiles.yml` resolve.

## BigQuery conventions
- Dev dataset: `jaffleshop_dev`
- Prod dataset: `jaffleshop`
- Location: `europe-west2`

## Security
- Never commit `dbt-runner-key.json`. Keep it in `.gitignore` and rotate if it was exposed.

## Common commands
- `dbt debug`
- `dbt build`

## Notes for changes
- If you change datasets, update `profiles.yml` and README instructions together.
- Keep docs concise to avoid BigQuery column description limits.
