use Trabajo5

-- Seleccionamos la base de datos con la que vamos a trabajar / We select the database with which we are going to work

select * from Hoja1


-- Preguntas / Questions 

/*
1. �Cu�ntos trabajos requieren experiencia de nivel medio-senior y est�n relacionados con el sector de la salud en una ubicaci�n espec�fica? /  How many jobs require mid-senior level experience and are healthcare-related in a specific location?

2. �Cu�l es el n�mero de trabajos por pa�s y por nivel de trabajo? /  What is the number of jobs per country and per job level? 

3. �Cu�ntos puestos de trabajo requieren experiencia de nivel medio-senior y son para trabajar en el lugar (onsite)? /  How many jobs require mid-senior level experience and are they for onsite work?

4. �Cu�les son los trabajos que a�n no est�n siendo trabajados y que tienen un resumen y entidades reconocidas? / What are the jobs that are not yet being worked on and that have a summary and recognized entities?

5. �Cu�l es el n�mero de trabajos por ciudad y cu�les ciudades tienen m�s de 5 trabajos? / What is the number of jobs per city and which cities have more than 5 jobs?

6. �Cu�l es el trabajo con la fecha de primera vista m�s antigua y m�s reciente para cada empresa? / What is the job with the oldest and most recent first view date for each company?

7. �Qu� trabajos tienen una ubicaci�n y ciudad diferente? / What jobs have a different location and city?
 
8. �Cu�l es la lista de trabajos por tipo de trabajo (onsite, remoto, h�brido) y nivel de trabajo, ordenados por la fecha de �ltima vez procesada? / What is the list of jobs by job type (onsite, remote, hybrid) and job level, sorted by last processed date?

9. �Cu�l es la diferencia en d�as entre la fecha en que el trabajo fue visto por primera vez y la �ltima vez procesada? / What is the difference in days between the date the job was first viewed and the last time it was processed?

10. �Qu� trabajos coinciden con una lista espec�fica de t�tulos de trabajo y son de nivel "senior"? / Which jobs match a specific list of job titles and are "senior" level?
*/ 


--1.

select
sum(job_count) as sum_job_count,
company,
job_title
from(
    select 
	job_level,
	job_title,
	company,
	search_position,
	count(*) as job_count
    from Hoja1
    where job_level = 'Mid senior'
	group by job_title,job_level,company,search_position
	
)sub4
where job_title like '%health%'
group by company,job_title
order by sum_job_count desc



--2


select
count(job_link) cantidad_trabajo,
search_country,
job_level
from Hoja1
group by search_country,job_level
order by cantidad_trabajo desc


--3

select
count(job_link) job_count,
company
from Hoja1
where job_level = 'Mid senior' and job_type = 'Onsite'
group by company
order by job_count desc





--4

select
max(len(job_title)) as long_words_count,
job_title,
search_city
from Hoja1
group by job_title,search_city
order by long_words_count desc



--5
select
sum(city_count),
search_city
from(
    select 
	job_title,
	search_city,
	count(*) as city_count
    from Hoja1
    group by job_title,search_city
	having count(*) > 5
)sub4
group by search_city
order by sum(city_count) desc


--6
SELECT
job_title,
company,
MAX(last_processed_time_2) AS most_recent_date,
MIN(first_seen_2) AS oldest_date
FROM Hoja1;


--7

select
job_title,
company
from Hoja1
where job_location!=search_city



--8

select
job_title,
job_level,
job_type
from Hoja1
WHERE last_processed_time_2 = (SELECT MAX(last_processed_time_2) FROM Hoja1)



-- 9

select
job_title,
first_seen_2,
last_processed_time_2,
DATEDIFF(DAY, first_seen_2, last_processed_time_2) AS days_difference
from Hoja1
group by job_title,first_seen_2,last_processed_time_2
 


--10

SELECT job_title, company, COUNT(*) AS processing_count
FROM Hoja1
GROUP BY job_title, company
HAVING COUNT(*) > 1;