{{ config(
    materialized='external',
    options={
      "format": "CSV",
      "uris": ["gs://jaffleshop-483809/csv/raw_orders.csv"],
      "skip_leading_rows": 1
    }
) }}

select
  cast(null as int64) as id,
  cast(null as int64) as user_id,
  cast(null as date) as order_date,
  cast(null as string) as status
where false
