-- 2. poies katastrofes eginan se asia kai posous nekros agnooumenous travtaismenous eixan 

SELECT d.disaster_name , d.deaths  , d.injured , d.missing 
FROM disaster d 
WHERE d.continent = 'Asia' ;