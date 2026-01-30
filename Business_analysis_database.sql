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

-- 1. Monthly KPI View
CREATE VIEW monthly_kpi AS
SELECT 
    order_year,
    order_month,
    SUM(sales) AS revenue,
    SUM(profit) AS profit,
    ROUND(SUM(profit)/NULLIF(SUM(sales),0), 3) AS profit_margin
FROM sales_data
GROUP BY order_year, order_month;

-- 2. Region KPI View
CREATE VIEW region_kpi AS
SELECT 
    region,
    SUM(sales) AS revenue,
    SUM(profit) AS profit,
    ROUND(SUM(profit)/NULLIF(SUM(sales),0), 3) AS profit_margin
FROM sales_data
GROUP BY region;

-- 3. Category KPI View
CREATE VIEW category_kpi AS
SELECT 
    category,
    SUM(sales) AS revenue,
    SUM(profit) AS profit,
    ROUND(SUM(profit)/NULLIF(SUM(sales),0), 3) AS profit_margin
FROM sales_data
GROUP BY category;

-- 4. Sub-Category KPI View
CREATE VIEW subcategory_kpi AS
SELECT 
    sub_category,
    SUM(sales) AS revenue,
    SUM(profit) AS profit,
    ROUND(SUM(profit)/NULLIF(SUM(sales),0), 3) AS profit_margin
FROM sales_data
GROUP BY sub_category;

SELECT * FROM monthly_kpi LIMIT 10;
SELECT * FROM region_kpi;
SELECT * FROM category_kpi;
SELECT * FROM subcategory_kpi;
