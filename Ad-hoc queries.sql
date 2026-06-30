/*                                     Ad-Hoc Analysis

1. Customer Acquisition Analysis
	a. New customers per month
	b. ustomer acquisition by channel
	c. Customers with no orders

2. Customer Activation & Retention Analysis
	a. First order within 30 days of signup
	b. Average days to first purchase
	c. Repeat customers
	d. Customers with only one purchase

3. Customer Value Analysis
	a. Average order value (AOV)
	b. Top customers by revenue

4. Product Performance Analysis
	a. Revenue by product
	b. Revenue by category
	c. Best-selling product by quantity
	d. Products never ordered

5. Business Performance Analysis
	a. Monthly revenue trend
*/

-- 1. Customer Acquisition Analysis

-- a. New customers per month

SELECT 
    MONTHNAME((signup_date)) AS 'Month',
    COUNT(DISTINCT customer_id) AS customers
FROM
    customers
GROUP BY MONTHNAME((signup_date))
ORDER BY MONTH(signup_date) ASC;

/*
This query counts the number of customers who signed up each month. 
It groups customers by their signup month and displays the months in chronological order.

April recorded the highest customer acquisition with 28 new customers, indicating that customer acquisition efforts were most successful during that month. 
The business can investigate what marketing activities or campaigns were running in April and replicate them in future months.

*/

-- b. Customer acquisition by channel

SELECT 
    DISTINCT acquisition_channel,
    COUNT(DISTINCT customer_id) AS customers
FROM
    customers
GROUP BY acquisition_channel
ORDER BY customers DESC;

/*
This query groups customers based on their acquisition channel and counts how many customers came from each source.

Organic Search and Google Ads together contributed 50% of all customers, showing that these channels were the most effective for acquiring new customers. 
The business can continue investing in these channels while evaluating whether other channels need improvement.
*/

-- c. Customers with no orders

SELECT 
    c.customer_id
FROM
    customers c
        LEFT JOIN
    orders o ON c.customer_id = o.customer_id
WHERE
    o.order_id IS NULL;
    
/*
This query uses a LEFT JOIN to compare customers with orders. 
It returns customers whose order ID is NULL, meaning they signed up but never placed an order.

Every registered customer placed at least one order. 
This indicates strong initial customer engagement and suggests successfull conversion of signups into buyers.
*/

-- 2. Customer Activation & Retention Analysis

-- a. First order within 30 days of signup

WITH orders_data AS (
SELECT 
    c.customer_id,
    c.signup_date,
    MIN(o.order_date) AS first_order_date
FROM
    customers c
        INNER JOIN
    orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id , c.signup_date
HAVING MIN(o.order_date) BETWEEN c.signup_date AND DATE_ADD(c.signup_date, INTERVAL 30 DAY)
)
SELECT 
	COUNT(*) AS customers_first_order_within_30_days
FROM 
	orders_data;

/*
This query first finds each customer's first order date using MIN(order_date). 
It then filters customers whose first purchase occurred within 30 days of signing up and counts them.

56 customers placed their first order within 30 days of signing up. 
This indicates that more than half of the customers converted into paying customers quickly after registration, indicating customer activation.
*/

-- b. Average days to first purchase

WITH first_order AS (
    SELECT
        c.customer_id,
        c.signup_date,
        MIN(o.order_date) AS first_order_date
    FROM customers c
    INNER JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.signup_date
)
SELECT
    ROUND(AVG(DATEDIFF(first_order_date, signup_date)), 2)
        AS avg_days_to_first_purchase
FROM first_order;

/*
This query first identifies the first purchase date for every customer. 
It then calculates the number of days between signup and the first purchase and computes the average across all customers.

On average, customers made their first purchase 37 days after signing up. 
This metric helps the business understand how quickly new customers become paying customers and whether improvements are needed in promotional strategies.
*/

-- c. Repeat Customers

WITH repeat_customers AS (
    SELECT
        customer_id,
        COUNT(order_id) AS order_count
    FROM orders
    GROUP BY customer_id
    HAVING COUNT(order_id) > 1
)
SELECT COUNT(*) AS repeat_customers
FROM repeat_customers;

/*
This query counts the number of orders placed by each customer. 
Customers with more than one order are identified as repeat customers, and then their total count is calculated.

More than 50% of customers placed multiple orders. 
This indicates healthy early customer retention, suggesting that many customers found value in the products and returned for additional purchases.
*/

-- d. Customers with only one purchase

