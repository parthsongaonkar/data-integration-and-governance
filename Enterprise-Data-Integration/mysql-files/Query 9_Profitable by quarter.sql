-- ================================================
-- Q4 Query 2: Most profitable time periods
-- Quarterly granularity
-- Each quarter appears once
-- Ordered by most profitable quarter
-- ICE fiscal year Sep to Aug
-- All figures in USD
-- ================================================
SELECT
    d.quarter                                   AS calendar_quarter,
    d.fiscal_quarter,
    COUNT(DISTINCT f.order_id)                  AS total_orders,
    COUNT(DISTINCT d.month)                     AS months_in_quarter,
    SUM(f.qty)                                  AS unit_sales,
    ROUND(SUM(f.dollar_sales_usd), 2)           AS dollar_sales_usd,
    ROUND(SUM(f.cost_usd), 2)                   AS cost_usd,
    ROUND(SUM(f.margin_usd), 2)                 AS margin_usd,
    ROUND(SUM(f.margin_usd) /
          SUM(f.dollar_sales_usd) * 100, 2)     AS margin_pct,
    ROUND(SUM(f.dollar_sales_usd) /
          COUNT(DISTINCT d.month), 2)           AS avg_monthly_sales_usd,
    ROUND(SUM(f.margin_usd) /
          COUNT(DISTINCT d.month), 2)           AS avg_monthly_margin_usd
FROM dw.fact_product_sales f
JOIN dw.dim_date d ON f.date_key = d.date_key
WHERE d.fiscal_quarter IS NOT NULL
GROUP BY
    d.quarter,
    d.fiscal_quarter
ORDER BY margin_usd DESC;