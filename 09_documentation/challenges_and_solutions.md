# Challenges and Solutions

This project included a few practical issues that had to be solved before the final dataset and dashboard could be completed.

## 1. Fabric Spark capacity error

When I first tried to run the PySpark notebook, the session failed with a capacity-related error. The notebook showed an HTTP 430 `TooManyRequestsForCapacity` message and the compute session disconnected.

I checked the Fabric Monitor page to make sure there were no active or queued jobs using the available capacity. I then created a smaller custom Spark pool with one small node and set it as the workspace default.

After changing the notebook to use the new pool, the Spark session started successfully and the notebook could run normally.

## 2. Invalid inventory records

The source data contained rows where daily sales were greater than the total stock available from opening stock and deliveries.

The validation rule used was:

`Daily_Sales > Opening_Stock + Deliveries`

This identified 44 invalid records.

Instead of deleting them, I wrote them to a separate quarantine CSV. This kept the rejected records available for review while preventing them from affecting the final analysis.

## 3. Incorrect stock-status labels

Some rows had a stock status that did not match the actual closing-stock quantity.

I kept the original value in a new column called `Original_Stock_Status` and recalculated the final status using the following rules:

- below 50: Critical
- 50 to 149: Warning
- 150 or above: Healthy

This process corrected 64 stock-status labels and also made it possible to run a later SQL audit comparing the original and corrected values.

## 4. Keeping the ingestion layer unchanged

The Fabric pipeline was used only to move the CSV from Azure Blob Storage into the Lakehouse Bronze folder.

I used Binary transfer so that the source file was copied without changing its structure. All cleaning and transformation work was left to the PySpark notebook.

This kept the raw file available as an unchanged reference copy.

## 5. Power BI model design

The cleaned Lakehouse table was suitable for analysis, but using it directly as one large flat table would have made the report harder to manage.

I created a simple star schema in Power BI with:

- `Fact_Inventory`
- `Dim_Date`
- `Dim_Store`

The lead-time reduction table was kept disconnected because it was only used as a what-if parameter.

## 6. Dynamic report logic

The report needed to do more than display static totals.

I added DAX measures for:

- smart alerts based on both low stock and delayed delivery
- dynamic written insight by region
- current and estimated lost sales
- one-day, two-day and three-day lead-time scenarios
- potential recovery from shorter supplier lead times

This made the report responsive to slicers and allowed the third page to test different business scenarios.
