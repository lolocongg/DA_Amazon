CREATE DATABASE Amazon
go

USE Amazon
go

ALTER TABLE customers
ADD address VARCHAR(5) DEFAULT 'xxxx';


-- FOREIGN KEY
ALTER TABLE products
ADD CONSTRAINT fk_products_category
FOREIGN KEY (category_id)
REFERENCES category (category_id);

ALTER TABLE orders
ADD CONSTRAINT fk_orders_customer
FOREIGN KEY (customer_id)
REFERENCES customers (customer_id);

ALTER TABLE orders
ADD CONSTRAINT fk_orders_seller
FOREIGN KEY (seller_id)
REFERENCES sellers (seller_id);



ALTER TABLE order_items
ADD CONSTRAINT fk_orderItem_orders
FOREIGN KEY (order_id)
REFERENCES orders (order_id);

ALTER TABLE order_items
ADD CONSTRAINT fk_products_order_items
FOREIGN KEY (product_id)
REFERENCES products (product_id);


ALTER TABLE payments
ADD CONSTRAINT fk_payments_orders
FOREIGN KEY (order_id)
REFERENCES orders (order_id);


ALTER TABLE shipping
ADD CONSTRAINT fk_shippings_orders
FOREIGN KEY (order_id)
REFERENCES orders (order_id);

ALTER TABLE inventory
ADD CONSTRAINT fk_products_inventory
FOREIGN KEY (product_id)
REFERENCES products (product_id);


-- 
select *from category;

select *from customers;

select *from orders;

select *from order_items;

select *from category;

select *from payments;

select *from shipping;

select *from inventory;

select *from sellers;

-- EDA & Clean Data
SELECT *FROM shipping WHERE return_date IS NOT NULL;

-- SQL Queries --

-- 1. Top 10 Selling Products ( product name, total quantity sold, and total sales value.

-- add new column
ALTER TABLE order_items
ADD total_sale FLOAT;

UPDATE order_items
SET total_sale = quantity * price_per_unit;

--
SELECT TOP 10 oi.product_id,p.product_name, 
       SUM(oi.quantity) AS total_quantity,
	   COUNT(o.order_id) total_orders
FROM orders AS o
JOIN order_items AS oi
    ON o.order_id = oi.order_id
JOIN products AS p
    ON p.product_id = oi.product_id
GROUP BY oi.product_id,p.product_name
ORDER BY COUNT(o.order_id) DESC

-- 2. Revenue by Category

SELECT p.category_id, c.category_name, SUM(oi.total_sale) as total_sale,
ROUND(SUM(oi.total_sale) / (SELECT SUM(total_sale) FROM order_items) *100,2)
FROM order_items oi join products p
ON oi.product_id = p.product_id
LEFT JOIN category c
on c.category_id = p.category_id
GROUP BY p.category_id, c.category_name
ORDER BY SUM(oi.total_sale)


