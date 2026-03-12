{{ config(materialized='table',
        schema='bronze') }}

select c_custkey    as customer_id,
    c_name       as customer_name,
    c_address    as address,
    c_nationkey  as nation_id,
    c_phone      as phone,
    c_acctbal    as account_balance,
    c_mktsegment as market_segment,
    c_comment    as customer_comment,
    current_timestamp() as ingestion_timestamp
from {{ source('tpch_sf1', 'CUSTOMER') }}