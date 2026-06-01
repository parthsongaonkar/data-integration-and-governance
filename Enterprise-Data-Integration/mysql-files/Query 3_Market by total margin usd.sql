-- Q1: Market penetration analysis
-- Shows how deeply ICE has reached each market
-- through product sales
SELECT
    c.market,
    ROUND(SUM(f.margin_usd), 2)                 AS total_margin_usd,
    -- Customer reach
    COUNT(DISTINCT c.customer_number)           AS total_customers_reached,
    COUNT(DISTINCT f.order_id)                  AS total_transactions,
    -- Product preference by market
    SUM(CASE WHEN p.product_category = 'Music'
        THEN f.qty ELSE 0 END)                  AS music_units_sold,
    SUM(CASE WHEN p.product_category = 'Films'
        THEN f.qty ELSE 0 END)                  AS films_units_sold,
    SUM(CASE WHEN p.product_category = 'Audio Books'
        THEN f.qty ELSE 0 END)                  AS audiobooks_units_sold,
    -- Total units
    SUM(f.qty)                                  AS total_units_sold,
    -- Revenue generated
    ROUND(SUM(f.dollar_sales_usd), 2)           AS total_sales_usd,
    -- Market share metrics
    ROUND(SUM(f.dollar_sales_usd) /
          COUNT(DISTINCT c.customer_number), 2) AS revenue_per_customer,
    ROUND(SUM(f.qty) /
          COUNT(DISTINCT c.customer_number), 2) AS units_per_customer,
    ROUND(COUNT(DISTINCT f.order_id) /
          COUNT(DISTINCT c.customer_number), 2) AS orders_per_customer
FROM dw.fact_product_sales f
JOIN dw.dim_customer c  ON f.customer_sk = c.customer_sk
JOIN dw.dim_product p   ON f.product_sk  = p.product_sk
GROUP BY c.market
ORDER BY total_margin_usd DESC;