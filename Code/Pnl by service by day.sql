with daily_bonus as(
select driver_id ,
completed_date as order_day,
CASE 
	when count(booking_id) * 10 < 50 then 0
	when count(booking_id) * 10 between 50 and 100 then 80000
	when count(booking_id) * 10 between 101 and 150 then 120000
	when count(booking_id) * 10 between 151 and 200 then 150000
	when count(booking_id) * 10 between 201 and 250 then 200000
	when count(booking_id) * 10 > 250 then 280000
end as daily_bonus,
count(booking_id) as total_order,
count(case when service_name='Bike' then booking_id end) as total_bike_orders,
count(case when service_name='Car' then booking_id end) as total_car_orders,
count(case when service_name='Express' then booking_id end) as total_express_orders,
count(case when service_name='Food' then booking_id end) as total_food_orders,
count(case when service_name='Market' then booking_id end) as total_market_orders
from datahub.grab_vn_booking_tab gvbt 
group by 1,2)
,service_bonus as(
SELECT 
driver_id,
order_day,
daily_bonus,
total_order,
(daily_bonus/total_order*total_bike_orders) as total_daily_bonus_bike,
(daily_bonus/total_order*total_express_orders) as total_daily_bonus_express,
(daily_bonus/total_order*total_car_orders) as total_daily_bonus_car,
(daily_bonus/total_order*total_food_orders) as total_daily_bonus_food,
(daily_bonus/total_order*total_market_orders) as total_daily_bonus_market
from daily_bonus)
-- where daily_bonus >0)
,cost_services as(
select order_day,
sum(total_daily_bonus_bike) as cost_bike,
sum(total_daily_bonus_express) as cost_express,
sum(total_daily_bonus_car) as cost_car,
sum(total_daily_bonus_food) as cost_food,
sum(total_daily_bonus_market) as cost_market
from service_bonus 
group by 1)
,revenue_service as(
select
completed_date as order_day,
sum(case when service_name = 'Bike' then total_amount * 0.20 end) as revenue_bike,
sum(case when service_name = 'Car' then total_amount * 0.25 end) as revenue_car,
sum(case when service_name = 'Express' then total_amount * 0.1 end) as revenue_express,
sum(case when service_name = 'Food' then total_amount * 0.1 end) as revenue_food,
sum(case when service_name = 'Market' then total_amount * 0.0 end) as revenue_market
from datahub.grab_vn_booking_tab
group by 1)
select a.order_day,
(b.revenue_bike - a.cost_bike) as PnL_bike,
(b.revenue_car - a.cost_car) as PnL_car,
(b.revenue_food - a.cost_food) as PnL_food,
(b.revenue_express - a.cost_express) as PnL_express,
(b.revenue_market - a.cost_market) as PnL_market
from cost_services a left join revenue_service b 
on a.order_day = b.order_day;
