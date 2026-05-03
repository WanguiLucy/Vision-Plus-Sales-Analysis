# Data — Vision Plus Electronics

---

> *Sample dataset for the Vision Plus Sales Analysis repository*
> *Full dataset: 15 reps · 6 months · 5 stores · SQLite via DBeaver*

---

## About the Dataset

The `vision_plus_2025` table is a real transactional sales dataset recorded daily during a Merchandiser role at Vision Plus Electronics between June and December 2025.

The data captures stock movements and sales across five assigned stores in Nakuru and Naivasha, covering multiple product categories including Smart TVs, soundbars, cookers, chest freezers, and microwaves.

---

## What's in This Folder

| File | Description |
|---|---|
| `vision_plus_december_sample.csv` | 401 rows of real December 2025 transaction data for one merchandiser across five stores. Provided to illustrate the dataset schema and structure. |

### Why Only a Sample?

The full dataset contains records for 15 sales representatives across six months. Sharing the complete dataset would expose colleagues' personal performance data without their consent. Only the author's own December data is shared here — the highest-revenue month in the analysis period.

---

## Schema

| Column | Type | Description |
|---|---|---|
| `sell_date` | DATE | Date the record was captured (daily) |
| `store` | TEXT | Store name where the product was stocked |
| `product_description` | TEXT | Product name as recorded in the system |
| `opening_stock` | INTEGER | Units available at the start of the day |
| `received_stock` | INTEGER | Units received from warehouse that day |
| `total_stock` | INTEGER | Opening + received stock |
| `number_of_sales` | INTEGER | Units sold that day |
| `closing_stock` | INTEGER | Units remaining at end of day |
| `rrp` | INTEGER | Recommended retail price in KES |
| `total_sales_value` | INTEGER | Revenue generated (number_of_sales × rrp) |
| `staff` | TEXT | Merchandiser name |

---

## Key Data Notes

- **October data is unavailable** from source records — this gap is handled in SQL using a `view_all_months` date spine to preserve timeline continuity in LAG and cumulative calculations
- **Store names** follow the naming convention used in the source system — minor inconsistencies across months are documented in the relevant SQL scripts
- **RRP** reflects the price at the time of recording — promotional prices (such as the December 32" Smart TV discount) are captured in the actual RRP column, not as a separate field
- All SQL in this repository was run against the full `vision_plus_2025` table in DBeaver using the SQLite dialect

---

## Tools Used

| Tool | Purpose |
|---|---|
| DBeaver | SQL execution environment |
| SQLite | Query dialect |
| Excel | Original data entry format (daily tracking sheets) |
| Python / openpyxl | Used to export this sample CSV from the source Excel file |

---

*Lucy Wangui · BSc Statistics, Maseno University · Nairobi, Kenya*
