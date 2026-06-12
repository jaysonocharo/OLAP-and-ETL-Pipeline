-- What is the total revenue and volume of items sold specifically in the
-- "North" region across all product categories?


-- (Filtering the data cube on a single dimension to focus on a specific subset)


-- The results isolate that territory's performance. Management can use this "slice" to
--  evaluate if the North region's marketing campaigns for specific categories are 
--  yielding ROI without the data being skewed by other regions.

SELECT 
    c.category_name,
    SUM(f.price * f.quantity) AS total_revenue,
    SUM(f.quantity) AS total_items_sold
FROM snowflake.fact_sales f
JOIN snowflake.dim_product p ON f.product_id = p.product_id
JOIN snowflake.dim_category c ON p.category_id = c.category_id
JOIN snowflake.dim_store s ON f.store_id = s.store_id
WHERE s.region = 'North' -- SLICING on one dimension
GROUP BY c.category_name;