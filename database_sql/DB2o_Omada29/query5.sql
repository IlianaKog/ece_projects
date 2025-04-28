-- 5 
-- INSERT INTO Building (street, street_number, postal_code, disasterSituationID, monument, damage_type, reconstruction_cost, constructed_year)
-- VALUES
-- ('Egnatia Lane', '789', '71456', 1, TRUE, 'MAJOR ISSUES', 75000.00, 1985) ; 

SELECT d.disaster_name , SUM(b.reconstruction_cost) , ds.total_cost   -- , c.country_name  
FROM disaster_situation ds 
JOIN disaster d 
	ON ds.disaster_id = d.disaster_id 
JOIN building b
	ON b.DisasterSituationID = ds.DisasterSituationID 
GROUP BY ds.disaster_id
ORDER BY ds.disaster_id ; 


