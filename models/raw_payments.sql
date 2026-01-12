{{ config(
    materialized='external',
    options={
      "format": "CSV",
      "uris": ["gs://jaffleshop-483809/csv/raw_payments.csv"],
      "skip_leading_rows": 1
    }
) }}

select
  cast(null as int64) as id,
  cast(null as int64) as order_id,
  cast(null as string) as payment_method,
  cast(null as int64) as amount
where false
