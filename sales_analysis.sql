-- Creating tables
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50)
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    price DECIMAL(10,2)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Order_Details (
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- 2️ Inserting data
INSERT INTO Customers VALUES
 (1,'Rohan'),(2,'Sita'),(3,'Aman');

INSERT INTO Products VALUES
 (1,'Laptop',50000),
 (2,'Mouse',500),
 (3,'Keyboard',1500);

INSERT INTO Orders VALUES
 (101,1,'2025-01-12'),
 (102,2,'2025-02-05'),
 (103,3,'2025-03-09');

INSERT INTO Order_Details VALUES
 (101,1,1),(101,2,2),
 (102,1,1),(102,3,1),
 (103,2,5);

-- questions for Analysis

-- 3️ Top 3 customers
SELECT 
    c.customer_name,
    SUM(p.price * od.quantity) AS total_spent
FROM Customers c
JOIN Orders o       ON c.customer_id = o.customer_id
JOIN Order_Details od ON o.order_id = od.order_id
JOIN Products p     ON od.product_id = p.product_id
GROUP BY c.customer_name
ORDER BY total_spent DESC
LIMIT 3;

-- 4️ Monthly sales trend
SELECT 
    DATE_TRUNC('month', o.order_date) AS month,
    SUM(p.price * od.quantity) AS monthly_sales
FROM Orders o
JOIN Order_Details od ON o.order_id = od.order_id
JOIN Products p       ON od.product_id = p.product_id
GROUP BY month
ORDER BY month;

--Average order value per customer
SELECT 
    c.customer_name,
    AVG(order_total) AS avg_order_value
FROM (
    SELECT 
        o.order_id,
        o.customer_id,
        SUM(p.price * od.quantity) AS order_total
    FROM Orders o
    JOIN Order_Details od ON o.order_id = od.order_id
    JOIN Products p ON p.product_id = od.product_id
    GROUP BY o.order_id, o.customer_id
) sub
JOIN Customers c ON c.customer_id = sub.customer_id
GROUP BY c.customer_name
ORDER BY avg_order_value DESC;

--Product that generated the highest revenue
SELECT 
    p.product_name,
    SUM(p.price * od.quantity) AS revenue
FROM Products p
JOIN Order_Details od ON p.product_id = od.product_id
GROUP BY p.product_name
ORDER BY revenue DESC
LIMIT 1;

-- Month with maximum Sales Trend
SELECT 
    DATE_TRUNC('month', o.order_date) AS month,
    SUM(p.price * od.quantity) AS monthly_sales
FROM Orders o
JOIN Order_Details od ON o.order_id = od.order_id
JOIN Products p ON p.product_id = od.product_id
GROUP BY month
ORDER BY monthly_sales DESC
LIMIT 1;

--Number of orders per customer
SELECT 
    c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_orders DESC;

;--Total quantity sold per product
SELECT 
    p.product_name,
    SUM(od.quantity) AS qty_sold
FROM Products p
JOIN Order_Details od ON p.product_id = od.product_id
GROUP BY p.product_name
ORDER BY qty_sold DESC;

--Customers who bought more than one product in the same order
SELECT 
    o.order_id,
    c.customer_name,
    COUNT(od.product_id) AS products_in_order
FROM Orders o
JOIN Order_Details od ON o.order_id = od.order_id
JOIN Customers c ON c.customer_id = o.customer_id
GROUP BY o.order_id, c.customer_name
HAVING COUNT(od.product_id) > 1
ORDER BY o.order_id;




