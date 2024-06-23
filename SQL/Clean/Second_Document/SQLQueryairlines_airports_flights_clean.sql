use Trabajo4

--- Como primer paso vamos seleccionar las bases de datos con las que vamos a encontrar / As a first step we are going to select the databases with which we are going to find

select * from airlines
select * from airports
select * from flights

-- Primero nos fijamos las columnas de las bases de datos que contienen valores nulos / First we look at the database columns that contain null values

select * from airports where latitude is null  -- tambien longitude contiene valores nulos / also longitud contains nulls values

select * from flights where arrival_delay is null -- tail_number , departure_time , departure_delay , taxi_out , wheels_off , elapsed_time , air_time , wheels_on , taxi_in , arrival_time , arrival_delay

----------------------------------------------------------------------------

--- Primero vamoms a solucionar los valos nulos de la base de datos "airports" / First let's solve the null values ​​in the "airports" database




SELECT a.country, a.latitude, b.country, b.latitude,isnull(a.latitude,b.latitude)
FROM airports a
JOIN airports b 
   ON a.country = b.country
   and a.[iata_code_airport]<>b.[iata_code_airport]
WHERE a.latitude IS NULL;

---latitude

update a
set latitude=isnull(a.latitude,b.latitude)
from airports a
join airports b
    on a.country=b.country
	and a.[iata_code_airport] <> b.[iata_code_airport]
where a.latitude is null
----------------------------------------------------------------------------

SELECT a.country, a.latitude, b.country, b.latitude,isnull(a.longitude,b.longitude)
FROM airports a
JOIN airports b 
   ON a.country = b.country
   and a.[iata_code_airport]<>b.[iata_code_airport]
WHERE a.longitude IS NULL;

----longitude

update a
set longitude=isnull(a.longitude,b.longitude)
from airports a
join airports b
    on a.country=b.country
	and a.[iata_code_airport] <> b.[iata_code_airport]
where a.longitude is null

----------------------------------------------------------------------------


---- Ahora vamos a solucionar los valores nulos de la base de datos llamada "flights" / Then we are going to solve the null values ​​in the "flights" database



SELECT a.year, a.tail_number, b.year, b.tail_number,isnull(a.tail_number,b.tail_number)
FROM flights a
JOIN flights b 
   ON a.year = b.year
   
WHERE a.tail_number IS NULL;

---tail_number
update a
set tail_number=isnull(a.tail_number,b.tail_number)
from flights a
join flights b
    on a.year=b.year
	
where a.tail_number is null


--departure_time

update a
set departure_time=isnull(a.departure_time,b.departure_time)
from flights a
join flights b
    on a.month=b.month
	
where a.departure_time is null

---departure_delay
update a
set departure_delay=isnull(a.departure_delay,b.departure_delay)
from flights a
join flights b
    on a.year=b.year
	
where a.departure_delay is null

---taxi_out
update a
set taxi_out=isnull(a.taxi_out,b.taxi_out)
from flights a
join flights b
    on a.month=b.month
	
where a.taxi_out is null


---wheels_off
update a
set wheels_off=isnull(a.wheels_off,b.wheels_off)
from flights a
join flights b
    on a.month=b.month
	
where a.wheels_off is null


----elapsed_time
update a
set elapsed_time=isnull(a.elapsed_time,b.elapsed_time)
from flights a
join flights b
    on a.year=b.year
	
where a.elapsed_time is null


----air_time
update a
set air_time=isnull(a.air_time,b.air_time)
from flights a
join flights b
    on a.year=b.year
	
where a.air_time is null


--wheels_on
update a
set wheels_on=isnull(a.wheels_on,b.wheels_on)
from flights a
join flights b
    on a.month=b.month
	
where a.wheels_on is null

 

--taxi_in
update a
set taxi_in=isnull(a.taxi_in,b.taxi_in)
from flights a
join flights b
    on a.month=b.month
	
where a.taxi_in is null


---arrival_time
update a
set arrival_time=isnull(a.arrival_time,b.arrival_time)
from flights a
join flights b
    on a.month=b.month
	
where a.arrival_time is null


--arrival_delay
update a
set arrival_delay=isnull(a.arrival_delay,b.arrival_delay)
from flights a
join flights b
    on a.year=b.year
	
where a.arrival_delay is null

------------------------------------------------------------------

-- Tenemos que crear una nueva columna en la base de datos flights para almacenar los datos que contienen fechas / We have to create a new column in the flights database to store the data containing dates


alter table flights add Date_of_fly dTE;

update flights
set Date_of_fly = datefromparts(year, month, day);


-------------------------------------------------------------------

--Eliminamos columnas de la base de datos "flights" que ya no necesitamos / We delete columns from the "flights" database that we no longer need

alter table flights
drop column year,month,day