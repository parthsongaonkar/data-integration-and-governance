-- Q2: Most profitable individual titles
SELECT
    p.product_category,
    p.product_type,
    p.title,
    d.year                                      AS calendar_year,
    CASE
        WHEN d.month IN (12, 1, 2)  THEN 'Summer'
        WHEN d.month IN (3, 4, 5)   THEN 'Autumn'
        WHEN d.month IN (6, 7, 8)   THEN 'Winter'
        WHEN d.month IN (9, 10, 11) THEN 'Spring'
    END                                         AS season,
    d.month_name                                AS calendar_month,
    SUM(f.qty)                                  AS unit_sales,
    ROUND(SUM(f.dollar_sales_usd), 2)           AS dollar_sales_usd,
    ROUND(SUM(f.cost_usd), 2)                   AS cost_usd,
    ROUND(SUM(f.margin_usd), 2)                 AS margin_usd,
    ROUND(SUM(f.margin_usd) /
          SUM(f.dollar_sales_usd) * 100, 2)     AS margin_pct
FROM dw.fact_product_sales f
JOIN dw.dim_product p ON f.product_sk = p.product_sk
JOIN dw.dim_date d    ON f.date_key   = d.date_key
GROUP BY
    p.product_category,
    p.product_type,
    p.title,
    d.year,
    d.month,
    d.month_name
ORDER BY margin_usd DESC
LIMIT 20;