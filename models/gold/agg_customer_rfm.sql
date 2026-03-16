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
),

customer_f as (
    select 
        customer_id,
        count(distinct order_id) as frequency
    from fact_last_year
    group by customer_id
),

customer_m as(
    select 
        customer_id,
        max(total_order_price) as monetary
    from fact_last_year
    group by customer_id
),

customer_rfm as(
    select 
        r.customer_id,
        r.recency,  
        f.frequency,
        m.monetary
    from customer_r as r
    join customer_f as f
        on r.customer_id = f.customer_id
    join customer_m as m
        on r.customer_id = m.customer_id
),

customer_rfm_scores as (
    select
        customer_id,
        recency,
        frequency,
        monetary,
        ntile(5) over (order by recency desc) as r_score,
        ntile(5) over (order by frequency asc) as f_score,
        ntile(5) over (order by monetary asc) as m_score
    from customer_rfm
),

customer_rfm_segments as (
select
    c.*,
    concat(c.r_score, c.f_score, c.m_score) as rfm_score,
    s.segment as rfm_segment
from customer_rfm_scores as c
join {{ ref('dim_rfm_segments') }} as s
    on c.r_score = s.r_score
    and c.f_score = s.f_score
    and c.m_score = s.m_score
) 

select *
from customer_rfm_segments