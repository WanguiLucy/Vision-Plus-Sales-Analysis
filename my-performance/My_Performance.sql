CREATE VIEW view_all_months AS
SELECT '2025-06' AS month UNION ALL
SELECT '2025-07' UNION ALL
SELECT '2025-08' UNION ALL
SELECT '2025-09' UNION ALL
SELECT '2025-10' UNION ALL
SELECT '2025-11' UNION ALL
SELECT '2025-12';



--What was my monthly revenue and units-sold trajectory across six months?
select
	STRFTIME('%Y-%m' , sell_date) as month,
	sum(vp.number_of_sales) as units_sold,
	sum(vp.total_sales_value) as total_revenue
from
	vision_plus_2025 vp
where
	staff like 'Lucy%'
group by
	STRFTIME('%Y-%m' ,sell_date)
;
 /* The revenue trajectory is positive across the months. 
  * The 74 was the highest number of sold units (74) on December followed by 18 in July and August.
  * The least number of units sold was 5 in September and the main reason for this was the delay in products delivery. */

--Which of my five assigned stores generated the most revenue?
select
	vp.store ,
	sum(vp.total_sales_value) as total_revenue
from
	vision_plus_2025 vp
where
	staff like 'Lucy%'
group by
	store
order by
	sum(vp.total_sales_value) desc
;

/* Across the 6 months, Nakuru Midtown had the highest revenue followed closely with Nakuru Downtown.
The main reason why the rank best is their location. And the kind of customers they accomodate.
They are both located at the center of the city and the middle class customers frequents the store.
Main customers for vision plus are middle class due to affordable price. */

--Which product categories drove or dragged my performance?
select
	vp.product_description ,
	sum(vp.number_of_sales) as units_sold,
	sum(vp.total_sales_value) as total_revenue
from
	vision_plus_2025 vp
where
	staff like 'Lucy%'
group by
	vp.product_description
order by
	sum(vp.total_sales_value) desc ;

/* The sale was mostly drove by the 32" Smart TV, mainly because of it's price and availability. 
 * The units sold are 59 followed by 43" Smart TV with 17 units sold.
 * What dragged my sale was 75" SMART TV and 20L Microwave. 
 * 75" since it was one of dead stocks, had been in the store for more than 2 years.
 * 20L Microwave ranks last since it was fresh in the market. Was introduced in December. 
 */

--What were my top 5 best-selling products per month?
with monthly_product_ranking as (
select
	STRFTIME('%Y-%m' , sell_date) as month,
	vp.product_description ,
	sum(vp.total_sales_value) as total_revenue,
	row_number() over(partition by STRFTIME('%Y-%m' , sell_date) order by
	sum(vp.total_sales_value) desc) as product_rank
from
	vision_plus_2025 vp
where
	staff like 'Lucy%'
group by
	STRFTIME('%Y-%m' , sell_date),
	product_description)
select
	*
from
	monthly_product_ranking
where
	product_rank <= 5
 ;
/* The most consistent product across the 6 months is 43" Smart TV.
 * As much as 32" Smart TV drove my sales, it was not available until November.
 * There were a couple of products that were introduced in the market and the ranked top 5 in both November and December.
 * Soundbar VP2121SB, 40 X 50 Cooker and 150L Chest Freezer.
 */

--Where did I rank among 15 reps each month?
with team_monthly_ranking as (
select
	STRFTIME('%Y-%m' , sell_date) as month,
	staff,
	sum(vp.total_sales_value) as total_revenue,
	rank() over(partition by STRFTIME('%Y-%m' , sell_date) order by sum(vp.total_sales_value) desc) as staff_rank
from
	vision_plus_2025 vp
group by
	STRFTIME('%Y-%m' , sell_date),
	staff)
select
	month, total_revenue , staff_rank 
from
	team_monthly_ranking
where
	staff like 'Lucy%' ;

/* I was 3rd in 2 months, both June and July. 
 * #5 in August and #6 in September.
 * I ranked #14 in November.
 * December was my best performing month but I ranked #9.
 * */ 

--How did my revenue change month-over-month?
with monthly_revenue as (
select
	STRFTIME('%Y-%m' , sell_date) as month,
	vp.staff ,
		sum(vp.total_sales_value) as total_revenue
from
	vision_plus_2025 vp
where
	staff like 'Lucy%'
group by
	STRFTIME('%Y-%m' , sell_date),
	staff
)
select
	vam.month,
	coalesce(mr.total_revenue, 0) as total_revenue,
	round((coalesce(total_revenue, 0) - lag(coalesce(total_revenue, 0)) over(order by vam.month)) * 100 / lag(coalesce(total_revenue, 0)) over(order by vam.month), 2) as mom_growth_pct
from
	monthly_revenue mr
right join view_all_months vam on
	mr.month = vam.month
 ;

/* The notable month over month growth is from November to December with +240%.
 * The negative growth was from August to September with a decrease of -69.71%.
 * The September shift was due to season change. The customers priority changed from buying electronics to school fees.
 * The was a positive change of 50.27% from june to july.
 *  */ 

