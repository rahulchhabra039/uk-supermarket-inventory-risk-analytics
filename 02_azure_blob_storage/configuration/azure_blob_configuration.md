\# Azure Blob Storage Configuration



I used Azure Blob Storage as the first cloud landing point for the supermarket supply dataset.



The original CSV file was uploaded from my local system into a private Blob Storage container. From there, the Microsoft Fabric pipeline copied the file into the Bronze folder of the project Lakehouse.



\## Azure resources used



| Item             | Details                          |

| ---------------- | -------------------------------- |

| Resource group   | `rg-uk-supermarket-analytics`    |

| Storage account  | `stuksupmarket2026`              |

| Azure region     | UK South                         |

| Container        | `supermarket-raw`                |

| Folder           | `incoming`                       |

| Source file      | `uk\_supermarket\_supply\_2000.csv` |

| Performance tier | Standard                         |

| Redundancy       | Locally redundant storage (LRS)  |

| Access tier      | Hot                              |

| Container access | Private                          |



The source file was stored at:



`supermarket-raw/incoming/uk\_supermarket\_supply\_2000.csv`



The container was kept private, so the file could not be accessed anonymously.



I then connected the storage account to a Microsoft Fabric Data Factory pipeline. The pipeline picked up the CSV from the `incoming` folder and copied it into the Bronze area of the Fabric Lakehouse.



The storage account key and connection details have not been added to this repository.



\## Data flow



Local CSV file

→ Azure Blob Storage

→ Microsoft Fabric pipeline

→ Fabric Lakehouse Bronze folder



