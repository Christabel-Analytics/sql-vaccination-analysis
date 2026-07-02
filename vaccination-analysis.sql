
-- select *
--from immuization_table

--select *
--from immunization_faility

--select child_name,record_id, vaccine,date_given, count(*)
--from immunization_table
--group by child_name, vaccine,date_given, record_id
--having count(*) >1


 
--update immunization_table
--set vaccine = upper(trim(vaccine));
--alter table immunization_table
--drop column  status

--age vaccinated
create view age_vaccinated as
select child_name, dob,vaccine,
date_part('month',age(date_given, DOB)) AS AGE_VACCINATED
from immunization_table;
 select *
 from age_VACCINATED


1-- vaccination distribution
 select vaccine,count(vaccine) vaccine_count
 from immunization_table
 group by vaccine
 order by vaccine desc

2-- vaccination trend over time
 SELECT
    vaccine,
    COUNT(vaccine) AS vaccine_count,
    date_part('year', date_given) AS year,
    ROW_NUMBER() OVER (
        PARTITION BY date_part('year', date_given)
        ORDER BY COUNT(vaccine) DESC
    ) AS rank_in_year
FROM immunization_table
GROUP BY
    vaccine,
    date_part('year', date_given)
ORDER BY
    year,
    vaccine_count DESC;
	
3--vaccination yearly trend

	select date_part('year', date_given) as year,
	count(vaccine) vaccine_count
	from immunization_table
	group by date_part('year', date_given)

	4--vaccination by state
	select i.state,count(it.vaccine)
	from immunization_table it
	join immunization_facility i
	on it.facility_id = i.facility_id
	group by i.state
	
	5--facility performance(top 10)
	select i.facility_name, count(it.vaccine) vaccine_count
	from immunization_table it
	join immunization_facility i
	on it.facility_id = i.facility_id
	group by i.facility_name 
	order by vaccine_count desc
	limit 10
	 
	
	6--on time vs delayed vaccination
	--BCG 0-1 MONTH
	--OPV BIRTH
	--PENTA 6 WEEKS
	--MEASLES 9 MONTH
	--HEP B BIRTH
	CREATE VIEW VACCINATION_STATUS AS
	SELECT CHILD_NAME, vaccine,
	CASE 
	WHEN VACCINE = 'BCG' AND AGE_VACCINATED <=0 THEN 'on time'
	when vaccine = 'opv' and age_vaccinated <=0 then 'on time'
	when vaccine ='pentavalent' and age_vaccinated =1 then 'on time'
	when vaccine ='measles' and age_vaccinated = 9 then 'on time'
	when vaccine ='HEP B'AND AGE_VACCINATED <=0 THEN 'on time'
	ELSE 'delayed'
	END AS VACCINATION_STATUS
	FROM AGE_VACCINATED
	
	7--COMPLETION VACCINATION STATUS
	select completion_status, COUNT(*) doses_received
	from(
	select child_name,
	CASE
	WHEN COUNT(*)>=9 THEN 'completed'
	when count(*)between 4 and 8 then 'in progress'
	else 'incompleted'
	end as completion_status
	FROM IMMUNIZATION_TABLE
	group by child_name)t
	group by  completion_status

	--total kpis
	-- 1 total children vaccinated
	select concat(child_name, dob) as child_key
	from immunization_table
	select count (distinct concat (record_id,child_name))
	from immunization_table

	2--total vaccine doses
	select count(vaccine)
	from immunization_table

	3-- top vaccinating sate
	select i.state
	from immunization_facility i
	join immunization_table it
	on i.facility_id = it.facility_id
	group by state
	order by count(it.vaccine) desc
	limit 1

4-- highest vaccine given
select vaccine
from immunization_table
group by vaccine
order by count(vaccine) desc
limit 1

--5 avg vaccine per child
select round(count(record_id)*0.1 /count(vaccine),1) as avg_vaccine
from immunization_table



	
	
	
	
	
	
	
