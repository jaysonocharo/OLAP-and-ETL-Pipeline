-- Can we get a side-by-side comparative matrix of total revenue for each product
--  category across all four major regions?

--  (Rotating the presentation of the data (often turning rows into columns) for easier cross-tabulation and comparative analysis.)

--  Instead of a long, unreadable list, this outputs a wide matrix 
--  where categories are rows and regions are columns. This allows executives to 
--  instantly scan horizontally and spot which geographical market is strongest for a 
--  given product type.

SELECT 
    c.category_name,
    SUM(f.price * f.quantity) FILTER (WHERE s.region = 'North') AS north_revenue,
    SUM(f.price * f.quantity) FILTER (WHERE s.region = 'South') AS south_revenue,
    SUM(f.price * f.quantity) FILTER (WHERE s.region = 'East') AS east_revenue,
    SUM(f.price * f.quantity) FILTER (WHERE s.region = 'West') AS west_revenue
FROM snowflake.fact_sales f
JOIN snowflake.dim_product p ON f.product_id = p.product_id
JOIN snowflake.dim_category c ON p.category_id = c.category_id
JOIN snowflake.dim_store s ON f.store_id = s.store_id
GROUP BY c.category_name;