-- User Analysis
-- + Active user: A1, A7 and A30 (Active user - has at least 1 order/booking -  last 7 days, last 30 days)
-- + Retention rate (is the percentage of customers a business retains over a given period of time) 
-- + User churned rate (A churned user is a user who has stopped using an app. There are two kinds of actions a user takes related to churn: either lapsing in use (which means no more sessions being recorded) or uninstalling the app from the device itself. But essentially, churn rate is the number of users that leave your app in a given period of time.)

select *from datahub.grab_vn_booking_tab gvbt limit 2;

--#having at least 1 order/booking per day
select completed_date as date_order,
count(DISTINCT(user_id)) as active_user_per_day,
count(booking_id) as total_order_per_day
from datahub.grab_vn_booking_tab gvbt
group by 1
limit 100;
--having at least 1 order/booking last 7 days = 1 order/booking per week
select 
week(completed_date) as week_order,
count(DISTINCT(user_id)) as active_user_per_week,
count(booking_id) as total_order_per_week
from datahub.grab_vn_booking_tab gvbt
group by 1
limit 100;
--having at least 1 order/booking last 30 days = 1 order/booking per month
select 
MONTH (completed_date) as month_order,
count(DISTINCT(user_id)) as active_user_per_month,
count(booking_id) as total_order_per_month
from datahub.grab_vn_booking_tab gvbt
group by 1
limit 100;
--active_users are divided by service_name
select
service_code,
service_name,
MONTH (completed_date) as month_order,
count(DISTINCT(user_id)) as active_user_per_month,
count(booking_id) as total_order_per_month
from datahub.grab_vn_booking_tab gvbt
group by 1,2,3
limit 100;


