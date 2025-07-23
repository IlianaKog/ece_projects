use student;

SELECT sum(orderitem.Quantity)
from orderitem
join orders on orderitem.OrderId = orders.Id
where orders.TotalAmount > 10000