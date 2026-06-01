-- ================================================
-- Q5 Query 2: Overall market ranking
-- Which market generates most profit overall
-- Each market appears once
-- ================================================
SELECT
    c.market,
    COUNT(DISTINCT c.customer_number)           AS total_customers,
    COUNT(DISTINCT f.order_id)                  AS total_orders,
    SUM(f.qty)                                  AS unit_sales,
    ROUND(SUM(f.dollar_sales_usd), 2)           AS dollar_sales_usd,
    ROUND(SUM(f.cost_usd), 2)                   AS cost_usd,
    ROUND(SUM(f.margin_usd), 2)                 AS margin_usd,
    ROUND(SUM(f.margin_usd) /
          SUM(f.dollar_sales_usd) * 100, 2)     AS margin_pct,
    ROUND(SUM(f.dollar_sales_usd) /
          COUNT(DISTINCT c.customer_number), 2) AS revenue_per_customer,
    ROUND(SUM(f.margin_usd) /
          COUNT(DISTINCT c.customer_number), 2) AS margin_per_customer
FROM dw.fact_product_sales f
JOIN dw.dim_customer c ON f.customer_sk = c.customer_sk
GROUP BY c.market
ORDER BY margin_usd DESC;