--Give me Discount for current free against total all fees
select *, 
      (select MAX(Adoption_Fee) from Adoptions) as MaxFee ,
	  (((select MAX(Adoption_Fee) from Adoptions) - Adoption_Fee ) * 100) /
	  (select MAX(Adoption_Fee) from Adoptions) as Discount
FROM Adoptions

--------------------------------------------------

select *,((MaxFee-Adoption_Fee)*100/MaxFee) as Discount from (
select * , MAX(Adoption_Fee) over () as MaxFee from Adoptions ) as X
--------------------------------------------------
--Give me max of Fee per species instead of all (Collereted Subquery)
select *,
        (
		select MAX(Adoption_Fee) 
		FROM Adoptions b
		where b.Species = a.Species -- group by species
		) as MaxFee
from Adoptions a
----------------------------------------------------------------
SELECT DISTINCT P.* 
FROM Persons P
INNER JOIN Adoptions A
on P.Email = A.Adopter_Email


SELECT  * 
FROM Persons  where Email in (select Adopter_Email from Adoptions)

-------------------------------------------------------------------------
--Find Animal that never adopted
select Name,Species from Animals  
except
select Name,Species from Adoptions
---------------------------------------------------------------------
--Find Breed that never adopted
select distinct Breed from Animals  A
LEFT OUTER JOIN Adoptions AD
ON A.Name = AD.Name AND AD.Species = A.Species
where AD.Name IS NULL or AD.Species IS NULL;
-----
select distinct Breed from Animals a where not EXISTS (
select name from  Adoptions ad  where ad.Name = a.Name and ad.Species = a.Species)
--------
select distinct Breed from Animals a where name not in (
select name from  Adoptions ad  where ad.Name = a.Name and ad.Species = a.Species)
-----------
--correct answer is :
--Find Animal that never adopted
select Name,Breed from Animals  
except
select a.Name,a.breed from Animals a inner join Adoptions ad 
on a.Name = ad.Name and a.Species = ad.Species
--where ad.Name is null or ad.Species is null
------------------------------------------------------------------


