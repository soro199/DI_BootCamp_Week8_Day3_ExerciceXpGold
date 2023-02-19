--How many stores there are, and in which city and country they are located.

SELECT COUNT(*) AS number_of_stores, ci.city, co.country
FROM store s
JOIN address a ON s.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
GROUP BY ci.city, co.country;

--How many hours of viewing time there are in total in each store – in other words, the sum of the length of every inventory item in each store.

SELECT s.store_id, SUM(f.length) AS total_viewing_time
FROM store s
JOIN inventory i ON s.store_id = i.store_id
JOIN film f ON i.film_id = f.film_id
GROUP BY s.store_id;

--Make sure to exclude any inventory items which are not yet returned. (Yes, even in the time of zombies there are people who do not return their DVDs)

SELECT s.store_id, SUM(f.length) AS total_viewing_time
FROM store s
JOIN inventory i ON s.store_id = i.store_id
JOIN film f ON i.film_id = f.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.return_date IS NOT NULL
GROUP BY s.store_id;

--A list of all customers in the cities where the stores are located.

SELECT c.customer_id, c.first_name, c.last_name, a.address, ci.city, co.country
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
WHERE ci.city IN (
    SELECT DISTINCT ci.city
    FROM store s
    JOIN address a ON s.address_id = a.address_id
    JOIN city ci ON a.city_id = ci.city_id
);

--A list of all customers in the countries where the stores are located.

SELECT c.customer_id, c.first_name, c.last_name, a.address, ci.city, co.country
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
WHERE co.country IN (
    SELECT DISTINCT co.country
    FROM store s
    JOIN address a ON s.address_id = a.address_id
    JOIN city ci ON a.city_id = ci.city_id
    JOIN country co ON ci.country_id = co.country_id
);

--Some people will be frightened by watching scary movies while zombies walk the streets. Create a ‘safe list’ of all movies which do not include the ‘Horror’ category, or contain the words ‘beast’, ‘monster’, ‘ghost’, ‘dead’, ‘zombie’, or ‘undead’ in their titles or descriptions… Get the sum of their viewing time (length).
	--Hint : use the CHECK contraint
	
SELECT SUM(film.length)
FROM film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
WHERE category.name != 'Horror' 
  AND NOT (film.title LIKE '%beast%' 
  OR film.title LIKE '%monster%' 
  OR film.title LIKE '%ghost%' 
  OR film.title LIKE '%dead%' 
  OR film.title LIKE '%zombie%' 
  OR film.description LIKE '%beast%' 
  OR film.description LIKE '%monster%' 
  OR film.description LIKE '%ghost%' 
  OR film.description LIKE '%dead%' 
  OR film.description LIKE '%zombie%' 
  OR film.description LIKE '%undead%');
  
-- For both the ‘general’ and the ‘safe’ lists above, also calculate the time in hours and days (not just minutes).

SELECT SUM(f.length) AS total_viewing_time, 
       SUM(f.length) / 60.0 AS total_viewing_time_hours, 
       SUM(f.length) / (60.0 * 24.0) AS total_viewing_time_days
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name != 'Horror' 
  AND NOT (f.title LIKE '%beast%' 
  OR f.title LIKE '%monster%' 
  OR f.title LIKE '%ghost%' 
  OR f.title LIKE '%dead%' 
  OR f.title LIKE '%zombie%' 
  OR f.description LIKE '%beast%' 
  OR f.description LIKE '%monster%' 
  OR f.description LIKE '%ghost%' 
  OR f.description LIKE '%dead%' 
  OR f.description LIKE '%zombie%' 
  OR f.description LIKE '%undead%');
