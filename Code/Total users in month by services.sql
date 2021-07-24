select 
Month(completed_date) as order_month,
service_name,
count(distinct user_id) 
from datahub.grab_vn_booking_tab gvbt 
group by 1,2;