{{ config(materialized='table',
        schema='bronze') }}
 
select ps_partkey   as part_id,
    ps_suppkey   as supplier_id,
    ps_availqty  as available_quantity,
    ps_supplycost as supply_cost,
    ps_comment   as partsupp_comment,
    current_timestamp() as ingestion_timestamp
from {{ source('tpch_sf1', 'PARTSUPP') }}