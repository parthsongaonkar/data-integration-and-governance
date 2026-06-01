-- Q1: Subscription revenue by market
-- to support product sales market analysis
SELECT
    c.market,

    -- Subscription revenue (supports total_margin_usd)
    ROUND(SUM(f.monthly_revenue_usd), 2)        AS total_subscription_revenue_usd,

    -- Subscription reach (supports total_customers_reached)
    COUNT(DISTINCT c.customer_number)           AS subscribing_customers,
    COUNT(DISTINCT f.subscription_id)           AS total_subscriptions,

    -- Status breakdown (shows market health)
    SUM(CASE WHEN f.status = 'Active'
        THEN 1 ELSE 0 END)                      AS active_subscriptions,
    SUM(CASE WHEN f.status = 'Cancelled'
        THEN 1 ELSE 0 END)                      AS cancelled_subscriptions,
    SUM(CASE WHEN f.status = 'Expired'
        THEN 1 ELSE 0 END)                      AS expired_subscriptions,

    -- Loyalty indicator (supports orders_per_customer)
    ROUND(AVG(f.months_active), 1)              AS avg_months_active,

    -- Package preference (supports product preference)
    ROUND(AVG(f.package_price), 2)              AS avg_package_price,
    ROUND(SUM(f.monthly_revenue_usd) /
          COUNT(DISTINCT c.customer_number), 2) AS subscription_revenue_per_customer

FROM dw.fact_subscription_revenue f
JOIN dw.dim_customer c ON f.customer_sk = c.customer_sk
GROUP BY c.market
ORDER BY total_subscription_revenue_usd DESC;