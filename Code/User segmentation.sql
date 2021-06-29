with a as(
select user_id,
Month(completed_date) as month_order,
count(booking_id) as total_order,
round(sum(total_amount),2) as GMV
from datahub.grab_vn_booking_tab gvbt
group by 1,2)

select user_id,
month_order,
GMV,
CASE 
	when total_order < 5 then "Sliver"
	when total_order between 5 and 10 then "Gold"
	when (total_order > 10 and total_order <=15) or GMV > 1000000 then "Platinum"
	when total_order > 15 or GMV > 2000000 then "Diamond"
end as group_type
from a
order by 2;