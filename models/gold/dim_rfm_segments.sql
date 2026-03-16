{{ config(materialized='table') }}

-- Tabla de mapping de segmentos RFM
select 5 as r_score, 5 as f_score, 5 as m_score, 'Champions' as segment
union all
select 5,5,4,'Champions'
union all
select 5,4,5,'Champions'
union all
select 4,5,5,'Champions'

union all
select 4,4,4,'Loyal Customers'
union all
select 4,4,3,'Loyal Customers'
union all
select 5,5,3,'Loyal Customers'
union all
select 5,4,3,'Loyal Customers'
union all
select 4,5,3,'Loyal Customers'

union all
select 3,5,5,'Profitable Customers'
union all
select 3,4,5,'Profitable Customers'
union all
select 3,5,4,'Profitable Customers'
union all
select 3,4,4,'Profitable Customers'

union all
select 1,3,3,'Potential Loyalists'
union all
select 2,3,3,'Potential Loyalists'

union all
select 1,1,4,'Big Spenders'
union all
select 1,1,5,'Big Spenders'
union all
select 2,2,4,'Big Spenders'
union all
select 2,2,5,'Big Spenders'

union all
select 4,1,1,'Recent Customers'
union all
select 4,1,2,'Recent Customers'
union all
select 5,1,1,'Recent Customers'
union all
select 5,1,2,'Recent Customers'

union all
select 3,3,3,'Promising'

union all
select 1,1,1,'At Risk'
union all
select 1,2,1,'At Risk'
union all
select 2,1,1,'At Risk'
union all
select 2,2,1,'At Risk'
union all
select 1,1,2,'At Risk'
union all
select 1,2,2,'At Risk'
union all
select 2,1,2,'At Risk'
union all
select 2,2,2,'At Risk'

union all
select 3,1,1,'Doubtful'
union all
select 3,2,2,'Doubtful'
union all
select 3,1,2,'Doubtful'
union all
select 3,2,1,'Doubtful'