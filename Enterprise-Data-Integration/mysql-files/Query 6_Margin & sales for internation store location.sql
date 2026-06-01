-- ================================================
-- Q3 Query 1: Store locations ranked by
-- total dollar sales
-- ================================================
SELECT
    s.store_name,
    s.store_type,
    s.division,
    s.region,
    s.country,
    s.state,
    s.city,
    d.year                                      AS calendar_year,
    d.month_name                                AS calendar_month,
    SUM(f.qty)                                  AS unit_sales,
    ROUND(SUM(f.dollar_sales_usd), 2)           AS dollar_sales_usd,
    ROUND(SUM(f.cost_usd), 2)                   AS cost_usd,
    ROUND(SUM(f.margin_usd), 2)                 AS margin_usd,
    ROUND(SUM(f.margin_usd) /
          SUM(f.dollar_sales_usd) * 100, 2)     AS margin_pct
FROM dw.fact_product_sales f
JOIN dw.dim_store s ON f.store_sk = s.store_sk
JOIN dw.dim_date d  ON f.date_key = d.date_key
GROUP BY
    s.store_name,
    s.store_type,
    s.division,
    s.region,
    s.country,
    s.state,
    s.city,
    d.year,
    d.month,
    d.month_name
ORDER BY dollar_sales_usd DESC
LIMIT 20;