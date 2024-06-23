use Trabajo5

--- Primero seleccionamos la base de datos para hacer  un primer vistazo / First we select the database to take a first look

select * from Hoja1

------------------------------------------------------------------------------------------------------

---Pudimos oberservar que hay dos columnas que contienen valores de tipo date pero que estan mal configuradas , entonces vamos a arreglarlo / We were able to observe that there are two columns that contain values ​​of type date but that are incorrectly configured, so we are going to fix it

alter table Hoja1
add  last_processed_time_2 date

alter table Hoja1
add  first_seen_2 date

update Hoja1
set last_processed_time_2=CONVERT(date,last_processed_time)

update Hoja1
set first_seen_2=CONVERT(date,first_seen)


--------------------------------------------------------------------------------------------------------------

-- Y por ultimo vamos a eliminar las columnas que ya no necesitamos en la base de datos / And finally we are going to eliminate the columns that we no longer need in the database

alter table Hoja1
drop column last_processed_time,first_seen

