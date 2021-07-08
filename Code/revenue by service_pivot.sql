select
completed_date as order_day,
sum(case when service_name = 'Bike' then total_amount * 0.20 end) as revenue_bike,
sum(case when service_name = 'Car' then total_amount * 0.25 end) as revenue_car,
sum(case when service_name = 'Express' then total_amount * 0.1 end) as revenue_express,
sum(case when service_name = 'Food' then total_amount * 0.1 end) as revenue_food,
sum(case when service_name = 'Market' then total_amount * 0.0 end) as revnue_market
from datahub.grab_vn_booking_tab
group by 1;

with temp4 as(
select
completed_date as order_day,
service_name,
CASE 
	when service_name = 'Bike' then sum(total_amount * 0.20)
	when service_name = 'Car' then sum(total_amount * 0.25)
	when service_name = 'Express' then sum(total_amount * 0.1)
	when service_name = 'Food' then sum(total_amount * 0.1)
	when service_name = 'Market' then sum(total_amount * 0.0)
end as commission_money
from datahub.grab_vn_booking_tab
group by 1,2)
select 
order_day,
service_name,
sum(commission_money) as revenue
from temp4
group by 1,2;