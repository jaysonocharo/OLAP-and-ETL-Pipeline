SELECT 
    c.category_name,
    SUM(f.price * f.quantity) AS total_revenue,
    SUM(f.quantity) AS total_items_sold
FROM snowflake.fact_sales f
JOIN snowflake.dim_product p ON f.product_id = p.product_id
JOIN snowflake.dim_category c ON p.category_id = c.category_id
GROUP BY 
    c.category_name
ORDER BY 
    total_revenue DESC;