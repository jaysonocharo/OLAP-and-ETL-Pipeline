-- Regardless of daily fluctuations or regional differences, 
-- what is our macro-level annual revenue growth trend?

-- (Aggregating detailed data up to a higher level of summarization (e.g., Daily -> Yearly).)

-- By completely removing the noise of daily transactions, regions, and categories,
--  the query results provide a clear, high-level financial summary.
--  This solves the business need for macro-reporting to stakeholders.

SELECT 
    t.action_year, -- ROLLING UP to the highest time hierarchy
    SUM(f.price * f.quantity) AS annual_revenue,
    SUM(f.quantity) AS annual_volume
FROM snowflake.fact_sales f
JOIN snowflake.dim_time t ON f.time_id = t.time_id
GROUP BY t.action_year
ORDER BY t.action_year ASC;