# Final Lakehouse Table Schema

The cleaned supermarket dataset was saved in the Fabric Lakehouse as the Delta table:

`dbo.uk_supermarket_supply`

The table contains 1,956 validated records and 14 columns. It was used for the SQL analysis and the Power BI report.

## Table structure

| Column                       | Data Type      | Description                                                    |
| ---------------------------- | -------------- | -------------------------------------------------------------- |
| `Date`                       | Date           | Date of the inventory record.                                  |
| `Region`                     | Text           | UK region in which the store operates.                         |
| `Store_ID`                   | Text           | Identifier assigned to the supermarket store.                  |
| `Category`                   | Text           | Product category being tracked.                                |
| `Opening_Stock`              | Whole number   | Stock available at the start of the day.                       |
| `Deliveries`                 | Whole number   | Stock delivered during the day.                                |
| `Daily_Sales`                | Whole number   | Units sold during the day.                                     |
| `Closing_Stock`              | Whole number   | Stock remaining at the end of the day.                         |
| `Lead_Time_Days`             | Whole number   | Number of days taken for the supplier delivery.                |
| `Supplier_Status`            | Text           | Delivery result recorded as On-Time, Delayed or Cancelled.     |
| `Stock_Status`               | Text           | Corrected stock condition based on the closing-stock quantity. |
| `Original_Stock_Status`      | Text           | Original stock-status value retained from the source file.     |
| `Supplier_Reliability_Score` | Whole number   | Supplier score based on delivery status and lead time.         |
| `Category_Volatility_Index`  | Decimal number | Measure of variation in daily sales for each product category. |

## Stock-status rules

The final `Stock_Status` field was recalculated using the closing-stock quantity:

| Closing Stock | Stock Status |
| ------------: | ------------ |
|      Below 50 | Critical     |
|     50 to 149 | Warning      |
|  150 or above | Healthy      |

## Table output

The final table was written in Delta format and made available through the Fabric Lakehouse SQL analytics endpoint.

This allowed the same cleaned dataset to be used for both SQL queries and the Power BI semantic model.
