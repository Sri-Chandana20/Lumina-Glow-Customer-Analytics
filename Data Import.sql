
-- Create a database

CREATE DATABASE customer_analysis;

-- Create products table and import products CSV file

CREATE TABLE products (
	product_id VARCHAR(10) PRIMARY KEY,
    product_name VARCHAR(30),
    category VARCHAR(15),
    price INT
    );
    
-- Create customers table and import customers CSV file

CREATE TABLE customers (
    customer_id VARCHAR(10) PRIMARY KEY,
    customer_name VARCHAR(50),
    city VARCHAR(20),
    age INT,
    gender VARCHAR(10),
    signup_date DATE,
    acquisition_channel VARCHAR(50)
);

-- Create orders table and import orders CSV file

CREATE TABLE orders (
    order_id VARCHAR(10) PRIMARY KEY,
    customer_id VARCHAR(10),
    product_id VARCHAR(10),
    order_date DATE,
    quantity INT
);







