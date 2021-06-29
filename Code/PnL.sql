-- select * from datahub.grab_vn_booking_tab gvbt limit 10;

with temp as(
select driver_id ,
completed_date as order_day,
count(booking_id) * 10 as total_point
from datahub.grab_vn_booking_tab gvbt 
group by 1,2)
,temp2 as(
select 
driver_id,
order_day,
CASE 
	when total_point < 50 then 0
	when total_point between 50 and 100 then 80000
	when total_point between 101 and 150 then 120000
	when total_point between 151 and 200 then 150000
	when total_point between 201 and 250 then 200000
	when total_point > 250 then 280000
end as bonus_money
from temp)
,temp3 as (
select order_day,
sum(bonus_money) as cost
from temp2
group by 1)
,temp4 as(
select
completed_date as order_day,
service_name,
CASE 
	when service_name = 'Bike' then total_amount * 0.20
	when service_name = 'Car' then total_amount * 0.25
	when service_name = 'Express' then total_amount * 0.1
	when service_name = 'Food' then total_amount * 0.1
	when service_name = 'Market' then total_amount * 0.0
end as commission_money
from datahub.grab_vn_booking_tab
group by 1,2,3)
,temp5 as(
select 
order_day,
sum(commission_money) as revenue
from temp4
group by 1)
select
a.order_day,
b.revenue - a.cost as PnL
from temp3 a left join temp5 b on a.order_day=b.order_day;