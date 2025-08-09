-- =========================================================
-- CUSTOMER SEGMENTATION ANALYSIS WITH LOAN SEEKERS
-- =========================================================
-- CREATE DATABASE IF NOT EXISTS customer_seg_proj;
USE customer_seg_proj;
-- 2️⃣ Create tables
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    gender CHAR(1),
    location VARCHAR(100)
);

CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    customer_id INT,
    transaction_date DATE,
    amount DECIMAL(10, 2),
    category VARCHAR(100),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE products (
    product_id VARCHAR(10) PRIMARY KEY,
    product_name VARCHAR(100),
    segment VARCHAR(50)
);

-- 3️⃣ Insert sample data
INSERT INTO customers (customer_id, name, age, gender, location) VALUES
(1, 'Alice', 32, 'F', 'New York'),
(2, 'Bob', 45, 'M', 'Chicago'),
(3, 'Carol', 27, 'F', 'Los Angeles'),
(4, 'David', 40, 'M', 'Boston');

INSERT INTO transactions (transaction_id, customer_id, transaction_date, amount, category) VALUES
(101, 1, '2025-07-01', 500, 'Savings Deposit'),
(102, 2, '2025-07-03', 2000, 'Loan Repayment'),
(103, 3, '2025-07-04', 1200, 'Credit Card Spend'),
(104, 2, '2025-07-06', 1500, 'Loan Repayment'),
(105, 4, '2025-07-07', 800, 'Savings Deposit'),
(106, 4, '2025-07-08', 900, 'Loan Repayment');

INSERT INTO products (product_id, product_name, segment) VALUES
('P1', 'Premium Credit Card', 'High Spenders'),
('P2', 'Home Loan', 'Loan Seekers'),
('P3', 'Savings Account', 'Savers');

-- 4️⃣ Step 1: Total Spend per Customer
SELECT 
    c.customer_id,
    c.name,
    SUM(t.amount) AS total_spent
FROM customers c
JOIN transactions t ON c.customer_id = t.customer_id
GROUP BY c.customer_id, c.name;

-- 5️⃣ Step 2: Categorize into Segments (with Loan Seekers logic)
SELECT 
    c.customer_id,
    c.name,
    CASE
        WHEN SUM(CASE WHEN category = 'Loan Repayment' THEN 1 ELSE 0 END) > COUNT(*) / 2 
            THEN 'Loan Seekers'
        WHEN SUM(t.amount) > 1500 
            THEN 'High Spenders'
        WHEN SUM(t.amount) BETWEEN 500 AND 1500 
            THEN 'Savers'
        ELSE 'Low Activity'
    END AS customer_segment
FROM customers c
JOIN transactions t ON c.customer_id = t.customer_id
GROUP BY c.customer_id, c.name;

-- 6️⃣ Step 3: Recommend Products Based on Segment
WITH transaction_summary AS (
    SELECT
        c.customer_id,
        c.name,
        COUNT(*) AS total_txn,
        SUM(CASE WHEN category = 'Loan Repayment' THEN 1 ELSE 0 END) AS loan_txn,
        SUM(t.amount) AS total_amount
    FROM customers c
    JOIN transactions t ON c.customer_id = t.customer_id
    GROUP BY c.customer_id, c.name
),
customer_segments AS (
    SELECT
        customer_id,
        name,
        CASE
            WHEN loan_txn > total_txn / 2 THEN 'Loan Seekers'
            WHEN total_amount > 1500 THEN 'High Spenders'
            WHEN total_amount BETWEEN 500 AND 1500 THEN 'Savers'
            ELSE 'Low Activity'
        END AS segment
    FROM transaction_summary
)
SELECT
    cs.customer_id,
    cs.name,
    cs.segment,
    p.product_name AS recommended_product
FROM customer_segments cs
JOIN products p
    ON cs.segment = p.segment;
    -- 7️⃣ Step 4: Count Customers in Each Segment
WITH transaction_summary AS (
    SELECT
        c.customer_id,
        COUNT(*) AS total_txn,
        SUM(CASE WHEN category = 'Loan Repayment' THEN 1 ELSE 0 END) AS loan_txn,
        SUM(t.amount) AS total_amount
    FROM customers c
    JOIN transactions t ON c.customer_id = t.customer_id
    GROUP BY c.customer_id
),
customer_segments AS (
    SELECT
        customer_id,
        CASE
            WHEN loan_txn > total_txn / 2 THEN 'Loan Seekers'
            WHEN total_amount > 1500 THEN 'High Spenders'
            WHEN total_amount BETWEEN 500 AND 1500 THEN 'Savers'
            ELSE 'Low Activity'
        END AS segment
    FROM transaction_summary
)
SELECT
    segment,
    COUNT(*) AS customers_count
FROM customer_segments
GROUP BY segment;


