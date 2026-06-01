-- Q2: Product categories ranked by profitability
-- Most profitable category at the top
SELECT
    p.product_category,

    -- Volume
    COUNT(DISTINCT f.order_id)                  AS total_orders,
    SUM(f.qty)                                  AS total_units_sold,

    -- Revenue
    ROUND(SUM(f.dollar_sales_usd), 2)           AS total_sales_usd,
    ROUND(SUM(f.cost_usd), 2)                   AS total_cost_usd,
    ROUND(SUM(f.margin_usd), 2)                 AS total_margin_usd,

    -- Profitability
    ROUND(SUM(f.margin_usd) /
          SUM(f.dollar_sales_usd) * 100, 2)     AS margin_pct,

    -- Contribution to total ICE margin
    ROUND(SUM(f.margin_usd) /
         (SELECT SUM(margin_usd)
          FROM dw.fact_product_sales) * 100, 2) AS pct_of_total_margin

FROM dw.fact_product_sales f
JOIN dw.dim_product p ON f.product_sk = p.product_sk
GROUP BY p.product_category
ORDER BY total_margin_usd DESC;