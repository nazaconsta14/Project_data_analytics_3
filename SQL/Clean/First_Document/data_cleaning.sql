use Trabajo2

-- Las bases de datos con las que vamos a trabajar / The databases with which we are going to work in this project : 

select * from categories
select * from customers
select * from products
select * from orders
select * from order_details
select * from products
select * from shippers



---- ANALIZAR LA BASE DE DATOS Y COMENZAR A MODIFICAR LOS  DATOS  / ANALYZE DATABASES AND START MODIFYING/FIXING THEM


---- Renombrar las columnas de la base de datos llamadas :"customer"  / Name the database columns called "customer"

EXEC sp_rename 'customers.column1', 'customerID', 'COLUMN';
EXEC sp_rename 'customers.column2', 'companyName', 'COLUMN';
EXEC sp_rename 'customers.column3', 'contactName', 'COLUMN';
EXEC sp_rename 'customers.column4', 'contactTitle', 'COLUMN';
EXEC sp_rename 'customers.column5', 'city', 'COLUMN';
EXEC sp_rename 'customers.column6', 'country', 'COLUMN';






--- Actualizar la base de datos llamada “customer”, eliminando los valores que están en el primer lugar / Update the database called "customer", eliminating the values ​​that are in the first place

UPDATE customers
SET companyName = 0 
WHERE companyName = (
    SELECT TOP 1 companyName
    FROM customers
);


UPDATE customers
SET contactName = 0 
WHERE contactName = (
    SELECT TOP 1 contactName
    FROM customers
);


UPDATE customers
SET contactTitle = 0 
WHERE contactTitle = (
    SELECT TOP 1 contactTitle
    FROM customers
);


UPDATE customers
SET city = 0 
WHERE city = (
    SELECT TOP 1 city
    FROM customers
);


UPDATE customers
SET country = 0 
WHERE country = (
    SELECT TOP 1 country
    FROM customers
);

--- Actualizar valores que estaban con 0, en la base de datos llamada "customer" / Update values ​​that were with 0, in the database called "customer"

update customers
set customerID=replace(customerID,0,'GUNS')

update customers
set companyName=replace(companyName,0,'Cenron')

update customers
set contactName=replace(contactName,0,'William Bruce Rose Jr')


update customers
set contactTitle=replace(contactTitle,0,'Owner')


update customers
set city=replace(city,0,'Indiana')


update customers
set country=replace(country,0,'USA')





--- Agregar nuevas tablas en la base de datos llamadas "orders" poniendo el formato correcto: Date / Add new tables in the database called "orders" putting the correct format: Date



alter table orders
add orderDate_2 Date;

alter table orders
add requiredDate_2 Date;


alter table orders
add shippedDate_2 Date;






update orders
set orderDate_2 = convert(Date,orderDate) ;


update orders
set requiredDate_2 = convert(Date,requiredDate) ;


update orders
set shippedDate_2 = convert(Date,shippedDate) ;




alter table orders
drop column orderDate,requiredDate,shippedDate




---- ELIMINAR VALORES NULOS DE LAS TABLAS DE EMPLOYEES Y ORDERS TABLES / REMOVE NULL VALUES FROM THE EMPLOYEES AND ORDERS TABLES

SELECT a.city, a.reportsTo, b.city, b.reportsTo,ISNULL(a.reportsTo,b.reportsTo)
FROM employees a
JOIN employees b 
   ON a.city = b.city
   and a.[employeeID]<>b.[employeeID]
WHERE a.reportsTo IS NULL;


SELECT a.employeeID, a.shippedDate_2, b.employeeID, b.shippedDate_2,isnull(a.shippedDate_2,b.shippedDate_2)
FROM orders a
JOIN orders b 
   ON a.employeeID = b.employeeID
   and a.[orderID]<>b.[orderID]
WHERE a.shippedDate_2 IS NULL;



update a
set reportsTo=isnull(a.reportsTo,b.reportsTo)
from employees a
join employees b
    on a.city=b.city
	and a.[employeeID] <> b.[employeeID]
where a.reportsTo is null


update a
set shippedDate_2=isnull(a.shippedDate_2,b.shippedDate_2)
from orders a
join orders b
    on a.customerID=b.customerID
	and a.[orderID] <> b.[orderID]
where a.shippedDate_2 is null





































