SELECT
    p.genre,
    SUM(f.revenue) AS total_revenue
FROM fact_sales f
         JOIN dim_product p ON f.product_key = p.product_key
GROUP BY p.genre
ORDER BY total_revenue DESC;


SELECT
    c.loyalty_tier,
    COUNT(DISTINCT f.order_id) AS total_orders,
    SUM(f.revenue) AS total_revenue
FROM fact_sales f
         JOIN dim_customer c ON f.customer_key = c.customer_key
GROUP BY c.loyalty_tier;


SELECT
    d.month_name,
    SUM(f.revenue) AS total_revenue
FROM fact_sales f
         JOIN dim_date d ON f.date_key = d.date_key
WHERE d.year = 2024
GROUP BY d.month, d.month_name
ORDER BY d.month;


SELECT
    p.title,
    SUM(f.quantity) AS total_sold
FROM fact_sales f
         JOIN dim_product p ON f.product_key = p.product_key
GROUP BY p.title
ORDER BY total_sold DESC
    LIMIT 3;


SELECT
    SUM(revenue) / COUNT(DISTINCT order_id) AS avg_order_value
FROM fact_sales;


SELECT
    c.name,
    SUM(f.revenue) AS total_spent
FROM fact_sales f
         JOIN dim_customer c ON f.customer_key = c.customer_key
GROUP BY c.name
HAVING SUM(f.revenue) > 100;


