-- ================================================
-- Q4 Query 1: Most profitable time periods
-- Monthly granularity
-- Each month appears once
-- Ordered by most profitable month
-- All figures in USD
-- ================================================
SELECT
    d.month_name                                AS calendar_month,
    ROUND(SUM(f.dollar_sales_usd), 2)           AS dollar_sales_usd,
    ROUND(SUM(f.margin_usd) /
          SUM(f.dollar_sales_usd) * 100, 2)     AS margin_pct,
    d.month                                     AS month_number,
    d.fiscal_period,
    CASE
        WHEN d.month IN (12, 1, 2)  THEN 'Summer'
        WHEN d.month IN (3, 4, 5)   THEN 'Autumn'
        WHEN d.month IN (6, 7, 8)   THEN 'Winter'
        WHEN d.month IN (9, 10, 11) THEN 'Spring'
    END                                         AS season,
    COUNT(DISTINCT f.order_id)                  AS total_orders,
    ROUND(SUM(f.margin_usd), 2)                 AS margin_usd,
    SUM(f.qty)                                  AS unit_sales,
    ROUND(SUM(f.cost_usd), 2)                   AS cost_usd
FROM dw.fact_product_sales f
JOIN dw.dim_date d ON f.date_key = d.date_key
GROUP BY
    d.month,
    d.month_name,
    d.fiscal_period
ORDER BY margin_usd DESC;