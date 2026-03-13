{{ config(materialized='table') }}

with customers as(
select *
from {{ ref('stg_customer') }}
),

order_date as(
select 
    customer_id,
    min(order_date) as first_purchase_date,
    max(order_date) as last_purchase_date
from {{ ref('stg_orders') }}
group by customer_id
)

select 
    c.customer_id as customer_id,
    c.customer_name as name,
    n.nation_name as nation,
    n.region_name as region,
    c.account_balance as account_balance,
    c.market_segment as market_segment,  
    o.first_purchase_date as first_purchase_date,
    o.last_purchase_date as last_purchase_date,
    case when o.last_purchase_date is null then false
         when datediff(year, o.last_purchase_date, current_date) > 1 then false
         else true end as is_active_customer,
    datediff(day, o.first_purchase_date, current_date) as tenure_days
from customers as c 
left join order_date as o
    on c.customer_id = o.customer_id
left join {{ ref('stg_nation') }} as n
    on c.nation_id = n.nation_id