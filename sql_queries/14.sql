use student;

SELECT SUM(orderdetails.quantityOrdered) 
from orders 
join orderdetails on orders.orderNumber = orderdetails.orderNumber
join products on products.productCode = orderdetails.productCode
where orders.status = 'Shipped' and products.productLine = 'Vintage Cars' ;
