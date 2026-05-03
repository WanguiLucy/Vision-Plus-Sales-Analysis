# 📊 My Performance — Vision Plus Electronics

---

> *Folder 1 of 3 · Vision Plus Repository*
> *SQL Dialect: SQLite · Tool: DBeaver · Period: June – December 2025*

---

## Background

Between June and December 2025, I worked as a **Merchandiser and Sales Data Analyst** at **Vision Plus Electronics** — a Kenyan consumer electronics brand selling TVs, cookers, microwaves, and audio equipment across retail stores nationwide in Kenya.

Vision Plus operates retail stores across multiple towns in Kenya. I was assigned to **five stores spanning Nakuru and Naivasha**, where I tracked daily sales transactions, recorded stock movements, and monitored my performance relative to a team of 15 sales representatives. This folder uses that real transactional data to validate and substantiate the analytical work performed during that period.

---

## Dataset

| Attribute | Detail |
|---|---|
| Table | `vision_plus_2025` |
| Period | June 2025 – December 2025 (October data unavailable) |
| Stores | Nakuru Midtown, Nakuru Downtown, Nakuru Westside, Nakuru Supercenter, Naivasha Kubwa |
| Team Size | 15 sales representatives |
| Products | 32" Smart TV, 43" Smart TV, 75" Smart TV, Soundbars, Cooker, Chest Freezer, Microwave |
| Key Columns | `sell_date`, `staff`, `store`, `product_description`, `number_of_sales`, `total_sales_value`, `opening_stock`, `closing_stock`, `received_stock` |

---

## Business Questions Answered

1. What was my monthly revenue and units-sold trajectory across six months?
2. Which of my five assigned stores generated the most revenue?
3. Which product categories drove or dragged my performance?
4. What were my top 5 best-selling products per month?
5. Where did I rank among 15 reps each month?
6. How did my revenue change month-over-month?
7. What was my running cumulative revenue across the period?
8. Which revenue quartile did I fall into each month relative to the team?
9. How many zero-sales days did I record versus the full team?
10. Were there months I performed above or below the team average?
11. Which products sat as dead stock in my stores for 3+ consecutive months?

---

## SQL Techniques Demonstrated

| Technique | Applied In |
|---|---|
| `GROUP BY` with `SUM` aggregation | Monthly revenue, store revenue, product revenue |
| `ROW_NUMBER() OVER (PARTITION BY month)` | Top 5 products per month |
| `RANK() OVER (PARTITION BY month)` | Monthly rep ranking across team |
| `LAG()` with MoM % change | Month-over-month revenue growth |
| `SUM() OVER (ORDER BY month)` | Running cumulative revenue |
| `NTILE(4) OVER (PARTITION BY month)` | Quartile classification relative to team |
| `FIRST_VALUE()` | Opening stock per month per product |
| Multi-CTE chaining | Team average vs. personal revenue comparison |
| `RIGHT JOIN` with date spine | Preserving October gap in MoM calculation |
| `COALESCE` | Handling NULL revenue for missing months |
| Gaps-and-islands (`ROW_NUMBER` differencing) | Consecutive dead stock month detection |
| `CASE WHEN` | Quartile labels, above/below average flags |

---

## Key Findings

- **December was my highest revenue month** — driven by a promotion on the 32" Smart TV (price dropped from KES 21,000 to KES 10,000), generating a **+240% MoM revenue increase**
- **Nakuru Midtown and Downtown** were my top-performing stores due to their CBD location and middle-class customer base, while **Naivasha Kubwa** underperformed as I could only visit once a week
- **September was my weakest month** — 5 units sold and a **-69.71% MoM decline** — attributed to back-to-school season shifting customer spending priorities away from electronics
- **I ranked in the Top 25% of the team in June** and Top 50% in July, August, and September, but dropped to Bottom 25% in November before recovering in December
- **72 days of zero sales** recorded across the period — second highest in the team — though I also had the second highest number of active selling days (80), reflecting the feast-or-famine nature of high-ticket electronics merchandising
- **Dead stock identified**: 75" Smart TV at Nakuru Supercenter and Westside recorded 6 consecutive months without a single sale — the unit had been in store for over 2 years prior to the analysis period

---

## Data Quality Notes

- October data was unavailable from source records; a `view_all_months` date spine was created to preserve timeline continuity in LAG and cumulative window calculations
- Staff filtering uses `LIKE 'Lucy%'` to reflect the actual name format in the source table
- The dead stock detection query uses a **gaps-and-islands approach** via ROW_NUMBER differencing — this corrects an earlier COUNT-based approach that incremented regardless of whether consecutive months were truly unbroken streaks
- No data has been fabricated or altered; all figures reflect actual recorded transactions

---

*Lucy Wangui · BSc Statistics, Maseno University · Nairobi, Kenya*
