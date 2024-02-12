  
  use assingment;
  
  -- CALENDAR TABLE###############################
create view Calendar_table as
select	Datekey_opening,day(Datekey_opening) as Day, dayname(Datekey_opening) as Weekday_Name,
dayofweek(Datekey_opening)-1 as Weekday,month(Datekey_opening) as Month,
monthname(Datekey_opening) as Month_Name,quarter(Datekey_opening)as Quarter,
year(Datekey_Opening) as Year,DATE_FORMAT(Datekey_opening,"%m-%Y") as Month_Year,
case when month(Datekey_opening) <=3 then month(Datekey_opening)+9
else month(Datekey_opening)-3
end as Financial_Month,
case when quarter(Datekey_opening)>1 then quarter(Datekey_opening)-1
else quarter(Datekey_opening)+3
end as Financial_QTR
 from MYTABLE;

SELECT * FROM CALENDAR_TABLE;


-- Create buckets based on Average Price of reasonable size and find out how many resturants falls in each buckets
 create view rates as
 SELECT A.RestaurantId as No_of_Resturants, A.CURRENCY,A.Average_Cost_for_two, B.USD_Rate,
 (A.Average_Cost_for_two * B.USD_Rate) AS STD_USD,
CASE WHEN (A.Average_Cost_for_two * B.USD_Rate) BETWEEN 0 AND 10 THEN "0 - 10"
WHEN (A.Average_Cost_for_two * B.USD_Rate) BETWEEN 10 AND 20 THEN "10 - 20"
WHEN (A.Average_Cost_for_two * B.USD_Rate) BETWEEN 20 AND 30 THEN "20 - 30"
WHEN (A.Average_Cost_for_two * B.USD_Rate) BETWEEN 30 AND 40 THEN "30 - 40"
WHEN (A.Average_Cost_for_two * B.USD_Rate) BETWEEN 40 AND 50 THEN "40 - 50"
ELSE "ABOVE 50"
END AS COST_BUCKET
FROM MYTABLE A JOIN CURRENCY B ON A.Currency = B.Currency;

select * from rates; 


-- Numbers of Resturants opening based on Year , Quarter , Month
DELIMITER //
CREATE PROCEDURE Year_Months(IN P_year int(50),in P_QTR varchar(50))     		 
BEGIN
SELECT year(Datekey_Opening)as Year,monthname(Datekey_Opening) as Month_Name, 
case
when quarter(Datekey_Opening) =1 then "Q1"
 when quarter(Datekey_Opening) =2 then "Q2"
 when quarter(Datekey_Opening) =3 then "Q3"
 else "Q4"
 end as QTR,
 count(RestaurantId) as No_of_Resturant FROM MYTABLE 
WHERE year(Datekey_Opening) = P_year && quarter(Datekey_Opening) = P_QTR
group by year,Month_Name,QTR ;
END//

call Year_Months(2010,4);    ### call Year_month(mention year, mention quarter like 1,2,3,4) 


-- Find the Numbers of Resturants based on City and Country.
delimiter //
create procedure City_country(in P_country int)
begin
select A.CountryCode AS COUNTRY_CODE,B.Countryname AS COUNTRY,A.CITY AS CITIES, COUNT(A.RestaurantId)as No_of_Resturant 
FROM mytable A JOIN COUNTRY B
ON A.CountryCode = B.country_id WHERE A.CountryCode = P_COUNTRY
GROUP BY COUNTRY,CITIES,COUNTRY_CODE;
END//																					

CALL City_country(214);
 						## MENTIONED THE COUNTRY CODE FROM BELOW
##  1-India  	14-Australia	30-Brazil	 37-Canada   94-Indonasia	 148-New Zealand	 162-Phillipines	  166-Qatar	   
##  184-Singapore	 189-South Africa	   191-Sri lanka	208-Turkey	   214-UAE	   215-UK	  216-US


-- Percentage of Resturants based on "Has_Table_booking"
select 
concat((((select count(RESTAURANTID) from mytable where has_table_booking='yes')/count(RESTAURANTID))*100),'%') as Has_table_booking
from mytable;

-- Percentage of Resturants based on "Has_Online_delivery"
select 
concat((((select count(RESTAURANTID) from mytable where Has_Online_delivery='yes')/count(RESTAURANTID))*100),'%') as Has_online_delivery
from mytable;

-- Count of Resturants based on  Ratings
SELECT  
case when rating between 0 and 1 then "0-1"
when rating between 1 and 2 then "1-2"
when rating between 02 and 3 then "2-3"
else "3-4"
end as Rating_Bucket
,COUNT(RESTAURANTID)as No_of_Resturant from mytable
group by Rating_Bucket
order by Rating_Bucket;

-- Count of Resturants based on Cuisines
select Cuisines,count(RESTAURANTID) as No_of_Restuarant from mytable
group by Cuisines
order by No_of_Restuarant desc ;