-- 1. Delete the old rows with the missing Store IDs
TRUNCATE TABLE snowflake.fact_sales;

-- 2. Load the newly generated CSV data
COPY snowflake.fact_sales(product_id, time_id, store_id, price, quantity) 
FROM 'C:\csv_data\fact_sales.csv' DELIMITER ',' CSV HEADER;