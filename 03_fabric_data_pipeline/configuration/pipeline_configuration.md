\# Fabric Data Pipeline Configuration



I created a Microsoft Fabric Data Factory pipeline to move the original supermarket supply CSV from Azure Blob Storage into the Bronze area of the Fabric Lakehouse.



\## Pipeline details



\* Pipeline name: `PL\_Ingest\_AzureBlob\_to\_Bronze`

\* Copy activity: `CP\_AzureBlob\_to\_Bronze`



\## Source



The pipeline reads the file from Azure Blob Storage.



\* Container: `supermarket-raw`

\* Folder: `incoming`

\* File: `uk\_supermarket\_supply\_2000.csv`

\* Transfer format: Binary



\## Destination



The file is copied into the project Lakehouse.



\* Lakehouse: `LH\_UK\_Supermarket\_Inventory`

\* Destination folder: `Files/bronze`

\* Output file: `uk\_supermarket\_supply\_2000.csv`

\* Transfer format: Binary



I used Binary format for the copy activity because the purpose of this pipeline was only to move the original file into the Bronze folder. No cleaning or column-level transformation was carried out during ingestion.



The pipeline was validated and then run successfully. After the run, the CSV was available in the Bronze folder with the same structure and contents as the original source file.



Storage credentials and connection details are not included in this repository.



