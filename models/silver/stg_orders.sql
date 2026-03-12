{{ config(materialized='table') }}

with casted as (
    select
        order_id,
        coalesce(customer_id, -1) as customer_id,
        trim(order_status) as order_status,
        cast(total_price as numeric(14,2)) as total_price,
        cast(order_date as date) as order_date,
        trim(order_priority) as order_priority,
        trim(upper(clerk)) as clerk,
        ship_priority
    from {{ ref('raw_orders') }}
),

cleaned as (
    select *
    from casted
    where order_id is not null
),

deduplicated as (
    select *
    from cleaned
    qualify row_number() over (
        partition by order_id
        order by order_date desc
    ) = 1
)

select *
from deduplicated