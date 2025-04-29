create database online_sales;
use online_sales;
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255),
    category VARCHAR(100),
    price DECIMAL(10, 2)
);
# orders table

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    amount DECIMAL(10, 2),
    product_id INT,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
#customers table

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(255),
    email VARCHAR(255)
);
#order_details table

CREATE TABLE order_details (
    order_detail_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

#inserting values in product table
insert into products values(1, 'Smartphone', 'Electronics', 19999.99),
(2, 'Book: Python Basics', 'Book', 299.99),
(3, 'Kitchen Mixer Grinder', 'Electronics', 1599.99),
(4, 'Laptop', 'Electronics', 49999.99),
(5, 'Headphones', 'Electronics', 1299.99),
(6, 'SQL', 'Book', 1299.99),
(7, 'Kurti Set', 'Clothes', 999.99),
(8, 'Shoes', 'Footwear', 799.99),
(9, 'Speaker', 'Electronics', 1899.99),
(10, 'Book: Java Basics', 'Book', 899.99);
select*from products;

##inserting value into orders table

insert into orders values(1,'2024-04-01', 19999.99,1),
(2,'2024-04-02', 299.99,2),
(3,'2024-04-03', 1599.99, 3),
(4,'2024-04-07', 49999.99, 4),
(5,'2024-04-08', 1299.99,5),
(6,'2024-04-10', 1299.99,6),
(7,'2024-04-20', 999.99, 7),
(8,'2024-04-23', 799.99,8),
(9,'2024-04-28', 1899.99, 9),
(10,'2024-04-29', 899.99, 10);
select*from orders;

##inserting value into order_details table

insert into order_details values
(1, 1, 1,  1, 19999.98),
(2, 2, 2,  1, 299.99),
(3, 3, 3,  2, 3199.98 ),
(4, 4, 4,  1, 49999.99),
(5, 5, 5,  3, 3899.97 ),
(6, 6, 6,  4, 5199.96 ),
(7, 7, 7,  2, 1999.98),
(8, 8, 8,  5, 3999.95 ),
(9, 9, 9,  2, 3799.98 ),
(10, 10, 10, 2, 1799.98 );
select * from order_details;

#inserting values in customers table
insert into customers values
(1, 'sanyukta gadge', 'sanyu@gadge.com'),
(2, 'sakshi badhe', 'sakshi@badhe.com'),
(3, 'Sahil Shelar', 'sahil@shelar.com' ),
(4, 'Rohit Sawant', 'rohit@sawant.com'),
(5, 'Saujanya Gadge', 'sauju@gadge.com'),
(6, 'Saloni Patil', 'saloni@patil.com'),
(7, 'Kausthubh Tandel', 'kausthub@tandel.com'),
(8, 'Swapnil Mane', 'swapnil@mane.com'),
(9, 'Sunny Jadhav', 'sunny@jadhav.com'),
(10, 'pragati  gadge', 'pragati@gadge.com');
select *from customers;

# EXTRACT(MONTH FROM order_date) for month.
SELECT 
    EXTRACT(MONTH FROM order_date) AS order_month,
    COUNT(*) AS total_orders
FROM orders
GROUP BY EXTRACT(MONTH FROM order_date)
ORDER BY order_month;

#GROUP BY year/month.
SELECT 
    DATE_FORMAT(order_date, '%Y-%m-%d') AS order_date,
    COUNT(*) AS total_orders,
    SUM(amount) AS total_sales
FROM orders
GROUP BY order_date
ORDER BY order_date;

#Use SUM() for revenue.

SELECT 
    DATE_FORMAT(order_date, '%Y-%m-%d') AS order_date,
    SUM(amount) AS total_revenue
FROM orders
GROUP BY order_date
ORDER BY order_date;

#COUNT(DISTINCT order_id) for volume.

SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS order_date,
    COUNT(DISTINCT order_id) AS order_volume
FROM orders
GROUP BY order_date
ORDER BY order_date;

#Use ORDER BY for sorting.

SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS order_date,
    SUM(amount) AS total_revenue,
    COUNT(DISTINCT order_id) AS order_volume
FROM orders
GROUP BY order_date
ORDER BY total_revenue DESC;

#Limit results for specific time periods.
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS order_date,
    SUM(amount) AS total_revenue,
    COUNT(DISTINCT order_id) AS order_volume
FROM orders
WHERE order_date BETWEEN '2024-04-01' AND '2024-04-30'
GROUP BY order_date
ORDER BY total_revenue DESC;

#Customer Purchase Summary (total spent by each customer)

SELECT c.customer_name, SUM(od.price * od.quantity) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.order_id  
JOIN order_details od ON o.order_id = od.order_id
GROUP BY c.customer_name 
ORDER BY total_spent DESC;

#Top 5 Best-Selling Products (by quantity)

SELECT p.product_name, SUM(od.quantity) AS total_sold
FROM order_details od
JOIN products p ON od.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC
LIMIT 5;

#Average Order Value

SELECT AVG(order_total) AS avg_order_value
FROM (
    SELECT o.order_id, SUM(od.quantity * od.price) AS order_total
    FROM orders o
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY o.order_id
) AS order_totals;

#Category-wise Revenue Breakdown

SELECT p.category, SUM(od.quantity * od.price) AS category_revenue
FROM order_details od
JOIN products p ON od.product_id = p.product_id
GROUP BY p.category
ORDER BY category_revenue DESC;

#Monthly Revenue Trend

SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS month, 
       SUM(od.quantity * od.price) AS monthly_revenue
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY month
ORDER BY month;