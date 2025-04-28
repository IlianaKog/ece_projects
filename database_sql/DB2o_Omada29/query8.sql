-- 8. poso kostise se ka9e xora synolika oles oi megales katastrofes 

-- INSERT INTO disaster_situation (RGDP, financial_aid, recovery_time, Total_cost, Plan_title, country_name, disaster_id)
-- VALUES
-- (1, 5000.00, 30, 200000.00, 'Recovery Plan A', 'CountryA', 1) ; 

SELECT c.country_name , SUM(ds.total_cost)  
FROM country c
JOIN disaster_situation  ds 
	USING( country_name)
 GROUP BY c.country_name ; 