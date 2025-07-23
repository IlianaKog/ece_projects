USE `student`;

SELECT max(F.length)
FROM film AS F
JOIN film_category AS FC ON F.film_id = FC.film_id
JOIN category AS C ON FC.category_id = C.category_id
WHERE C.name = 'Action';


WITH table1
AS (
    SELECT F.film_id, F.length, FC.category_id 
    FROM film AS F
    JOIN film_category AS FC
    ON F.film_id = FC.film_id
) 

SELECT max(R1.length)
FROM table1 as R1
JOIN category as C
ON R1.category_id = C.category_id
WHERE (C.name = 'Action');





