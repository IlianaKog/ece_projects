USE `student`;

SELECT COUNT(film_id)
FROM film
WHERE (rating = 'G' or rating = 'PG')