{{ config(materialized='table',
        schema='bronze') }}

select r_regionkey as region_id,
    r_name      as region_name,
    r_comment   as region_comment,
    current_timestamp() as ingestion_timestamp
from {{ source('tpch_sf1', 'REGION') }}