use student;

SELECT SUM(orderdetails.quantityOrdered) 
from orders 
join orderdetails on orders.orderNumber = orderdetails.orderNumber
where orders.status = 'In Process' ;