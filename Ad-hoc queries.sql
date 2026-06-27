/*
1. Customers with no orders
2. Total revenue per product
3. Total revenue by category
4. Top 5 products by revenue
5. Top 5 customers by spend
6. City-wise total revenue
7. Monthly order count
8. Monthly revenue trend
9. Repeat customers
10. Products never ordered
11. Average order value (AOV)
12. Best-selling product by quantity
13. Customers ordering from multiple categories
14. New customers per month
15. First order within 30 days of signup
16. Total quantity sold for each product.
*/

-- 1. Customers with no orders

SELECT customer_id
FROM customers
WHERE customer_id NOT IN (
    SELECT customer_id
    FROM orders
);

-- 2. Total revenue per product

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

-- 3. Total revenue by category

SELECT 
    p.category, 
    SUM(p.price * o.quantity) AS revenue
FROM
    products p
        JOIN
    orders o ON p.product_id = o.product_id
GROUP BY p.category
ORDER BY revenue DESC;

-- 4. Top 5 products by revenue

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

-- 5. Top 5 customers by spend

SELECT 
    c.customer_id,
    c.customer_name,
    SUM(p.price * o.quantity) AS total_spent
FROM
    customers c
        JOIN
    orders o ON c.customer_id = o.customer_id
        JOIN
    products p ON p.product_id = o.product_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent
LIMIT 5;

-- 6. City-wise total revenue

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

-- 7. Monthly order count

SELECT 
    MONTH(order_date) AS 'Month',
    MONTHNAME(order_date) AS Month_name,
    COUNT(order_id) AS Order_count
FROM
    orders
GROUP BY MONTH(order_date), MONTHNAME(order_date)
ORDER BY MONTH(order_date);

-- 8. Monthly revenue trend

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

-- 9. Repeat customers

SELECT 
    customer_id, COUNT(order_id) AS no_of_orders
FROM
    orders
GROUP BY customer_id
HAVING COUNT(order_id) > 1;

-- 10. Products never ordered

SELECT 
    p.product_id, p.product_name
FROM
    products p
        LEFT JOIN
    orders o ON p.product_id = o.product_id
WHERE
    o.product_id IS NULL;
    
-- 11.  Average order value (AOV)

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

-- 12. Best-selling product by quantity

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

-- 13. Customers ordering from multiple categories

SELECT 
    o.customer_id, COUNT(DISTINCT p.category) AS categories
FROM
    orders o
        JOIN
    products p ON o.product_id = p.product_id
GROUP BY o.customer_id
HAVING COUNT(DISTINCT p.category) > 1;

-- 14. New customers per month

SELECT 
    MONTH(signup_date) AS 'Month',
    MONTHNAME(signup_date) AS Month_name,
    COUNT(customer_id) AS monthly_new_customers
FROM
    customers
GROUP BY MONTH(signup_date) , MONTHNAME(signup_date)
ORDER BY MONTH(signup_date);

-- 15. First order within 30 days of signup

SELECT 
    c.customer_id,
    c.signup_date,
    MIN(o.order_date) AS first_order_date
FROM
    customers c
        JOIN
    orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id , c.signup_date
HAVING MIN(o.order_date) BETWEEN c.signup_date AND DATE_ADD(c.signup_date, INTERVAL 30 DAY);

-- 16. Total quantity sold for each product.

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





