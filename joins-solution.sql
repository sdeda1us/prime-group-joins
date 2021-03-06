-- 1. Get all customers and their addresses.
SELECT first_name, last_name, street, city, state, zip FROM customers
JOIN addresses ON addresses.customer_id = customers.id;

-- 2. Get all orders and their line items (orders, quantity and product).
SELECT orders.id, orders.order_date, line_items.quantity, products.description FROM line_items
JOIN orders ON line_items.order_id = orders.id
JOIN products ON line_items.product_id = products.id;

-- 3. Which warehouses have cheetos?
SELECT p.description, w.id, w.warehouse, wp.product_id, wp.product_id, wp.on_hand FROM warehouse_product AS wp
JOIN products AS p ON p.id = wp.product_id
JOIN warehouse AS w ON w.id = wp.warehouse_id
WHERE p.description = 'cheetos' AND on_hand > 0;

-- 4. Which warehouses have diet pepsi?
SELECT p.description, w.id, w.warehouse, wp.product_id, wp.product_id, wp.on_hand FROM warehouse_product AS wp
JOIN products AS p ON p.id = wp.product_id
JOIN warehouse AS w ON w.id = wp.warehouse_id
WHERE p.description = 'diet pepsi' AND on_hand > 0;

-- 5. Get the number of orders for each customer. NOTE: It is OK if those without orders are not included in results.
SELECT c.first_name, c.last_name, count(*) FROM customers AS c
JOIN addresses as a ON c.id = a.customer_id
JOIN orders as o ON o.address_id = a.id
GROUP BY c.first_name, c.last_name
ORDER BY count(*) DESC;

-- 6. How many customers do we have?
SELECT count(id) from customers;


-- 7. How many products do we carry?
SELECT count(id) from products;

-- 8. What is the total available on-hand quantity of diet pepsi?
SELECT p.description, SUM(wp.on_hand) FROM warehouse_product AS wp
JOIN products AS p ON p.id = wp.product_id
WHERE p.description = 'diet pepsi'
GROUP BY p.description;

-- 9. How much was the total cost for each order?
SELECT o.id, SUM(p.unit_price) FROM line_items AS l
JOIN orders AS o ON o.id = l.order_id
JOIN products AS p ON p.id = l.product_id
GROUP BY o.id
ORDER BY SUM(p.unit_price) DESC;

-- 10. How much has each customer spent in total?
SELECT c.first_name, c.last_name, SUM(p.unit_price) FROM line_items as l
JOIN orders AS o ON o.id = l.order_id
JOIN products AS p ON p.id = l.product_id
JOIN addresses AS a ON a.id = o.address_id
JOIN customers AS c ON c.id = a.customer_id
GROUP BY c.last_name, c.first_name
ORDER BY SUM(p.unit_price) DESC;

-- 11. How much has each customer spent in total? Customers who have spent $0 should still show up in the table. It should say 0, not NULL (research coalesce).
