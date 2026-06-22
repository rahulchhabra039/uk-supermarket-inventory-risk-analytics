-- Supplier Impact Stress Test
-- Compares average closing stock for on-time and delayed deliveries
-- and returns regions where the difference is greater than 20 units.

SELECT
    Region,

    AVG(
        CASE
            WHEN Supplier_Status = 'On-Time'
            THEN Closing_Stock
        END
    ) AS Avg_Stock_On_Time,

    AVG(
        CASE
            WHEN Supplier_Status = 'Delayed'
            THEN Closing_Stock
        END
    ) AS Avg_Stock_Delayed

FROM dbo.uk_supermarket_supply

GROUP BY Region

HAVING
    AVG(
        CASE
            WHEN Supplier_Status = 'On-Time'
            THEN Closing_Stock
        END
    )
    -
    AVG(
        CASE
            WHEN Supplier_Status = 'Delayed'
            THEN Closing_Stock
        END
    ) > 20

ORDER BY Region;