{{ config(materialized='table') }}

with cleaned as (
select
    part_id,
    supplier_id,
    coalesce(available_quantity,0) as available_quantity,
    coalesce(supply_cost,0) as supply_cost
from {{ ref('raw_partsupp') }}

)

select *
from cleaned