WITH one_time_customers AS (
    SELECT
        customer_id,
        COUNT(order_id) AS order_count
    FROM orders
    GROUP BY customer_id
    HAVING COUNT(order_id) = 1
)
SELECT COUNT(*) AS one_time_customers
FROM one_time_customers;

/*
This query identifies customers who placed exactly one order and counts how many such customers exist.

There are 35 one-time buyers. 
These customers represent an opportunity for the business to increase repeat purchases through personalized offers, or follow-up marketing campaigns.
*/

-- 3. Customer Value Analysis

-- a. Average order value (AOV)

SELECT 
    ROUND(SUM(o.quantity * p.price) / COUNT(DISTINCT o.order_id),
            2) AS AOV
FROM
    orders o
        INNER JOIN
    products p ON o.product_id = p.product_id;

/*
This query calculates the total revenue by multiplying product price and quantity for every order. 
It then divides the total revenue by the number of unique orders to calculate the average order value.

The Average Order Value is INR 936. 
This metric helps the business understand how much customers spend on average in a single order and can be used to evaluate pricing strategy.
*/

-- b. Top customers by revenue

SELECT 
    o.customer_id, SUM(o.quantity * p.price) AS revenue
FROM
    orders o
        JOIN
    products p ON o.product_id = p.product_id
GROUP BY o.customer_id
ORDER BY revenue DESC
LIMIT 10;

/*
This query calculates the total revenue generated by each customer by adding up the revenue from all their orders. 
It then sorts customers by revenue in descending order and returns the top ten customers.

The top 10 customers generated between INR 3,500 and INR 5,300 in revenue. 
These customers contribute significantly to the business and could be targeted with loyalty rewards, exclusive offers, or premium membership programs.
*/

-- 4. Product Performance Analysis

-- a. Revenue by product

SELECT 
    p.product_id,
    p.product_name,
    SUM(o.quantity * p.price) AS revenue
FROM
    orders o
        JOIN
    products p ON o.product_id = p.product_id
GROUP BY p.product_id , p.product_name
ORDER BY revenue DESC;

/*
This query calculates the total revenue generated by each product by multiplying quantity and price for every order and adding up the values for each product.

Hydrating Serum generated the highest revenue, followed by Night Repair Cream and Anti-dandruff Shampoo. 
These products are the strongest revenue contributors and can be prioritized in inventory planning, marketing campaigns, and promotional activities.
*/

-- b. Revenue by category

SELECT 
    p.category, SUM(o.quantity * p.price) AS revenue
FROM
    orders o
        JOIN
    products p ON o.product_id = p.product_id
GROUP BY p.category;

/*
This query groups products by category and calculates the total revenue generated by each category.

Skincare generated the highest revenue (INR 89,582), followed by Haircare (INR 69,439) and Bodycare (INR 27,236). 
This indicates that skincare products are currently driving the business and deserve greater focus in marketing and product expansion.
*/

-- c. Best-selling product by quantity

SELECT 
    p.product_id,
    p.product_name,
    SUM(o.quantity) AS product_count
FROM
    products p
        JOIN
    orders o ON p.product_id = o.product_id
GROUP BY p.product_id , p.product_name
ORDER BY product_count DESC;

/*
This query will determine how many units of each product were sold and rank products accordingly.

Anti-dandruff Shampoo was the best-selling product, followed by Hydrating Serum and Oil-free Moisturizer. 
These products show the strongest customer demand and should receive priority in inventory management and promotional campaigns.
*/

-- d. Products never ordered

SELECT 
    product_id
FROM
    products
WHERE
    product_id NOT IN (SELECT 
            product_id
        FROM
            orders);
            
/*
This query compares products with the orders table and returns products that never appeared in any order.

Every product received at least one order during the analysis period. 
This indicates that all products attracted customer interest, and there were no completely underperforming products.
*/

-- 5. Business Performance Analysis

-- a. Monthly revenue trend

SELECT 
    MONTHNAME(o.order_date) AS 'month',
    SUM(o.quantity * p.price) AS revenue
FROM
    orders o
        JOIN
    products p ON o.product_id = p.product_id
GROUP BY MONTHNAME(o.order_date)
ORDER BY MONTH(o.order_date) ASC;

/*
This query calculates monthly revenue by multiplying product price and quantity for every order, grouping the results by month, and displaying them chronologically.

Revenue increased steadily over the six-month period, reaching INR 1,24,201 in June. 
This upward trend suggests business growth during the startup's initial months and indicates increasing customer purchases over time.
*/








