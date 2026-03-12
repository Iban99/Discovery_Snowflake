{{ config(materialized='table') }}

with casted as (
select
    part_id,
    trim(lower(part_name)) as part_name,
    trim(manufacturer) as manufacturer,
    trim(brand) as brand,
    trim(type) as part_type,
    size as size,
    trim(container) as container,
    retail_price as retail_price
from {{ ref('raw_part') }}
),

cleaned as (
select
    part_id,
    part_name,
    manufacturer,
    brand,
    part_type,
    size,
    container,
    coalesce(retail_price,0) as retail_price
from casted
where part_id is not null
),

deduplicated as (
select *
from cleaned
qualify row_number() over (
    partition by part_id
    order by part_name
) = 1
)

select *
from deduplicated