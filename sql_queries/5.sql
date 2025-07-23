use student;

SELECT COUNT(ID)
FROM customer
WHERE customer.Country = 'France' or Country = 'USA'