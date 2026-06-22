# Data Dictionary

## Dataset Overview

**File:** `uk_supermarket_supply_2000.csv`  
**Original records:** 2,000  
**Original columns:** 11  
**Source date format:** DD/MM/YYYY  

This dataset contains daily inventory, sales and supplier-delivery records for supermarket stores across different UK regions. It was used to analyse stock availability, supplier performance and inventory risk.

## Source Columns

| Column | Data Type | Description |
|---|---|---|
| `Date` | Date | Date of the inventory record. The original CSV stores dates in DD/MM/YYYY format. |
| `Region` | Text | UK region in which the store is located. |
| `Store_ID` | Text | Identifier assigned to each supermarket store. |
| `Category` | Text | Product category, such as Bakery, Dairy, Fresh Produce, Frozen, Meat or Festive. |
| `Opening_Stock` | Whole number | Stock available at the beginning of the day. |
| `Deliveries` | Whole number | Additional stock received during the day. |
| `Daily_Sales` | Whole number | Units sold during the day. |
| `Closing_Stock` | Whole number | Stock remaining at the end of the day. |
| `Lead_Time_Days` | Whole number | Number of days taken for the supplier delivery. |
| `Supplier_Status` | Text | Delivery outcome recorded as On-Time, Delayed or Cancelled. |
| `Stock_Status` | Text | Stock condition provided in the original source file. |

## Inventory Validation

The available stock for each record is calculated as:

**Available Stock = Opening Stock + Deliveries**

A record is treated as invalid when:

**Daily Sales > Opening Stock + Deliveries**

Using this rule, 44 records were separated from the main dataset and written to the quarantine output. The remaining 1,956 records were retained for analysis.

## Corrected Stock Status

The original stock-status values were checked against the closing-stock quantity.

| Closing Stock | Corrected Stock Status |
|---:|---|
| Below 50 | Critical |
| 50 to 149 | Warning |
| 150 or above | Healthy |

The original value was retained in `Original_Stock_Status` so that the source and corrected values could be compared.

## Fields Added During Processing

| Column | Data Type | Description |
|---|---|---|
| `Original_Stock_Status` | Text | Preserves the stock-status value supplied in the original CSV before correction. |
| `Supplier_Reliability_Score` | Whole number | Supplier score calculated from delivery status and lead time. Higher values indicate better delivery reliability. |
| `Category_Volatility_Index` | Decimal number | Measures variation in daily sales within each product category. |

## Supplier Reliability Score

Each supplier record starts with a score of 100.

| Supplier Status | Score Adjustment |
|---|---:|
| On-Time | +10 |
| Delayed | -30 |
| Cancelled | -60 |

A further penalty of two points is applied for every lead-time day.

**Final Score = Status-Adjusted Score - (2 × Lead Time Days)**

The final score cannot be lower than zero.

## Category Volatility Index

The volatility index is calculated separately for each product category.

**Category Volatility Index = (Standard Deviation of Daily Sales / Average Daily Sales) × 100**

A higher value indicates that sales within the category vary more widely from one record to another.

## Processed Dataset Summary

| Check | Result |
|---|---:|
| Original records | 2,000 |
| Invalid records quarantined | 44 |
| Valid records retained | 1,956 |
| Stock-status labels corrected | 64 |
| Final number of columns | 14 |

The cleaned and enriched dataset was saved as the Fabric Lakehouse Delta table `dbo.uk_supermarket_supply`.
