--Get a list of all rentals which are out (have not been returned). How do we identify these films in the database?

SELECT * FROM rental WHERE return_date IS NULL;

--Get a list of all customers who have not returned their rentals. Make sure to group your results.

SELECT c.customer_id, c.first_name, c.last_name, COUNT(*) as num_rentals_out
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
WHERE r.return_date IS NULL
GROUP BY c.customer_id, c.first_name, c.last_name;

--Get a list of all the Action films with Joe Swank.
	--Before you start, could there be a shortcut to getting this information? Maybe a view?
		--R: S'il existe une vue existante qui fournit ces informations, nous n'aurions qu'à interroger la vue au lieu de joindre les tables et de filtrer les résultats.

SELECT f.film_id, f.title
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Action' AND a.first_name = 'Joe' AND a.last_name = 'Swank';
