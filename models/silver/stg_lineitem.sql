{{ config(materialized='table') }}

with casted as (
    select
        {{ dbt_utils.generate_surrogate_key(['order_id', 'line_number']) }} AS lineitem_id,
        order_id,
        part_id,
        supplier_id,
        cast(line_number as smallint) as line_number,
        cast(quantity as numeric(12,2)) as quantity,
        cast(extended_price as numeric(14,2)) as extended_price,
        cast(discount as numeric(5,2)) as discount,
        cast(tax as numeric(5,2)) as tax,
        trim(upper(return_flag)) as return_flag,
        trim(upper(line_status)) as line_status,
        cast(ship_date as date) as ship_date,
        cast(commit_date as date) as commit_date,
        cast(receipt_date as date) as receipt_date,
        trim(ship_instructions) as ship_instructions,
        trim(ship_mode) as ship_mode
    from {{ ref('raw_lineitem') }}
),

cleaned as (
    select *
    from casted
    where order_id is not null
      and part_id is not null
      and supplier_id is not null
),

deduplicated as (
    select *
    from cleaned
    qualify row_number() over (
        partition by order_id, line_number
        order by ship_date desc
    ) = 1
)

select *
from deduplicated