-- 3. posoi anthropoi ano ton 30 (change it) pethanan apo katastrofi chernobyl 

-- INSERT INTO disaster_affected_person (disaster_id, person_id)
-- VALUES
-- (1, 2), 
-- (1, 3), 
-- (1, 4), 
-- (1, 5), 
-- (1, 6), 
-- (1, 7), 
-- (1, 8) ;  


SELECT d.disaster_name ,COUNT(p.person_id)  
FROM disaster d
JOIN disaster_affected_person dap 
ON d.disaster_id = dap.disaster_id
JOIN person p ON dap.person_id = p.person_id
WHERE d.disaster_name = 'Chernobyl Disaster' AND p.age > 20 ; 