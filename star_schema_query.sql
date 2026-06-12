-- 1. Create the Dimension Tables first
CREATE TABLE dim_product (
    product_id VARCHAR PRIMARY KEY,
    product_type VARCHAR,
    product_name VARCHAR
);

CREATE TABLE dim_store (
    store_id INT4 PRIMARY KEY,
    region VARCHAR
);

CREATE TABLE dim_time (
    time_id INT4 PRIMARY KEY,
    action_date DATE,
    action_year INT4,
    action_month INT4,
    action_week INT4,
    action_weekday VARCHAR
);

-- 2. Create the central Fact Table
CREATE TABLE fact_sales (
    sales_id INT4 PRIMARY KEY,
    product_id VARCHAR,
    time_id INT4,
    store_id INT4,
    price NUMERIC,
    quantity INT4,
    FOREIGN KEY (product_id) REFERENCES dim_product(product_id),
    FOREIGN KEY (time_id) REFERENCES dim_time(time_id),
    FOREIGN KEY (store_id) REFERENCES dim_store(store_id)
);