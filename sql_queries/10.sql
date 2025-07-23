use student;

SELECT COUNT(customerNumber)
FROM customers
where country = 'France' or country = 'Germany';