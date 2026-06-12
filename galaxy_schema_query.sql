-- 1. Create the Outer Dimensions (No dependencies)
CREATE TABLE dim_category (
    category_id INT4 PRIMARY KEY,
    category_name VARCHAR
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

-- 2. Create the Inner Dimension (Depends on dim_category)
CREATE TABLE dim_product (
    product_id VARCHAR PRIMARY KEY,
    category_id INT4,
    product_name VARCHAR,
    FOREIGN KEY (category_id) REFERENCES dim_category(category_id)
);

-- 3. Create the Fact Table (Depends on dimensions)
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