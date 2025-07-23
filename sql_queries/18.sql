USE `student`;

SELECT COUNT(F.film_id)
FROM film AS F
JOIN film_actor AS FA ON F.film_id = FA.film_id
JOIN actor AS A ON A.actor_id = FA.actor_id
WHERE A.first_name = 'ADAM' and A.last_name = 'GRANT';