use student;

SELECT COUNT(orders.CustomerId)
from customer 
join orders on customer.Id = orders.CustomerId
where customer.Country = 'Belgium' or customer.Country = 'France'