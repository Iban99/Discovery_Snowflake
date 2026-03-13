{{ config(materialized='table') }}

with fact_sales_data as (
    select *
    from {{ ref('fact_sales') }}
),

max_date as (
    select max(order_date) as max_order_date
    from fact_sales_data
),

fact_last_year as (
    select f.*, max_order_date
    from fact_sales_data as f
    join max_date as m
        on 1=1
    where order_date >= dateadd(year, -1, m.max_order_date)
),

customer_r as (
    select 
        customer_id,
        datediff(day, max(order_date), (select max_order_date from max_date)) as recency
    from fact_last_year
    group by customer_id
)

select *
from customer_r