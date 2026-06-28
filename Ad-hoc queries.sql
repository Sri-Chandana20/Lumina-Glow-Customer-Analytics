/*
1. Customer Performance Analysis
- Customers with no orders
- New customers per month
- First order within 30 days of signup

2. Product Performance Analysis
- Total revenue per product
- Top 5 products by revenue
- Products never ordered
- Best-selling product by quantity
- Total quantity sold for each product
- Total revenue by category

3. Business Performance Analysis
- City-wise total revenue
- Monthly orders
- Monthly revenue trend
- Average order value (AOV)
*/

-- 1. Customers with no orders

SELECT customer_id
FROM customers
WHERE customer_id NOT IN (
    SELECT customer_id
    FROM orders
);

-- 2. New customers per month

SELECT 
    MONTH(signup_date) AS 'Month',
    MONTHNAME(signup_date) AS Month_name,
    COUNT(customer_id) AS monthly_new_customers
FROM
    customers
GROUP BY MONTH(signup_date) , MONTHNAME(signup_date)
ORDER BY MONTH(signup_date);

-- 3. First order within 30 days of signup

SELECT 
    c.customer_id,
    c.signup_date,
    MIN(o.order_date) AS first_order_date
FROM
    customers c
        JOIN
    orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id , c.signup_date
HAVING MIN(o.order_date) <= DATE_ADD(c.signup_date, INTERVAL 30 DAY);

-- 4. Total revenue per product

SELECT 
    p.product_id,
    p.product_name,
    SUM(p.price * o.quantity) AS revenue
FROM
    products p
        JOIN
    orders o ON p.product_id = o.product_id
GROUP BY p.product_id, p.product_name
ORDER BY revenue DESC;

-- 5. Top 5 products by revenue

SELECT 
    p.product_id,
    p.product_name,
    SUM(p.price * o.quantity) AS revenue
FROM
    products p
        JOIN
    orders o ON p.product_id = o.product_id
GROUP BY p.product_id, p.product_name
ORDER BY revenue DESC
LIMIT 5;

-- 6. Products never ordered

SELECT 
    p.product_id, p.product_name
FROM
    products p
        LEFT JOIN
    orders o ON p.product_id = o.product_id
WHERE
    o.product_id IS NULL;

-- 7. Best-selling product by quantity

SELECT 
    p.product_id,
    p.product_name,
    SUM(o.quantity) AS quantity_sold
FROM
    products p
        JOIN
    orders o ON p.product_id = o.product_id
GROUP BY p.product_id , p.product_name
ORDER BY quantity_sold DESC
LIMIT 1;


-- 8. Total quantity sold for each product

SELECT 
    p.product_id,
    p.product_name,
    SUM(o.quantity) AS sold_count
FROM
    products p
        JOIN
    orders o ON p.product_id = o.product_id
GROUP BY p.product_id
ORDER BY sold_count DESC;

-- 9. Total revenue by category

SELECT 
    p.category, 
    SUM(p.price * o.quantity) AS revenue
FROM
    products p
        JOIN
    orders o ON p.product_id = o.product_id
GROUP BY p.category
ORDER BY revenue DESC;

-- 10. City-wise total revenue

SELECT 
    c.city, SUM(p.price * o.quantity) AS revenue
FROM
    customers c
        JOIN
    orders o ON c.customer_id = o.customer_id
        JOIN
    products p ON p.product_id = o.product_id
GROUP BY c.city
ORDER BY revenue DESC;

-- 11. Monthly orders

SELECT 
    MONTH(order_date) AS 'Month',
    MONTHNAME(order_date) AS Month_name,
    COUNT(order_id) AS Order_count
FROM
    orders
GROUP BY MONTH(order_date), MONTHNAME(order_date)
ORDER BY MONTH(order_date);

-- 12. Monthly revenue trend

SELECT 
    MONTH(o.order_date) AS 'Month',
    MONTHNAME(o.order_date) AS Month_name,
    SUM(p.price * o.quantity) AS Revenue
FROM
    orders o
        JOIN
    products p ON o.product_id = p.product_id
GROUP BY MONTH(order_date) , MONTHNAME(order_date)
ORDER BY MONTH(order_date);
    
-- 12.  Average order value (AOV)

WITH order_totals AS (
    SELECT 
        o.order_id,
        SUM(p.price * o.quantity) AS order_value
    FROM orders o
    JOIN products p ON o.product_id = p.product_id
    GROUP BY o.order_id
)
SELECT ROUND(AVG(order_value), 2) AS average_order_value
FROM order_totals;












