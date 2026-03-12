{{ config(materialized='table') }}

with casted as (
    select
        cast(nation_id as smallint) as nation_id,
        trim(lower(nation_name)) as nation_name,
        cast(region_id as smallint) as region_id
    from {{ ref('raw_nation') }}
),

cleaned as (
    select *
    from casted
    where nation_id is not null
),

joined as (
    select
        n.nation_id as nation_id,
        n.nation_name as nation_name,
        r.region_id as region_id,
        r.region_name as region_name
    from cleaned as n
    left join {{ ref('stg_region') }} as r
        on n.region_id = r.region_id
),

deduplicated as (
    select *
    from joined
    qualify row_number() over (
        partition by nation_id
        order by nation_name
    ) = 1
)

select *
from deduplicated