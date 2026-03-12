{{ config(materialized='table',
        schema='bronze') }}

select s_suppkey   as supplier_id,
    s_name      as supplier_name,
    s_address   as address,
    s_nationkey as nation_id,
    s_phone     as phone,
    s_acctbal   as account_balance,
    s_comment   as supplier_comment,
    current_timestamp() as ingestion_timestamp
from {{ source('tpch_sf1', 'SUPPLIER') }}