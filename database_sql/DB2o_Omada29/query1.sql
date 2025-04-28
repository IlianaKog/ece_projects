USE world_disasters ; 

-- dummy examples -- 

SELECT * FROM disaster
WHERE start_date > '1700-07-01' ; 

SELECT d.Disaster_name , ds.Total_cost , ds.country_name  
FROM disaster d 
JOIN disaster_situation ds
ON d.disaster_id = ds.disaster_id ; 

-- 1. poies katastrofes eginan se asia kai evropi 

SELECT * 
FROM disaster d  
WHERE d.continent = 'Asia' OR d.continent = 'Europe' ; 