{{ config(materialized='table') }}

with products as (
    select *
    from {{ ref('stg_part') }}
),

part_suppliers as (
    select
        part_id,
        count(distinct supplier_id) as num_suppliers,
        min(supply_cost) as min_supply_cost,
        max(supply_cost) as max_supply_cost
    from {{ ref('stg_partsupp') }}
    group by part_id
)

select
    p.part_id,
    p.part_name,
    p.brand,
    p.manufacturer,
    p.part_type,
    p.size,
    p.container,
    p.retail_price,
    coalesce(ps.num_suppliers, 0) as num_suppliers,
    ps.min_supply_cost as min_supply_cost,
    ps.max_supply_cost as max_supply_cost
from products p
left join part_suppliers ps
    on p.part_id = ps.part_id