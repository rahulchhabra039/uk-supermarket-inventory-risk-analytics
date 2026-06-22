# DAX Measures

This file records the main DAX measures used in the Power BI report for the UK supermarket inventory project. The measures cover the report KPIs, stock alerts, dynamic narrative and lead-time what-if analysis.

## Core inventory measures

### Average Closing Stock

Calculates the average closing stock in the current filter context.

```DAX
Average Closing Stock =
AVERAGE(Fact_Inventory[Closing_Stock])
```

### Total Sales

```DAX
Total Sales =
SUM(Fact_Inventory[Daily_Sales])
```

### Total Deliveries

```DAX
Total Deliveries =
SUM(Fact_Inventory[Deliveries])
```

### Total Records

```DAX
Total Records =
COUNTROWS(Fact_Inventory)
```

### Critical Stock Records

Counts records where the corrected stock status is Critical.

```DAX
Critical Stock Records =
CALCULATE(
    COUNTROWS(Fact_Inventory),
    Fact_Inventory[Stock_Status] = "Critical"
)
```

## Smart alert measures

The smart alert is stricter than the general Critical status. A record is included only when closing stock is below 50 and the supplier status is Delayed.

### Smart Alert Records

```DAX
Smart Alert Records =
CALCULATE(
    COUNTROWS(Fact_Inventory),
    Fact_Inventory[Closing_Stock] < 50,
    Fact_Inventory[Supplier_Status] = "Delayed"
)
```

### Smart Alert Percentage

```DAX
Smart Alert Percentage =
DIVIDE(
    [Smart Alert Records],
    COUNTROWS(Fact_Inventory),
    0
)
```

### Smart Alert KPI Colour

```DAX
Smart Alert KPI Colour =
IF(
    [Smart Alert Records] > 0,
    "#EF4444",
    "#374151"
)
```

## Dynamic narrative

The Dynamic Insight measure identifies the selected region, or the region with the largest stock reduction when no single region is selected. It compares average closing stock for On-Time and Delayed deliveries and reports the most frequent supplier disruption.

```DAX
Dynamic Insight =
VAR RegionAnalysis =
    ADDCOLUMNS(
        ALLSELECTED(Dim_Store[Region]),
        "ReductionPercentage",
            VAR OnTimeStock =
                CALCULATE(
                    AVERAGE(Fact_Inventory[Closing_Stock]),
                    Fact_Inventory[Supplier_Status] = "On-Time"
                )
            VAR DelayedStock =
                CALCULATE(
                    AVERAGE(Fact_Inventory[Closing_Stock]),
                    Fact_Inventory[Supplier_Status] = "Delayed"
                )
            RETURN
                MAX(
                    0,
                    DIVIDE(
                        OnTimeStock - DelayedStock,
                        OnTimeStock,
                        0
                    )
                )
    )

VAR FocusRegion =
    IF(
        HASONEVALUE(Dim_Store[Region]),
        SELECTEDVALUE(Dim_Store[Region]),
        MAXX(
            TOPN(
                1,
                RegionAnalysis,
                [ReductionPercentage], DESC,
                Dim_Store[Region], ASC
            ),
            Dim_Store[Region]
        )
    )

VAR AverageOnTimeStock =
    CALCULATE(
        AVERAGE(Fact_Inventory[Closing_Stock]),
        TREATAS({FocusRegion}, Dim_Store[Region]),
        Fact_Inventory[Supplier_Status] = "On-Time"
    )

VAR AverageDelayedStock =
    CALCULATE(
        AVERAGE(Fact_Inventory[Closing_Stock]),
        TREATAS({FocusRegion}, Dim_Store[Region]),
        Fact_Inventory[Supplier_Status] = "Delayed"
    )

VAR StockReduction =
    MAX(
        0,
        DIVIDE(
            AverageOnTimeStock - AverageDelayedStock,
            AverageOnTimeStock,
            0
        )
    )

VAR DisruptionTable =
    ADDCOLUMNS(
        FILTER(
            ALL(Fact_Inventory[Supplier_Status]),
            Fact_Inventory[Supplier_Status] <> "On-Time"
        ),
        "DisruptionCount",
            CALCULATE(
                COUNTROWS(Fact_Inventory),
                TREATAS({FocusRegion}, Dim_Store[Region])
            )
    )

VAR MostFrequentDisruption =
    MAXX(
        TOPN(
            1,
            DisruptionTable,
            [DisruptionCount], DESC,
            Fact_Inventory[Supplier_Status], ASC
        ),
        Fact_Inventory[Supplier_Status]
    )

RETURN
    FocusRegion
        & " has experienced a "
        & FORMAT(StockReduction, "0%")
        & " stock reduction, while "
        & MostFrequentDisruption
        & " is the most frequent supplier disruption."
```

