
-- SCRIPT: 02_business_queries.sql
-- PURPOSE: Core Data Analytics Business Queries for ShopperInsights (INR Currency)
-- NOTE: Written in standard ANSI SQL (100% compatible with MySQL & PostgreSQL)


USE shopperinsights_db;



-- QUERY 1: TOP 5 CATEGORIES BY TOTAL REVENUE IN RUPEES (₹)
-- CONCEPTS USED: GROUP BY, SUM(), COUNT(), ROUND(), ORDER BY, LIMIT
-- BUSINESS GOAL: Identify which product departments generate the highest gross revenue.

SELECT 
    category,
    COUNT(customer_id) AS total_customers,
    ROUND(SUM(purchase_amount_inr), 2) AS total_revenue_inr,
    ROUND(AVG(purchase_amount_inr), 2) AS avg_basket_size_inr
FROM customer_shopping
GROUP BY category
ORDER BY total_revenue_inr DESC
LIMIT 5;



-- QUERY 2: HIGH-SPENDING STORE LOCATIONS
-- CONCEPTS USED: GROUP BY, HAVING, AVG()
-- BUSINESS GOAL: Filter cities/branches where average customer spending exceeds ₹2,000.

SELECT 
    location,
    COUNT(customer_id) AS total_orders,
    ROUND(AVG(purchase_amount_inr), 2) AS avg_spent_per_customer_inr
FROM customer_shopping
GROUP BY location
HAVING AVG(purchase_amount_inr) > 2000.00
ORDER BY avg_spent_per_customer_inr DESC;



-- QUERY 3: CUSTOMER SPENDING TIER SEGMENTATION (IN RUPEES)
-- CONCEPTS USED: CASE WHEN ... THEN ... ELSE ... END
-- BUSINESS GOAL: Segment shoppers into Budget, Medium, and High Spenders (VIP)
--                to display personalized UPI discount offers.

SELECT 
    customer_id,
    age,
    gender,
    purchase_amount_inr,
    CASE 
        WHEN purchase_amount_inr >= 3000.00 THEN '⭐ High Spender (VIP)'
        WHEN purchase_amount_inr >= 1500.00 THEN '🔹 Medium Spender'
        ELSE '🟢 Budget Spender'
    END AS customer_tier
FROM customer_shopping
LIMIT 15;



-- QUERY 4: CATEGORY BENCHMARK ANALYSIS (SIMPLE & CLEAN CTE)
-- CONCEPTS USED: Common Table Expression (WITH clause)
-- BUSINESS GOAL: Calculate category-level sales benchmarks and filter departments
--                performing above ₹2,000 average basket size.

WITH category_summary AS (
    SELECT 
        category,
        COUNT(customer_id) AS total_transactions,
        ROUND(AVG(purchase_amount_inr), 2) AS avg_category_sales_inr
    FROM customer_shopping
    GROUP BY category
)
SELECT 
    category,
    total_transactions,
    avg_category_sales_inr
FROM category_summary
WHERE avg_category_sales_inr >= 2000.00
ORDER BY avg_category_sales_inr DESC;



-- QUERY 5: TOP RATED PRODUCTS PER CATEGORY (SIMPLE WINDOW FUNCTION)
-- CONCEPTS USED: DENSE_RANK() OVER (PARTITION BY ... ORDER BY ...)
-- BUSINESS GOAL: Rank products within each category based on customer reviews
--                to feature the #1 top-rated product on prime store displays.

SELECT 
    item_purchased,
    category,
    review_rating,
    DENSE_RANK() OVER (
        PARTITION BY category 
        ORDER BY review_rating DESC
    ) AS rating_rank_in_category
FROM customer_shopping
WHERE review_rating IS NOT NULL
LIMIT 20;
