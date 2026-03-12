{{ config(materialized='table') }}

-- Casteo y limpieza de variables
with casted as (
select
    cast(region_id as smallint) as region_id,
    trim(lower(region_name)) as region_name
from {{ ref('raw_region') }}
),

-- Eliminamos los registros con valores nulos en las columnas region_id y region_name, ya que son claves para identificar cada región
cleaned as (
    select *
    from casted
    where region_id is not null 
),

-- Recuperamos los registros duplicados, y seleccionamos el primero de ellos para eliminar el resto
deduplicated as (
select *
from cleaned
qualify row_number() over (
    partition by region_id
    order by region_name
) = 1
)

select *
from deduplicated