use student;

SELECT sum(orderitem.Quantity)
from orderitem
join orders on orderitem.OrderId = orders.Id
join product on product.Id = orderitem.ProductId
where orders.TotalAmount > 1000 and product.IsDiscontinued = true;