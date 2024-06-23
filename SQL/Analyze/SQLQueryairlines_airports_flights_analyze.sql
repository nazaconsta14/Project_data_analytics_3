use Trabajo4

-- Seleccionamos las bases de datos con las que vamos a trabajar / We select the databases with which we are going to work

select * from airlines

select * from airports

select * from flights

-- Preguntas / Questions

/*

1. Encuentra los nombres de los aeropuertos que tienen vuelos con más de 60 minutos de retraso en la llegada. / Find the names of airports that have flights that are more than 60 minutes late in arrival.

2. Encuentra los vuelos que despegaron con un retraso menor a 5 minutos pero llegaron con más de 30 minutos de adelanto, incluyendo los nombres del aeropuerto de origen y de destino. / Find flights that took off with a delay of less than 5 minutes but arrived more than 30 minutes early, including the names of the origin and destination airport.

3. Para cada aerolínea, calcula el promedio de retraso en la salida y muestra solo aquellas aerolíneas cuyo promedio de retraso es mayor a 10 minutos. / For each airline, calculate the average departure delay and show only those airlines whose average delay is greater than 10 minutes.

4. Encuentra los vuelos que fueron cancelados, incluyendo los nombres del aeropuerto de origen y de destino y el nombre de la aerolínea. / Find the flights that were canceled, including the names of the origin and destination airport and the name of the airline.

5. Lista de los aeropuertos que han tenido vuelos originados desde ellos los 20 de cada mes, junto con el nombre de la ciudad y el estado. / List of airports that have had flights originating from them on the 20th of each month, along with the name of the city and state.

6. Para cada aeropuerto, encuentra el número total de vuelos que llegaron con retraso, mostrando el nombre del aeropuerto, la ciudad y el estado. / For each airport, find the total number of flights that arrived late, showing the airport name, city, and state.

7. Encuentra los vuelos que tienen una distancia mayor al promedio de todas las distancias de vuelos, mostrando los nombres del aeropuerto de origen y destino y el nombre de la aerolínea. / Finds flights that have a distance greater than the average of all flight distances, displaying the origin and destination airport names and the airline name.

8. Lista los vuelos que tienen un tiempo de vuelo (air_time) mayor al promedio para su respectiva aerolínea, incluyendo el nombre del aeropuerto de origen y de destino.  / Lists flights that have a flight time (air_time) greater than the average for their respective airline, including the name of the origin and destination airport.

9. Para cada día de la semana, encuentra el aeropuerto con el mayor número de vuelos salientes, mostrando el nombre del aeropuerto y la ciudad. / For each day of the week, it finds the airport with the highest number of outbound flights, displaying the airport name and city.


*/

--1

select 
    airp.airport,
    airp.city,
    airp.state,
    airp.country,
	total_delay.total_arrival_delay
from 
    airports airp
join 
    (
        select 
            f.destination_airport, 
            sum(f.arrival_delay) as total_arrival_delay
        from 
            flights f
        where 
            f.arrival_delay > 60 
        group by 
            f.destination_airport
    ) as total_delay 
on 
    airp.iata_code_airport = total_delay.destination_airport;




--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--2


select
count(*) as count_flight,
origin_airport,
destination_airport
from
airports
inner join airlines
on airports.country=airlines.country
inner join flights
on airlines.iata_code_airline=flights.iata_code_airline
where departure_delay<5 and arrival_delay<-30
group by origin_airport,destination_airport
order by count_flight desc

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--3

select 
    airl.airline,
	(round(avg(total_delay.sum_delay_departure_airline),2)) as  round_delay_departure_airline
from 
    airlines airl
join 
    (
        select 
            f.iata_code_airline, 
			sum(departure_delay) as sum_delay_departure_airline
        from 
            flights f
        where 
            f.departure_delay > 10
			group by 
            f.iata_code_airline
    ) as total_delay 
ON 
    airl.iata_code_airline = total_delay.iata_code_airline
group by  airl.airline
order by round_delay_departure_airline desc
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--4

select 
count(*) count_flight_cancelled,
airline,
origin_airport,
destination_airport
from airlines
inner join flights
on airlines.iata_code_airline=flights.iata_code_airline
where cancelled=1
group by airline,origin_airport,destination_airport


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--5

SELECT 
    airp.airport,
    airp.city,
    airp.state,
    total_count_flight.count_flight
FROM 
    airports airp
JOIN 
    (
        SELECT 
            f.Date_of_fly,
			f.destination_airport,
            f.origin_airport,
            COUNT(*) as count_flight
        FROM 
            flights as f
        WHERE 
            DAY(f.Date_of_fly) = 20  
        GROUP BY 
            f.Date_of_fly,
			f.destination_airport,
            f.origin_airport
       
    ) AS total_count_flight
ON 
    airp.iata_code_airport = total_count_flight.destination_airport;




--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--6


select 
    airp.airport,
	airp.state,
	airp.city,
	total_delay.count_delay_departure_airline
from 
    airports airp

join 
    (
        select 
            f.destination_airport, 
			count(*) as count_delay_departure_airline
        from 
            flights f
        where 
            f.departure_delay > 0
			group by 
            f.destination_airport
    ) as total_delay 
ON 
    airp.iata_code_airport = total_delay.destination_airport
order by total_delay.count_delay_departure_airline desc

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


---7

with AverageDistance as (
    select avg(distance) as avg_distance_flights
    from flights
    where distance > 0
)

-- 
select 
    airl.airline,
	total_distance.origin_airport,
	total_distance.destination_airport,
	total_distance.avg_distance_count
from 
    airlines airl
join 
    (
        select 
		    f.origin_airport,
			f.destination_airport,
			f.iata_code_airline,
            avg(f.distance) as avg_distance_count
        from 
            flights f
        where 
            f.distance > 0
        group by 
            f.origin_airport,f.destination_airport,f.iata_code_airline
    ) as total_distance 
on 
    airl.iata_code_airline = total_distance.iata_code_airline
-- 
WHERE 
    total_distance.avg_distance_count > (SELECT avg_distance_flights FROM AverageDistance)
ORDER BY 
    total_distance.avg_distance_count DESC;



--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- 8


with AverageAir_Time as (
    select 
	 f.iata_code_airline,
	avg(f.air_time) as avg_air_time
    from flights f
    group by  f.iata_code_airline
)

SELECT 
    f.origin_airport,
    f.destination_airport,
    f.air_time
FROM 
    flights f
JOIN 
    AverageAir_Time a ON f.iata_code_airline = a.iata_code_airline
WHERE 
    f.air_time > a.avg_air_time
order by air_time desc

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--9

with daily_flights as (
    select 
        f.day_of_week,
        f.origin_airport,
        count(*) as flight_count
    from flights f
    group by f.day_of_week, f.origin_airport
),
max_flights as (
    select 
        day_of_week,
        max(flight_count) as max_flight_count
    from daily_flights
    group by day_of_week
)
select 
    df.day_of_week,
    a.airport,
    a.city,
    df.flight_count as day_of_week_count
from daily_flights df
join max_flights mf
    on df.day_of_week = mf.day_of_week AND df.flight_count = mf.max_flight_count
JOIN airports a
    on df.origin_airport = a.iata_code_airport
order by df.day_of_week