{{ config(materialized='table',
        schema='bronze') }}

select *
from {{ source('tpch_sf1', 'CUSTOMER') }}