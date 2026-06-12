-- For each product category, how does the total volume of items sold compare 
-- against the total volume of inventory supplied, and are we facing shortages?

-- (Comparing metrics across two different business processes (Fact Tables) that 
-- share the same conformed dimensions. (We use the galaxy schema for this))

-- By bridging fact_sales and fact_supply_order through the shared dim_product dimension, 
-- the results provide a unified view of the supply chain. It solves the question by 
-- instantly highlighting categories where sales are outpacing supply (negative inventory balance).

SELECT 
    p.product_type,
    SUM(fs.quantity) AS total_sold,
    SUM(fso.quantity) AS total_supplied,
    (SUM(fso.quantity) - SUM(fs.quantity)) AS inventory_balance
FROM galaxy.dim_product p
-- Join to Fact 1 (Sales)
LEFT JOIN galaxy.fact_sales fs ON p.product_id = fs.product_id
-- Join to Fact 2 (Supply)
LEFT JOIN galaxy.fact_supply_order fso ON p.product_id = fso.product_id
GROUP BY p.product_type;