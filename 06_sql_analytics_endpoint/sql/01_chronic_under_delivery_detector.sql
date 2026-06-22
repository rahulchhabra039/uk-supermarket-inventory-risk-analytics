-- Chronic Under-Delivery Detector
-- Finds store and category combinations where deliveries were below
-- 50% of sales and supplier failures occurred in more than 20% of records.

SELECT
    YEAR([Date]) AS Sales_Year,
    Store_ID,
    Category,
    SUM(Deliveries) AS Total_Deliveries,
    SUM(Daily_Sales) AS Total_Sales
FROM dbo.uk_supermarket_supply
GROUP BY
    YEAR([Date]),
    Store_ID,
    Category
HAVING
    SUM(Deliveries) < SUM(Daily_Sales) * 0.50
    AND
    SUM(
        CASE
            WHEN Supplier_Status IN ('Delayed', 'Cancelled')
            THEN 1
            ELSE 0
        END
    ) > COUNT(*) * 0.20
ORDER BY
    Sales_Year,
    Store_ID,
    Category;