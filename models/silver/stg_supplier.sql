{{ config(materialized='table') }}

with casted as (
    select
        supplier_id,
        trim(supplier_name) as supplier_name,
        trim(address) as address,
        cast(nation_id as smallint) as nation_id,
        trim(phone) as phone,
        cast(account_balance as numeric(12,2)) as account_balance
    from {{ ref('raw_supplier') }}
),

cleaned as (
    select
        supplier_id,
        supplier_name,
        address,
        nation_id,
        phone,
        coalesce(account_balance,0) as account_balance
    from casted
    where supplier_id is not null
),

deduplicated as (
    select *
    from cleaned
    qualify row_number() over (
        partition by supplier_id
        order by supplier_name
    ) = 1
)

select *
from deduplicated