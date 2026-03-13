{{ config(materialized='table') }}

with supplier as (
select *
from {{ ref('stg_supplier')}}
),

nations as (
select *
from {{ ref('stg_nation')}}
),

joined as(
select 
    s.supplier_id as supplier_id,
    s.supplier_name as name,
    s.account_balance as account_balance,
    n.nation_name as nation,
    n.region_name as region
from supplier as s
left join nations as n
    on s.nation_id = n.nation_id
)

select *
from joined