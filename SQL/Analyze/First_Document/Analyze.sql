use Trabajo2


--- Preguntas / Questions

/*

1. Productos más vendidos por categoría: ¿Cuáles son los productos más vendidos en cada categoría? / Best-selling products by category: What are the best-selling products in each category?

2. Cantidad de productos en inventario por proveedor: ¿Cuántos productos tiene cada proveedor en inventario? / Quantity of products in inventory per supplier: How many products does each supplier have in inventory?

3. Ventas por país: ¿Cuáles son las ventas totales realizadas en cada país? / Sales by country: What is the total sales made in each country?

4 . ¿Cuáles son las ventas totales de cada vendedor, excluyendo las ventas a Alemania? / What are the total sales of each seller, excluding sales to Germany?

5 . Encuentre el costo total del flete para cada transportista. Ordene los resultados por costo total de flete en orden ascendente / Find the total freight cost for each carrier. Sort the results by total freight cost in ascending order.

6. Ventas totales por categoría: ¿Cuáles son las ventas totales realizadas en cada categoría? / Total sales by category: What is the total sales made in each category?

7. Proveedores con productos más vendidos: ¿Cuáles son los proveedores cuyos productos han sido más vendidos? / Suppliers with best-selling products: Which are the suppliers whose products have been best sellers?

8. Clientes con mayor gasto total: ¿Qué clientes han gastado más en total? / Customers with the highest total spending: Which customers have spent the most in total?


*/


--1 


--- Vamos a usar las bases de datos : categories - order_details - products / Let's use the databases : categories - order_details - products


SELECT sub.Total_Sales, c.categoryName, p.productName
FROM (
    SELECT SUM(od.quantity) AS Total_Sales, p.categoryID, od.productID
    FROM order_details od
    INNER JOIN products p ON od.productID = p.productID
    GROUP BY p.categoryID, od.productID
) AS sub
INNER JOIN products p ON sub.productID = p.productID
INNER JOIN categories c ON p.categoryID = c.categoryID
WHERE sub.Total_Sales = (
    SELECT MAX(Total_Sales)
    FROM (
        SELECT SUM(od.quantity) AS Total_Sales
        FROM order_details od
        INNER JOIN products p ON od.productID = p.productID
        WHERE p.categoryID = sub.categoryID
        GROUP BY od.productID
    ) AS sub_sub
)
ORDER BY c.categoryName, sub.Total_Sales DESC;

----------------------------------------------------


---2 


--- Vamos a usar las bases de datos : products - order_details - orders - employees  / Let's use the databases : products - order_details - orders - employees


SELECT e_2.employeeID, COUNT(sub.productID) AS Count_ProductID
FROM (
    SELECT count(*) AS Count_ProductID, p_2.productID
    FROM order_details od
    INNER JOIN products p_2 ON od.productID = p_2.productID
    GROUP BY p_2.productID
) AS sub
INNER JOIN order_details od_2 ON od_2.productID = sub.productID
INNER JOIN orders o_2 ON o_2.orderID = od_2.orderID
INNER JOIN employees e_2 ON e_2.employeeID = o_2.employeeID
GROUP BY e_2.employeeID
ORDER BY Count_ProductID DESC;


-----------------------------------------------------


--- 3


--- Vamos a usar las bases de datos : customers - orders - order_details / Let's use the databases : customers - orders - order_details



select 
country,
sum(quantity) as Total_Sales
from orders
inner join customers
on orders.customerID = customers.customerID
inner join order_details
on orders.orderID = order_details.orderID
group by country
order by  Total_Sales desc



-----------------------------------------------------------------------



--- 4 


--- Vamos a usar las bases de datos : customers - orders - order_details  / Let's use the databases : customers - orders - order_details



SELECT sub.Sales,customers.customerID,customers.contactName
FROM (SELECT SUM((order_details.unitPrice*order_details.quantity)-(order_details.discount))  AS Sales, orders.customerID
    FROM order_details 
    INNER JOIN orders  ON order_details.orderID = orders.orderID
    GROUP BY orders.customerID
    
) AS sub
INNER JOIN customers  ON customers.customerID = sub.customerID
where customers.country <>  'Germany'
order by sub.Sales desc


-----------------------------------------------------------------------


---5


--- Vamos a usar las bases de datos : shippers - orders - order_details / Let's use the databases : shippers - orders - order_details


SELECT sub.Total_Freight,sub.Count_ID,ss.companyName
FROM (SELECT SUM(o.freight)  AS Total_Freight,count(*) Count_ID ,s.shipperID
    FROM orders o
    INNER JOIN shippers s ON o.shipperID = s.shipperID
    GROUP BY s.shipperID
    
) AS sub
INNER JOIN shippers ss  ON ss.shipperID=sub.shipperID
order by sub.Total_Freight desc





-----------------------------------------------------------------------


---- 6 

-- Vamos a usar las bases de datos : categories - products - order_details    / Let's use the databases : categories - products - order_details 


SELECT sub.Total_Sales, c.categoryName
FROM (
    SELECT SUM(od.quantity) AS Total_Sales, p.categoryID, od.productID
    FROM order_details od
    INNER JOIN products p ON od.productID = p.productID
    GROUP BY p.categoryID, od.productID
) AS sub
INNER JOIN products p ON sub.productID = p.productID
INNER JOIN categories c ON p.categoryID = c.categoryID
WHERE sub.Total_Sales = (
    SELECT MAX(Total_Sales)
    FROM (
        SELECT SUM(od.quantity) AS Total_Sales
        FROM order_details od
        INNER JOIN products p ON od.productID = p.productID
        WHERE p.categoryID = sub.categoryID
        GROUP BY od.productID
    ) AS sub_sub
)
ORDER BY c.categoryName, sub.Total_Sales DESC;

-----------------------------------------------------------------------







----7 

-- Vamos a usar las bases de datos : employees - orders - order_details    / Let's use the databases : employees - orders - order_details 



SELECT sub.Sales,e2.employeeName,sub.Total_Product_ID
FROM (SELECT SUM((od.unitPrice*od.quantity)-(od.discount))  AS Sales,count(od.productID) as Total_Product_ID ,e.employeeName
    FROM employees e
    INNER JOIN orders o ON o.employeeID = e.employeeID
	inner join order_details od on od.orderID=o.orderID
    GROUP BY e.employeeName
    
) AS sub
INNER JOIN employees e2  ON e2.employeeName=sub.employeeName
order by sub.Sales desc

-----------------------------------------------------------------------


---- 8


-- Vamos a usar las bases de datos : customers - orders - order__details  / Let's use the databases : customers - orders - order__details




--- Aca mostramos a todos los clientes con sus ventas / here we show all clients with sales



SELECT sub.Sales,customers.customerID,customers.contactName
FROM (SELECT SUM((order_details.unitPrice*order_details.quantity)-(order_details.discount))  AS Sales, orders.customerID
    FROM order_details 
    INNER JOIN orders  ON order_details.orderID = orders.orderID
    GROUP BY orders.customerID
    
) AS sub
INNER JOIN customers  ON customers.customerID = sub.customerID
order by sub.Sales desc



--- Y aca limitamos la busqueda a 10 registros / and here we limit the records to the 10 best


SELECT  top 10 sub.Sales,customers.customerID,customers.contactName
FROM (SELECT SUM(order_details.quantity*order_details.unitPrice-order_details.discount) AS Sales, orders.customerID
    FROM order_details 
    INNER JOIN orders  ON order_details.orderID = orders.orderID
    GROUP BY orders.customerID
    
) AS sub
INNER JOIN customers  ON customers.customerID = sub.customerID
order by sub.Sales desc
