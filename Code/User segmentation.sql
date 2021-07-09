select
Month(completed_date) as month_order,
count(booking_id) as total_order,
round(sum(total_amount),2) as GMV,
count(distinct user_id) as active_users
from datahub.grab_vn_booking_tab gvbt
group by 1;

with b as (select 
user_id,
Month(completed_date) as month_order,
count(booking_id) as total_order,
round(sum(total_amount),2) as GMV,
CASE 
	when count(booking_id) < 5 then "Sliver"
	when count(booking_id) between 5 and 10 then "Gold"
	when (count(booking_id) > 10 and count(booking_id) <=15) or sum(total_amount) > 1000000 then "Platinum"
	when count(booking_id) > 15 or sum(total_amount) > 2000000 then "Diamond"
end as group_type
from datahub.grab_vn_booking_tab gvbt
group by 1,2)
select month_order,
group_type,
count(DISTINCT user_id)
from b
group by 1,2;


with a as(
Select
MOnth(completed_date) as order_month,
CASE 
	when service_name = 'Bike' then total_amount * 0.20
	when service_name = 'Car' then total_amount * 0.25
	when service_name = 'Express' then total_amount * 0.1
	when service_name = 'Food' then total_amount * 0.1
	when service_name = 'Market' then total_amount * 0.0
end as commission 
from datahub.grab_vn_booking_tab gvbt)
select order_month,
round(sum(commission),2) as revenue
from a
group by 1;