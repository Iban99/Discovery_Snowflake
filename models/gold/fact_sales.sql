{{ config(materialized='table') }}

with orders as (
    select *
    from {{ ref('stg_orders') }}
),

lineitems as (
    select *
    from {{ ref('stg_lineitem') }}
),

customer as (
    select *
    from {{ ref('dim_customer') }}
),

partsupp as (
    select *
    from {{ ref('stg_partsupp') }}
),

product as (
    select *
    from {{ ref('dim_product') }}
),
-- unir lineitem con orders
lineitems_orders as (
    select
        li.lineitem_id as lineitem_id,
        li.order_id as order_id,
        li.line_number as line_number,
        o.customer_id as customer_id,
        c.nation as customer_nation,
        c.region as customer_region,
        li.part_id as part_id,
        li.supplier_id as supplier_id,
        li.quantity as quantity,
        li.extended_price as extended_price,
        li.discount as discount,
        li.tax as tax,
        li.extended_price * (1 - li.discount) * (1 + li.tax) as final_price,
        o.total_price as total_order_price,
        o.order_priority as order_priority,
        o.order_date as order_date,
        li.commit_date as commit_date,
        li.ship_date as ship_date,
        li.receipt_date as receipt_date
    from lineitems li
    left join orders o
        on li.order_id = o.order_id
    left join customer as c
        on o.customer_id = c.customer_id
),

-- agregar métricas por línea si quieres
lineitems_orders_partsupp as (
    select
        lo.*,
        ps.supply_cost as supply_cost
    from lineitems_orders as lo
    left join partsupp as ps
        on lo.part_id = ps.part_id
        and lo.supplier_id = ps.supplier_id
),

sales_product as (
select 
    lop.*,
    p.part_type as product_type,
    p.retail_price as retail_price
from lineitems_orders_partsupp as lop
left join product as p
    on lop.part_id = p.part_id
),

sales_cost as (
select 
    sp.*,
    sp.quantity * sp.supply_cost as total_cost,
    sp.final_price - (sp.quantity * sp.supply_cost) as profit
from sales_product as sp
)

select *
from sales_cost