## Lead-time what-if table

This calculated table creates the 1-to-3-day lead-time reduction parameter used on the third report page.

```DAX
Lead Time Reduction =
GENERATESERIES(1, 3, 1)
```

## Lost-sales measures

### Current Lost Sales

```DAX
Current Lost Sales =
SUMX(
    Fact_Inventory,
    VAR DailyShortage =
        MAX(
            Fact_Inventory[Daily_Sales]
                - Fact_Inventory[Closing_Stock],
            0
        )
    RETURN
        DailyShortage * Fact_Inventory[Lead_Time_Days]
)
```

### Estimated Lost Sales

```DAX
Estimated Lost Sales =
VAR SelectedReduction =
    [Lead Time Reduction Value]

RETURN
    SUMX(
        Fact_Inventory,
        VAR DailyShortage =
            MAX(
                Fact_Inventory[Daily_Sales]
                    - Fact_Inventory[Closing_Stock],
                0
            )
        VAR AdjustedLeadTime =
            MAX(
                Fact_Inventory[Lead_Time_Days]
                    - SelectedReduction,
                0
            )
        RETURN
            DailyShortage * AdjustedLeadTime
    )
```

### Potential Recovery

```DAX
Potential Recovery =
[Current Lost Sales] - [Estimated Lost Sales]
```

### Lost Sales Reduction Percentage

```DAX
Lost Sales Reduction % =
DIVIDE(
    [Potential Recovery],
    [Current Lost Sales],
    0
)
```

## Fixed lead-time scenarios

### One-Day Reduction

```DAX
Lost Sales - 1 Day Reduction =
SUMX(
    Fact_Inventory,
    VAR DailyShortage =
        MAX(
            Fact_Inventory[Daily_Sales]
                - Fact_Inventory[Closing_Stock],
            0
        )
    VAR AdjustedLeadTime =
        MAX(
            Fact_Inventory[Lead_Time_Days] - 1,
            0
        )
    RETURN
        DailyShortage * AdjustedLeadTime
)
```

### Two-Day Reduction

```DAX
Lost Sales - 2 Day Reduction =
SUMX(
    Fact_Inventory,
    VAR DailyShortage =
        MAX(
            Fact_Inventory[Daily_Sales]
                - Fact_Inventory[Closing_Stock],
            0
        )
    VAR AdjustedLeadTime =
        MAX(
            Fact_Inventory[Lead_Time_Days] - 2,
            0
        )
    RETURN
        DailyShortage * AdjustedLeadTime
)
```

### Three-Day Reduction

```DAX
Lost Sales - 3 Day Reduction =
SUMX(
    Fact_Inventory,
    VAR DailyShortage =
        MAX(
            Fact_Inventory[Daily_Sales]
                - Fact_Inventory[Closing_Stock],
            0
        )
    VAR AdjustedLeadTime =
        MAX(
            Fact_Inventory[Lead_Time_Days] - 3,
            0
        )
    RETURN
        DailyShortage * AdjustedLeadTime
)
```

## Display measures

### Current Lost Sales Display

```DAX
Current Lost Sales Display =
FORMAT(
    [Current Lost Sales],
    "#,##0"
)
```

### Estimated Lost Sales Display

```DAX
Estimated Lost Sales Display =
FORMAT(
    [Estimated Lost Sales],
    "#,##0"
)
```

### Potential Recovery Display

```DAX
Potential Recovery Display =
FORMAT(
    [Potential Recovery],
    "#,##0"
)
```

### Selected Lead Time Reduction

```DAX
Selected Lead Time Reduction =
VAR SelectedDays =
    [Lead Time Reduction Value]
RETURN
    FORMAT(SelectedDays, "0")
        & IF(SelectedDays = 1, " Day", " Days")
```

### Lost Sales Reduction Summary

```DAX
Lost Sales Reduction Summary =
"▼ -"
    & FORMAT([Lost Sales Reduction %], "0.0%")
    & " vs Current ("
    & FORMAT([Current Lost Sales], "#,##0")
    & ")"
```
