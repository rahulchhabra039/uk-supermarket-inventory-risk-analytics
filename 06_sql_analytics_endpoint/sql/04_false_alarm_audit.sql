-- False Alarm Audit
-- Checks records originally labelled as Critical and calculates
-- how often the actual closing stock was 150 units or higher.

SELECT
    Store_ID,

    SUM(
        CASE
            WHEN Closing_Stock >= 150 THEN 1
            ELSE 0
        END
    ) * 100.0 / COUNT(*) AS False_Alarm_Percentage

FROM dbo.uk_supermarket_supply

WHERE Original_Stock_Status = 'Critical'

GROUP BY Store_ID

HAVING
    SUM(
        CASE
            WHEN Closing_Stock >= 150 THEN 1
            ELSE 0
        END
    ) > 0

ORDER BY False_Alarm_Percentage DESC;