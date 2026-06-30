<h1 align="center"> Customer Analytics for Lumina Glow using MySQL | Ad Hoc Business Insights</h1>

### Analysis Objective
- This project analyzes a consumer goods dataset containing customers, orders, and products. The objective was to perform ad-hoc SQL analysis to derive business insights such as customer, product performance, and business performance analysis.

---

### Dataset Overview
**Tables:**

- customers (customer_id, customer_name, city, signup_date)

- products (product_id, product_name, category, price)

- orders (order_id, customer_id, product_id, order_date, quantity)

**Key Columns:**

customers (customer_id is the PRIMARY KEY)

products (product_id is the PRIMARY KEY)

orders (order_id is the PRIMARY KEY. customer_id and product_id are the FOREIGN KEYS)

---

### Key Business Questions Solved

- **Customer Analysis**

**1. Customers with no orders -** Every customer placed at least one order, indicating strong customer conversion and engagement.

**2. New customers per month -** April saw a significant increase in customer acquisition compared to other months. This could indicate the success of a marketing campaign, a seasonal event, or promotional activities

**3. First order within 30 days of signup -** Every customer placed their first order within 30 days of signing up. It indicates strong customer activation and engagement. The business appears to be effective in encouraging customers to make their first purchase soon after registration.


- **Product Performance Analysis**
  
Total revenue per product

Top 5 products by revenue

Products never ordered

Best-selling product by quantity

Total quantity sold for each product

Total revenue by category

- **Business Performance Analysis**

City-wise total revenue

Monthly orders

Monthly revenue trend

Average order value (AOV)


[Check out the Data import queries here](https://github.com/Sri-Chandana20/SQL-Consumer-Goods-Sales-Analysis/blob/main/Data%20import.sql)

[Check out the Ad-hoc queries here](https://github.com/Sri-Chandana20/SQL-Consumer-Goods-Sales-Analysis/blob/main/Ad-hoc%20queries.sql)

---

### Tools Used

**MySQL:** Database storage (CREATE TABLE with data types like DECIMAL, VARCHAR, DATE) and querying (JOINS, GROUP BY, HAVING, LIMIT).

---

### Key Insights

- On average, **more than 5 new customers joined each month**, with April having the highest number (16 customers).

- There are **34 repeat customers.** Also, 26 customers have purchased from more than one product category.

- **Smartwatch** generated the **highest revenue** (132,981), while Cotton T-Shirt generated the lowest revenue (2,397).

- **Electronics** is the **highest revenue-generating category** (374,406), whereas Apparel generated the lowest revenue (75,263).

- **London** generated the **highest revenue** (210,008), while Chennai generated 86,568.

- **Laptop Backpack** is the **best-selling** product by quantity (33 units sold).

- The **top 5 revenue-generating** products are Smartwatch, Wireless Earbuds, Laptop Backpack, Hair Dryer, and Formal Shoes.

---

### Business Impact

This analysis provides visibility into customer behavior, product performance, category performance, and city-wise revenue contribution. The insights can help stakeholders understand key revenue drivers and monitor overall business performance.


  

  











