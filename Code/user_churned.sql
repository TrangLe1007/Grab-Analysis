with last_order_days as (select DISTINCT user_id, 
min(completed_date) as first_order_date,
max(completed_date) as last_order_date,
DATEDIFF(date('2019-09-30'), max(completed_date)) as last_ordered_days
From datahub.grab_vn_booking_tab gvbt 
where completed_date < date('2019-10-01')
group by 1)
select 
case when last_ordered_days < 31 then 'G1: under 30'
when last_ordered_days between 31 and 60 then 'G2: 30-60'
when last_ordered_days between 61 and 90 then 'G3: 60-90'
when last_ordered_days > 90 then 'G4: above 90' end as user_group,
count(user_id) as total_users
from last_order_days
group by 1