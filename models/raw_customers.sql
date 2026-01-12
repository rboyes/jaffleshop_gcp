{{ config(
    materialized='external',
    options={
      "format": "CSV",
      "uris": ["gs://jaffleshop-483809/csv/raw_customers.csv"],
      "skip_leading_rows": 1
    }
) }}

select
  cast(null as int64) as id,
  cast(null as string) as first_name,
  cast(null as string) as last_name
where false
