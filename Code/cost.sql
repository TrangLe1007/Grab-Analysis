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
select order_day,
sum(bonus_money) as cost
from temp2
group by 1