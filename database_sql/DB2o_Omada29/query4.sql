 -- 4. Poses gynaikes pethanan sto Chernobyl 
 
SELECT d.disaster_name ,COUNT(p.person_id)  
FROM disaster d
JOIN disaster_affected_person dap 
ON d.disaster_id = dap.disaster_id
JOIN person p ON dap.person_id = p.person_id
WHERE d.disaster_name = 'Chernobyl Disaster' AND p.gender = 'Female' ; 