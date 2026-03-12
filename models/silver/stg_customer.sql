{{ config(materialized='table') }}

with casted as (
    select
        customer_id,
        trim(customer_name) as customer_name,
        trim(address) as address,
        cast(nation_id as smallint) as nation_id,
        trim(phone) as phone,
        cast(account_balance as numeric(12,2)) as account_balance,
        trim(lower(market_segment)) as market_segment
    from {{ ref('raw_customer') }}
),

cleaned as (
    select
        customer_id,
        customer_name,
        address,
        nation_id,
        phone,
        coalesce(account_balance,0) as account_balance,
        coalesce(market_segment,'unknown') as market_segment
    from casted
    where customer_id is not null
),

deduplicated as (
    select *
    from cleaned
    qualify row_number() over (
        partition by customer_id
        order by customer_name
    ) = 1
)

select *
from deduplicated