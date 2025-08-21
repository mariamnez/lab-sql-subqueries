USE sakila;
SELECT COUNT(*) AS copies_in_inventory
FROM inventory
WHERE film_id = (SELECT film_id FROM film WHERE title = 'Hunchback Impossible');
SELECT title, length
FROM film
WHERE length > (SELECT AVG(length) FROM film)
ORDER BY length DESC, title;
SELECT a.actor_id, a.first_name, a.last_name
FROM actor a
WHERE a.actor_id IN (
  SELECT fa.actor_id
  FROM film_actor fa
  WHERE fa.film_id = (SELECT film_id FROM film WHERE title = 'Alone Trip')
)
ORDER BY a.last_name, a.first_name;
SELECT f.film_id, f.title
FROM film f
WHERE f.film_id IN (
  SELECT fc.film_id
  FROM film_category fc
  WHERE fc.category_id = (SELECT category_id FROM category WHERE name = 'Family')
)
ORDER BY f.title;
SELECT first_name, last_name, email
FROM customer
WHERE address_id IN (
  SELECT address_id FROM address
  WHERE city_id IN (
    SELECT city_id FROM city
    WHERE country_id = (SELECT country_id FROM country WHERE country = 'Canada')
  )
)
ORDER BY last_name, first_name;
SELECT cu.first_name, cu.last_name, cu.email
FROM customer cu
JOIN address a ON cu.address_id = a.address_id
JOIN city ci   ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
WHERE co.country = 'Canada'
ORDER BY cu.last_name, cu.first_name;
SELECT f.film_id, f.title
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
WHERE fa.actor_id = (
  SELECT actor_id
  FROM (
    SELECT actor_id, COUNT(*) AS films
    FROM film_actor
    GROUP BY actor_id
    ORDER BY films DESC
    LIMIT 1
  ) t
)
ORDER BY f.title;
SELECT DISTINCT f.film_id, f.title
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f      ON i.film_id = f.film_id
WHERE r.customer_id = (
  SELECT customer_id
  FROM (
    SELECT customer_id, SUM(amount) AS total_spent
    FROM payment
    GROUP BY customer_id
    ORDER BY total_spent DESC
    LIMIT 1
  ) t
)
ORDER BY f.title;
SELECT customer_id AS client_id,
       ROUND(SUM(amount), 2) AS total_amount_spent
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > (
  SELECT AVG(total_spent) 
  FROM (
    SELECT SUM(amount) AS total_spent
    FROM payment
    GROUP BY customer_id
  ) totals
)
ORDER BY total_amount_spent DESC;
