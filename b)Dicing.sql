-- How did the "Electronics" and "Furniture" 
-- categories perform specifically in 
-- the "East" and "West" regions during the 1st quarter (Months 1-3)?


-- Filtering on two or more dimensions to create a highly specific sub-cube of data.


-- This isolates three specific dimensions (Category, Region, and Time). 
-- The results allow business analysts to compare a highly targeted
--  cross-section of data, answering whether Q1 trends for high-ticket items differ significantly between
--  coastal regions.

SELECT 
    c.category_name,
    s.region,
    t.action_month,
    SUM(f.price * f.quantity) AS total_revenue
FROM snowflake.fact_sales f
JOIN snowflake.dim_product p ON f.product_id = p.product_id
JOIN snowflake.dim_category c ON p.category_id = c.category_id
JOIN snowflake.dim_store s ON f.store_id = s.store_id
JOIN snowflake.dim_time t ON f.time_id = t.time_id
WHERE c.category_name IN ('Electronics', 'Furniture') -- DICING Dim 1
  AND s.region IN ('East', 'West')                    -- DICING Dim 2
  AND t.action_month BETWEEN 1 AND 3                  -- DICING Dim 3
GROUP BY c.category_name, s.region, t.action_month;