select * from datahub.grab_vn_booking_tab gvbt limit 10;

-- Booking Analysis
-- Number of orders grouped by services.
-- Number of orders grouped by date/week/month and hour.


select service_code,service_name,
count(booking_id) as total_orders
from datahub.grab_vn_booking_tab gvbt 
group by 1,2
limit 10;

SELECT completed_date as date_order,
count(booking_id) as total_orders
from datahub.grab_vn_booking_tab gvbt
group by 1
limit 10;

select WEEK(completed_date) as week_order,
count(booking_id) as total_orders
from datahub.grab_vn_booking_tab gvbt 
group by 1
limit 10; 

select MONTH(completed_date) as month_order,
count(booking_id) as total_orders
from datahub.grab_vn_booking_tab gvbt 
group by 1
LIMIT 10;

select HOUR(complete_time) as hour_order,
count(booking_id)as total_orders
from datahub.grab_vn_booking_tab gvbt
group by 1
limit 2;

select 
service_name,
completed_date,
WEEK(completed_date) order_week,
MONTH(completed_date) order_month,
count(booking_id) as total_orders,
count(DISTINCT user_id) as total_user
from datahub.grab_vn_booking_tab gvbt 
group by 1, 2, 3, 4
ORDER by 2, 3 DESC
limit 10;