{{ config(materialized='table',
        schema='bronze') }}

select n_nationkey as nation_id,
    n_name      as nation_name,
    n_regionkey as region_id,
    n_comment   as nation_comment,
    current_timestamp() as ingestion_timestamp
from {{ source('tpch_sf1', 'NATION') }}