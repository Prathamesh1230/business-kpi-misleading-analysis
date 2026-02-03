CREATE DATABASE IF NOT EXISTS business_kpi;
USE business_kpi;

-- Check data
SELECT COUNT(*) FROM sales_data;

SELECT * 
FROM sales_data 
LIMIT 10;

-- 1. Overall KPI Snapshot
SELECT 
    SUM(sales) AS total_revenue,
    SUM(profit) AS total_profit,
    ROUND(SUM(profit)/NULLIF(SUM(sales),0), 3) AS profit_margin
FROM sales_data;

-- 2. Revenue vs Profit Trend
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    SUM(sales) AS revenue,
    SUM(profit) AS profit
FROM sales_data
GROUP BY month
ORDER BY month;

-- 3. Region-wise KPI Comparison
SELECT 
    region,
    SUM(sales) AS revenue,
    SUM(profit) AS profit,
    ROUND(SUM(profit)/NULLIF(SUM(sales),0), 3) AS profit_margin
FROM sales_data
GROUP BY region
ORDER BY revenue DESC;

-- 4. Category-wise KPI Comparison
SELECT 
    category,
    SUM(sales) AS revenue,
    SUM(profit) AS profit,
    ROUND(SUM(profit)/NULLIF(SUM(sales),0), 3) AS profit_margin
FROM sales_data
GROUP BY category
ORDER BY revenue DESC;

-- 5. Discount Impact
SELECT 
    ROUND(discount,2) AS discount_level,
    SUM(sales) AS revenue,
    SUM(profit) AS profit,
    ROUND(SUM(profit)/NULLIF(SUM(sales),0), 3) AS profit_margin
FROM sales_data
GROUP BY discount_level
ORDER BY discount_level;

-- 6. Top-Selling but Low-Profit Products
SELECT 
    sub_category,
    SUM(sales) AS revenue,
    SUM(profit) AS profit,
    ROUND(SUM(profit)/NULLIF(SUM(sales),0), 3) AS profit_margin
FROM sales_data
GROUP BY sub_category
ORDER BY revenue DESC
LIMIT 10;

-- 7. High Revenue but Low Margin
SELECT 
    sub_category,
    SUM(sales) AS revenue,
    SUM(profit) AS profit,
    ROUND(SUM(profit)/NULLIF(SUM(sales),0), 3) AS profit_margin
FROM sales_data
GROUP BY sub_category
HAVING SUM(sales) > (SELECT AVG(sales) FROM sales_data)
   AND (SUM(profit) / NULLIF(SUM(sales),0)) < 0.05
ORDER BY revenue DESC;

-- 8. Order Frequency Proxy (Engagement)
SELECT 
    region,
    COUNT(order_id) / COUNT(DISTINCT order_month) AS avg_orders_per_month
FROM sales_data
GROUP BY region;


-- VIEWS FOR POWER BI 

CREATE VIEW vw_sales_master AS
SELECT
    order_id,
    order_date,
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    region,
    category,
    sub_category,
    sales AS revenue,
    profit,
    quantity,
    discount,
    profit_margin
FROM sales_data;

