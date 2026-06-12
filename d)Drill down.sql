-- The "Furniture" category is performing well overall, but what are the specific 
-- revenue contributions of the individual products within that category?

-- (Navigating from a high-level summary down to a more detailed, granular
-- level within a hierarchy (e.g., Year -> Month, or Category -> Product).)

-- The results reveal the underlying drivers of the category's success.
-- It answers the business question by identifying whether the revenue is carried
-- by a single bestseller or evenly distributed across multiple furniture items.

SELECT 
    c.category_name,
    p.product_id, -- DRILLING DOWN from Category to Product
    SUM(f.price * f.quantity) AS total_revenue
FROM snowflake.fact_sales f
JOIN snowflake.dim_product p ON f.product_id = p.product_id
JOIN snowflake.dim_category c ON p.category_id = c.category_id
WHERE c.category_name = 'Furniture'
GROUP BY c.category_name, p.product_id
ORDER BY total_revenue DESC;