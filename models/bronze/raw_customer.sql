{{ config(materialized='table') }}

select *
from {{ source('tpch_sf1', 'CUSTOMER') }}