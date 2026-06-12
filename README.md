# OLAP Operations and ETL Pipeline

## Overview
This repository contains a comprehensive data warehousing and Business Intelligence (BI) pipeline. It demonstrates a full-scope approach to data engineering, spanning from initial data extraction and transformation using Python to complex schema design and analytical querying using SQL. 

The project prioritizes technical transparency and robust architecture, showcasing the ability to build and manipulate structured data environments for advanced analytics.

## System Architecture

The database architecture is designed to support scalable multi-dimensional analysis. The SQL scripts in this repository define and query three distinct data warehouse architectures:

* **Star Schema:** A centralized fact table (`fact_sales`) connected directly to dimension tables (`dim_store`, `dim_product`, `dim_time`).
* **Snowflake Schema:** Normalized dimension tables for reduced redundancy and structured hierarchical querying.
* **Galaxy Schema (Fact Constellation):** Multiple interconnected fact tables (`fact_sales` and `fact_supply_order`) sharing conformed dimensions.

## ETL Process (Extract, Transform, Load)

The data pipeline utilizes Python for the heavy lifting of raw data processing before it enters the warehouse:
* **`data_cl_trans_redu.py`**: Handles the core ETL workflows, executing data cleaning, transformation, and dimensionality reduction to ensure high data integrity before loading it into the SQL environment.
* **`schema1.py`**: Programmatic database interaction and schema definitions.

*Note: To protect data privacy and keep the repository lightweight, raw datasets (`.xlsx` and `.csv` files) are intentionally excluded from version control via `.gitignore`.*

## Supported OLAP Operations

The SQL query suite executes standard Online Analytical Processing (OLAP) operations to extract actionable business intelligence:

1. **Slicing (`a)Slicing.sql`):** Isolating a single dimension (e.g., sales for a specific store).
2. **Dicing (`b)Dicing.sql`):** Creating a sub-cube by selecting multiple specific dimensions.
3. **Pivoting (`c)Pivoting.sql`):** Rotating the data axes to provide alternative visual layouts of the metrics.
4. **Drill Down (`d)Drill down.sql`):** Navigating from highly summarized data to detailed, granular data.
5. **Roll-up (`e)Drill up(Roll up).sql`):** Aggregating data by climbing up the concept hierarchy.
6. **Drill Across (`f)Drill across.sql`):** Querying across multiple fact tables using shared dimensions.
7. **Drill Through (`g)Drill through.sql`):** Penetrating beyond the OLAP cube directly to the underlying relational tables.

## Usage

1. **Python ETL:** Execute the Python scripts first to clean and transform your local data files.
2. **Database Setup:** Run `creating_the_3_schemas.sql` to initialize the warehouse structures.
3. **Analytics:** Execute the specific OLAP operation scripts against the initialized database to retrieve multi-dimensional insights.
