select b.order_month,
count(b.user_id) as total_user,
count(b_1.user_id) as total_reten_user,
count(b_1.user_id)/count(b.user_id) *100 as retention_rate
from (select DISTINCT 
user_id,
MONTH (completed_date) as order_month
from datahub.grab_vn_booking_tab gvbt
where MONTH (completed_date) >5
) b
left join (select DISTINCT 
user_id,
MONTH (completed_date) as order_month
from datahub.grab_vn_booking_tab gvbt
where MONTH (completed_date) > 5 
) b_1 
on b.user_id = b_1.user_id
and b.order_month = b_1.order_month - 1
GROUP BY  1

