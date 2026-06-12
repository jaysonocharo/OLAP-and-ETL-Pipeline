-- We had an abnormally high revenue spike on a specific date in the East region;
-- what were the exact individual transactions (receipts) that occurred on that day

-- (Moving past aggregated data entirely to view the raw,
-- atomic transaction-level rows that make up the aggregations.)

-- Instead of returning a summarized total, this query returns the raw rows.
-- This solves the business question by allowing auditors or managers to investigate
-- specific anomalies, fraud, or massive individual bulk orders that caused the aggregate spike.


SELECT 
    f.sales_id AS transaction_receipt,
    t.action_date,
    p.product_name,
    f.price AS unit_price,
    f.quantity,
    (f.price * f.quantity) AS transaction_total
FROM snowflake.fact_sales f
JOIN snowflake.dim_time t ON f.time_id = t.time_id
JOIN snowflake.dim_store s ON f.store_id = s.store_id
JOIN snowflake.dim_product p ON f.product_id = p.product_id
WHERE t.action_date = '2023-11-24' -- Example spike date
  AND s.region = 'East'
-- NO GROUP BY or SUM(). Exposing raw atomic rows.
ORDER BY transaction_total DESC;