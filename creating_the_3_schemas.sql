-- =================================================================================
-- PHASE 1: DATABASE SETUP (Create Schemas and Tables)
-- =================================================================================

-- -------------------------------------------------------
-- 1A. THE STAR SCHEMA
-- -------------------------------------------------------
CREATE SCHEMA IF NOT EXISTS star;

CREATE TABLE IF NOT EXISTS star.dim_product (
    product_id VARCHAR(50) PRIMARY KEY,
    product_type VARCHAR(100),
    product_name VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS star.dim_time (
    time_id SERIAL PRIMARY KEY,
    action_date DATE,
    action_year INT, action_month INT, action_week INT, action_weekday VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS star.dim_store (
    store_id SERIAL PRIMARY KEY,
    region VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS star.fact_sales (
    sales_id SERIAL PRIMARY KEY,
    product_id VARCHAR(50) REFERENCES star.dim_product(product_id),
    time_id INT REFERENCES star.dim_time(time_id),
    store_id INT REFERENCES star.dim_store(store_id),
    price DECIMAL,
    quantity INT
);

-- -------------------------------------------------------
-- 1B. THE SNOWFLAKE SCHEMA
-- -------------------------------------------------------
CREATE SCHEMA IF NOT EXISTS snowflake;

CREATE TABLE IF NOT EXISTS snowflake.dim_category (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS snowflake.dim_product (
    product_id VARCHAR(50) PRIMARY KEY,
    category_id INT REFERENCES snowflake.dim_category(category_id), 
    product_name VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS snowflake.dim_time (
    time_id SERIAL PRIMARY KEY,
    action_date DATE,
    action_year INT, action_month INT, action_week INT, action_weekday VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS snowflake.dim_store (
    store_id SERIAL PRIMARY KEY,
    region VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS snowflake.fact_sales (
    sales_id SERIAL PRIMARY KEY,
    product_id VARCHAR(50) REFERENCES snowflake.dim_product(product_id),
    time_id INT REFERENCES snowflake.dim_time(time_id),
    store_id INT REFERENCES snowflake.dim_store(store_id),
    price DECIMAL,
    quantity INT
);

-- -------------------------------------------------------
-- 1C. THE GALAXY SCHEMA (Fact Constellation)
-- -------------------------------------------------------
CREATE SCHEMA IF NOT EXISTS galaxy;

CREATE TABLE IF NOT EXISTS galaxy.dim_product (
    product_id VARCHAR(50) PRIMARY KEY,
    product_type VARCHAR(100),
    product_name VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS galaxy.dim_time (
    time_id SERIAL PRIMARY KEY,
    action_date DATE,
    action_year INT, action_month INT, action_week INT, action_weekday VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS galaxy.fact_sales (
    sales_id SERIAL PRIMARY KEY,
    product_id VARCHAR(50) REFERENCES galaxy.dim_product(product_id),
    time_id INT REFERENCES galaxy.dim_time(time_id),
    price DECIMAL,
    quantity INT
);

CREATE TABLE IF NOT EXISTS galaxy.fact_supply_order (
    supply_id SERIAL PRIMARY KEY,
    product_id VARCHAR(50) REFERENCES galaxy.dim_product(product_id),
    time_id INT REFERENCES galaxy.dim_time(time_id),
    price DECIMAL,
    quantity INT
);


-- =================================================================================
-- PHASE 2: CLEAR EXISTING DATA (The "Truncate" Step)
-- Using CASCADE clears the attached Fact tables automatically.
-- =================================================================================

TRUNCATE TABLE star.dim_product, star.dim_time, star.dim_store CASCADE;
TRUNCATE TABLE snowflake.dim_category, snowflake.dim_time, snowflake.dim_store CASCADE;
TRUNCATE TABLE galaxy.dim_product, galaxy.dim_time CASCADE;


-- =================================================================================
-- PHASE 3: DATA LOADING (The "COPY" Step)
-- =================================================================================

-- -------------------------------------------------------
-- 3A. LOAD THE STAR SCHEMA
-- -------------------------------------------------------
COPY star.dim_product FROM 'C:\csv_data\dim_product.csv' DELIMITER ',' CSV HEADER;

COPY star.dim_time(action_date, time_id, action_year, action_month, action_week, action_weekday) 
FROM 'C:\csv_data\dim_time.csv' DELIMITER ',' CSV HEADER;

COPY star.dim_store(region, store_id) 
FROM 'C:\csv_data\dim_store.csv' DELIMITER ',' CSV HEADER;

COPY star.fact_sales(product_id, time_id, store_id, price, quantity) 
FROM 'C:\csv_data\fact_sales.csv' DELIMITER ',' CSV HEADER;


-- -------------------------------------------------------
-- 3B. LOAD THE SNOWFLAKE SCHEMA (With Staging)
-- -------------------------------------------------------
DROP TABLE IF EXISTS temp_product_load;

CREATE TEMP TABLE temp_product_load (
    product_id VARCHAR(50),
    category_name VARCHAR(100),
    product_name VARCHAR(50)
);

COPY temp_product_load FROM 'C:\csv_data\dim_product.csv' DELIMITER ',' CSV HEADER;

INSERT INTO snowflake.dim_category (category_name)
SELECT DISTINCT category_name FROM temp_product_load;

INSERT INTO snowflake.dim_product (product_id, category_id, product_name)
SELECT 
    t.product_id,
    c.category_id,
    t.product_name
FROM temp_product_load t
JOIN snowflake.dim_category c ON t.category_name = c.category_name;

DROP TABLE temp_product_load;

COPY snowflake.dim_time(action_date, time_id, action_year, action_month, action_week, action_weekday) 
FROM 'C:\csv_data\dim_time.csv' DELIMITER ',' CSV HEADER;

COPY snowflake.dim_store(region, store_id) 
FROM 'C:\csv_data\dim_store.csv' DELIMITER ',' CSV HEADER;

COPY snowflake.fact_sales(product_id, time_id, store_id, price, quantity) 
FROM 'C:\csv_data\fact_sales.csv' DELIMITER ',' CSV HEADER;


-- -------------------------------------------------------
-- 3C. LOAD THE GALAXY SCHEMA
-- -------------------------------------------------------
COPY galaxy.dim_product FROM 'C:\csv_data\dim_product.csv' DELIMITER ',' CSV HEADER;

COPY galaxy.dim_time(action_date, time_id, action_year, action_month, action_week, action_weekday) 
FROM 'C:\csv_data\dim_time.csv' DELIMITER ',' CSV HEADER;

COPY galaxy.fact_sales(product_id, time_id, price, quantity) 
FROM 'C:\csv_data\fact_sales.csv' DELIMITER ',' CSV HEADER;

COPY galaxy.fact_supply_order(product_id, time_id, price, quantity) 
FROM 'C:\csv_data\fact_supply_order.csv' DELIMITER ',' CSV HEADER;