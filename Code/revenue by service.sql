select * from datahub.grab_vn_booking_tab gvbt limit 2;

with temp3 as(
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
select 
order_day,
service_name,
sum(commission_money) as revenue
from temp3
group by 1,2