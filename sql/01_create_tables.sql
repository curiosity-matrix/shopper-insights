
-- SCRIPT: 01_create_tables.sql
-- PURPOSE: Sets up the MySQL database schema for ShopperInsights (INR Currency)


CREATE DATABASE IF NOT EXISTS shopperinsights_db;
USE shopperinsights_db;

DROP TABLE IF EXISTS customer_shopping;

CREATE TABLE customer_shopping (
    customer_id VARCHAR(20) PRIMARY KEY,       -- Unique identifier for each shopper
    age INT,                                  -- Customer age (18 to 70)
    gender VARCHAR(10),                       -- Male / Female
    item_purchased VARCHAR(50),               -- Specific item (e.g., Kurti, Sneakers)
    category VARCHAR(30),                     -- Broad category (Clothing, Accessories, etc.)
    purchase_amount_inr DECIMAL(10, 2),       -- Transaction total in Indian Rupees (₹)
    location VARCHAR(50),                     -- Store location / City (Noida, Lucknow, Delhi, etc.)
    season VARCHAR(20),                       -- Season of purchase (Winter, Summer, etc.)
    review_rating DECIMAL(3, 1),              -- Customer rating (1.0 to 5.0)
    subscription_status VARCHAR(5),           -- 'Yes' or 'No'
    previous_purchases INT,                   -- Number of past visits
    payment_method VARCHAR(30),               -- UPI, Credit Card, Cash, etc.
    frequency_of_purchases VARCHAR(30)        -- Weekly, Monthly, etc.
);

CREATE INDEX idx_category ON customer_shopping(category);
CREATE INDEX idx_location ON customer_shopping(location);
