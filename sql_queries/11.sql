use student;

SELECT avg(creditLimit)
FROM customers
where country = 'USA' and not city = 'NYC';