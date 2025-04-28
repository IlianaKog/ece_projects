-- 6. poia katastrofi eixe tous perissoterous nekrous 

SELECT *   
FROM disaster d 
WHERE deaths  = (
		SELECT MAX(deaths) 
        
        FROM disaster ) ; 