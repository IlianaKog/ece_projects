USE `student`;

SELECT F.film_id, FC.category_id, C.name, F.rating, count(F.film_id), count(F.film_id)
FROM film as F
JOIN film_category as FC on F.film_id = FC.film_id
JOIN category as C ON C.category_id = FC.category_id
WHERE (F.rating = 'G' and C.name = 'Comedy')