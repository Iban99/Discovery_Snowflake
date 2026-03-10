{{ config(materialized='table',
        schema='silver') }}

select *
from {{ ref('raw_customer')}}
limit 10