--What was my running cumulative revenue across the period?
select
	STRFTIME('%Y-%m' , sell_date) as month,
		sum(vp.total_sales_value) as total_revenue,
	sum(sum(vp.total_sales_value)) over(order by STRFTIME('%Y-%m' , sell_date)) as cumulative_revenue
from
	vision_plus_2025 vp
where
	staff like 'Lucy%'
group by
	STRFTIME('%Y-%m' , sell_date)
;
/* Got to 1M in August and way above 2M in December.
*/

--Which revenue quartile did I fall into each month relative to the team?
with quartile as (
select
	STRFTIME('%Y-%m' , sell_date) as month,
	staff,
	sum(vp.total_sales_value) as total_revenue,
	ntile(4) over(partition by STRFTIME('%Y-%m' , sell_date) order by sum(vp.total_sales_value) desc) as team_quartile
from
	vision_plus_2025 vp
group by
	STRFTIME('%Y-%m' , sell_date),
	staff)
select
	month,
	total_revenue ,
	team_quartile ,
	case
		when team_quartile = 1 then 'Top 25%'
		when team_quartile = 2 then 'Top 50%'
		when team_quartile = 3 then 'Bottom 50%'
		else 'Bottom 25%'
	end as quartile_status
from
		quartile

where
		staff like 'Lucy%' ;

/* I was in the Top 25% once in June, Top 50% thrice in July, August, and September.
 * Though December was my best performing month, I was in Bottom 50%.
 * November was my worst performing month compared to the team and that was in Bottom 25%. 
 * */

--How many zero-sales days did I record vs. the full team?
with daily_sales as (
select
	vp.sell_date,
	staff,
	sum(vp.number_of_sales) as units_sold,
	sum(vp.total_sales_value) as total_revenue
from
	vision_plus_2025 vp
group by
	vp.sell_date,
	staff )
select
	staff,
	count(sell_date) as number_of_days
from
	daily_sales
where
	total_revenue = 0
group by
	staff
order by
	number_of_days desc
;

/* I had the second highest number (72) of days with 0 sales.
Also had the second highest number of days (80) with sales. 
*/

--Were there months I performed above or below the team average?
with monthly_revenue as (
select
	STRFTIME('%Y-%m' , sell_date) as month,
	staff,
	sum(vp.total_sales_value) as total_revenue
from
	vision_plus_2025 vp
group by
	STRFTIME('%Y-%m' , sell_date),
	staff),
average as (
select
	month,
	round(avg(total_revenue), 2) as team_average
from
	monthly_revenue
group by
	month),
my_perf as (
select
	STRFTIME('%Y-%m' , sell_date) as month,
	sum(total_sales_value) as my_revenue
from
	vision_plus_2025 vp
where
		staff like 'Lucy%'
group by
	STRFTIME('%Y-%m' , sell_date) )
select
	mp.month,
	mp.my_revenue,
	a.team_average,
	case
		when mp.my_revenue > a.team_average then 'Above Average'
		when mp.my_revenue < a.team_average then 'Below Average'
		else 'Stable'
	end as average_comparison
from
	my_perf mp
join average a on
	mp.month = a.month ;

/* My performance was 3 times consistently above average and also consistently 3 times below average.
 * */

--Which products sat as dead stock in my stores for 3+ months?
with monthly_stock as (
  select
    STRFTIME('%Y-%m' , sell_date) as month,
    staff,
    store,
    product_description,
    first_value(opening_stock) over (
      partition by STRFTIME('%Y-%m' , sell_date), product_description, store, staff
      order by sell_date asc
    ) as opening_stock,
    sum(number_of_sales) over (
      partition by STRFTIME('%Y-%m' , sell_date), product_description, store, staff
    ) as total_sold,
    row_number() over (
      partition by STRFTIME('%Y-%m' , sell_date), product_description, store, staff
      order by sell_date asc
    ) as rn
  from vision_plus_2025
),
zero_months as (
  select
    staff,
    store,
    product_description,
    month,
    total_sold
  from monthly_stock
  where rn = 1 and opening_stock > 0
),
with_groups as (
  select
    *,
    row_number() over (partition by staff, store, product_description order by month) -
    row_number() over (partition by staff, store, product_description, (case when total_sold > 0 then 1 else 0 end) order by month) as gap_group
  from zero_months
),
consecutive_streaks as (
  select
    staff,
    store,
    product_description,
    gap_group,
    count(*) as consecutive_zero_months
  from with_groups
  where total_sold = 0
  group by staff, store, product_description, gap_group
)
select
  staff,
  store,
  product_description,
  max(consecutive_zero_months) as months_without_sales
from consecutive_streaks
where consecutive_zero_months >= 3 and staff like 'lucy%'
group by staff, store, product_description
order by months_without_sales desc;

/* The following products stayed in the store for 6 months without sales: 
 * Naivasha Kubwa; Soundbar Vp2110sb, vp2120sb, Nakuru Midtown; Soundbar vp2110sb, Nakuru Supercenter; 75" and Nakuru Westside; 75" .
 * 75" Smart TVs had stayed in both store for more than 2 years before i started to merchandize.
 * */
