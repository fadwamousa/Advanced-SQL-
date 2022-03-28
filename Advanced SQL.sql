select *
FROM     Animals A 
         LEFT OUTER JOIN 
		 (Adoptions AD --all animals records
		 INNER JOIN Persons P  
		 on p.Email = ad.Adopter_Email)
		 on a.Name  = ad.Name and a.Species = ad.Species
-------------------------------------------------------------------------------
SELECT A.name,A.Species,Primary_Color,breed,Vaccination_Time , Vaccine
from Animals A
     LEFT JOIN 
	 (Vaccinations VC
	 INNER JOIN Staff s 
	 ON s.Email = vc.Email)
	 ON A.Name = VC.Name AND A.Species = VC.Species
-------------------------------------------------------
SELECT * FROM Animals 
WHERE 
    Species  =  'DOG' 
AND Breed    <> 'Bullmastiff' 
OR  Breed IS NULL
---------------------------------------------------------------------------
SELECT count(1) as NumberOfPersons,year(birth_Date) as BirthYear FROM Persons
group by year(birth_Date)
having count(*) > 2 
------------------------------------------------------------------
SELECT  name,Species FROM Vaccinations
GROUP BY name,Species

----------------------------------------------------------
SELECT a.Name,
       a.Species,
       MAX(Primary_Color) Color,
	   MAX(Breed) Breed,
	   count(VC.Vaccine) as Number_Vac
FROM   Animals A 
       LEFT JOIN Vaccinations VC
       on A.Name = VC.Name AND A.Species = VC.Species
WHERE  a.Species <> 'Rabbit' and (Vaccine <> 'Rabies' OR Vaccine IS NULL)
GROUP BY a.Name,a.Species
having max(Vaccination_Time) < '2019-10-01' OR max(Vaccination_Time) IS NULL
------------------------------------------------------------------------------------------------------------------------
SELECT name,
       Species,
	   Primary_Color,
	   Admission_Date,count(*) over() as TotalNumbers
FROM Animals
where year(Admission_Date) >= 2017 
ORDER BY Admission_Date asc


SELECT name,Species,Primary_Color,Admission_Date,
(select count(*) from Animals where year(Admission_Date) >= 2017 ) as TotalNumbers
FROM Animals
where year(Admission_Date) > 2017 
ORDER BY Admission_Date asc
----------------------------------------------------------------------------
SELECT name,
       Species,
	   Primary_Color,
	   Admission_Date,count(*) over(partition by Species) as TotalNumbers
FROM Animals
ORDER BY Admission_Date asc


SELECT name,Species,Primary_Color,Admission_Date,
(select count(*) from Animals a2 where a1.Species = a2.Species) as TotalNumbers
FROM Animals a1
ORDER BY Admission_Date asc
-----------------------------------------------------------------------
SELECT name,Species,Primary_Color,Admission_Date,
(select count(*) from Animals a2 where a1.Species = a2.Species and a2.Admission_Date < a1.Admission_Date) as TotalNumbers
FROM Animals a1
ORDER BY Admission_Date asc


SELECT name,
       Species,
	   Primary_Color,
	   Admission_Date,
	   count(*) over(partition by Species 
	                 order by Admission_Date 
					 RANGE BETWEEN unbounded preceding and '1 day' preceding) as TotalNumbers
FROM Animals
where  Species = 'Dog' 
and Admission_Date > '2017-08-01'
ORDER BY Admission_Date asc
-----------------------------------------------------------------------------------------
SELECT name,Species,Primary_Color,Admission_Date,
(select count(*) from Animals a2 
where a1.Species = a2.Species 
and   a2.Admission_Date < a1.Admission_Date
and Species = 'Dog' 
and Admission_Date > '2017-08-01') as TotalNumbers
FROM Animals a1
where  Species = 'Dog' 
and Admission_Date > '2017-08-01'
ORDER BY Admission_Date asc
----------------------------------------------------------------------------------------------------
GO 
WITH CTES
AS (
SELECT YEAR(Adoption_Date) YearAdoption,
       MONTH(Adoption_Date) monthAdoption,
	   sum(Adoption_Fee) as TotalFees
FROM Adoptions 
GROUP BY YEAR(Adoption_Date),MONTH(Adoption_Date))
select *,(TotalFees /sum(totalFees) over(partition by YearAdoption) * 100) as Precent from CTES
---------------------------------------------------------------------------------------------------------------
--THE DIFFERENC BETWEEN RANG AND ROWS WITH USING FILTER 
--------ROWS
select avg(Numbers) over(order by CurrentYear rows between 2 preceding and 1 preceding) as AvgNumbers
FROM(
SELECT count(*) as Numbers , year(Vaccination_Time) CurrentYear 
FROM Vaccinations 
where year(Vaccination_Time) <> 2018
group by year(Vaccination_Time)
) as SUB -- AvgNumbers for numbers of vaccination for each year

--------RANGE
select avg(Numbers) over(order by CurrentYear RANGE between 2 preceding and 1 preceding) as AvgNumbers
FROM(
SELECT count(*) as Numbers , year(Vaccination_Time) CurrentYear 
FROM Vaccinations 
where year(Vaccination_Time) <> 2018
group by year(Vaccination_Time)
) as SUB -- AvgNumbers for numbers of vaccination for each year
--------------------------------------------------------------------------------------------------------------
