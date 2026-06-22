\# Fabric Lakehouse Setup



I used a Microsoft Fabric Lakehouse to store the supermarket data at different stages of the project.



The Lakehouse created for the project was:



`LH\_UK\_Supermarket\_Inventory`



\## Bronze layer



The original CSV file was copied from Azure Blob Storage into the Bronze folder using the Fabric pipeline `PL\_Ingest\_AzureBlob\_to\_Bronze`.



The file was stored at:



`Files/bronze/uk\_supermarket\_supply\_2000.csv`



The Bronze copy was kept in its original form so that the raw source data remained available before any cleaning or validation was applied.



\## Data cleaning and validation



The Bronze file was then processed in the Fabric notebook `NB\_Clean\_Validate\_Supermarket\_Data`.



The notebook:



\* converted the source date into a proper date field

\* checked the numeric columns

\* identified impossible inventory records

\* recalculated the stock-status values

\* created a supplier reliability score

\* created a category volatility index



A record was treated as invalid when daily sales were greater than the stock available from opening stock and deliveries.



\## Quarantine output



The validation process identified 44 invalid records.



These records were kept separately at:



`Files/quarantine/quarantined\_data.csv`



Keeping them in a quarantine file made it possible to remove unreliable records from the main analysis without losing the original evidence.



\## Final Lakehouse table



After cleaning and enrichment, 1,956 valid records were written to the Delta table:



`uk\_supermarket\_supply`



The table is available through the Lakehouse SQL analytics endpoint as:



`dbo.uk\_supermarket\_supply`



The final table contains 14 columns, including the original fields and the additional fields created during processing.



\## Final result



The Lakehouse therefore contains:



\* the original CSV in the Bronze folder

\* the rejected records in the quarantine folder

\* the cleaned and enriched Delta table used for SQL analysis and Power BI



No workspace identifiers, account details or connection strings are included in this repository.



