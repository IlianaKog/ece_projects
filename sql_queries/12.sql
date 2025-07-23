use student;

SELECT Count(orders.orderNumber)
FROM customers
JOIN orders on orders.customerNumber = customers.customerNumber
where customers.country = 'USA' or customers.country = 'France';