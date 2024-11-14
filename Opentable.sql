-- 1.Top 5 restaurants by rating
SELECT rest_name, rating
FROM chicago
ORDER BY rating DESC
LIMIT 5;

-- 2.Top 5 restaurants by food
SELECT rest_name, food
FROM chicago
ORDER BY food 
LIMIT 5;

--3.Restaurants with more than 1000 reviews and a rating above 4.7
SELECT rest_name, number_of_reviews, rating
FROM chicago
WHERE number_of_reviews > 1000 AND rating > 4.7;

-- 4.Find restaurants with reviews containing the word "amazing" in their comments
SELECT rest_name, comments
FROM chicago
WHERE comments ILIKE '%amazing%';

--5.Find the restaurant with the longest description in the 'about_rest' column
SELECT rest_name, LENGTH(about_rest) AS description_length
FROM chicago
ORDER BY description_length DESC
LIMIT 1;

--6.Using EXISTS: Find restaurants with no reviews.
SELECT rest_name, rating
FROM chicago c
WHERE NOT EXISTS (
    SELECT 1
    FROM chicago sub
    WHERE sub.rest_name = c.rest_name
      AND sub.number_of_reviews > 1
);

-- 7. Find restaurants where food, service, and ambience are all above 4.7
SELECT rest_name, food, service, ambience
FROM chicago
WHERE food > 4.7 AND service > 4.7 AND ambience > 4.7;

-- 8. Rank restaurants by number of reviews using window function
SELECT rest_name, number_of_reviews,
RANK() OVER (ORDER BY number_of_reviews DESC) AS review_rank
FROM chicago
limit 10;

--9.Restaurants with the lowest value rating per food type
WITH RankedRestaurants AS (
    SELECT rest_name, food_type, value,
           RANK() OVER (PARTITION BY food_type ORDER BY value ASC) AS rank
    FROM chicago
)
SELECT rest_name, food_type, value
FROM RankedRestaurants
WHERE rank = 1;

-- 10.Find restaurants whose comments contain the word 'overpriced'
SELECT rest_name, comments
FROM chicago
WHERE comments ILIKE '%overpriced%';


--11. Average rating and total number of reviews per price range (coupon)
SELECT coupon, AVG(rating) AS avg_rating, SUM(number_of_reviews) AS total_reviews
FROM chicago
GROUP BY coupon
ORDER BY avg_rating DESC;


--12.Restaurants with Above-Average Service and Ambience Ratings
WITH avg_ratings AS (
    SELECT food_type, AVG(service) AS avg_service, AVG(ambience) AS avg_ambience
    FROM chicago
    GROUP BY food_type
)
SELECT r.rest_name, r.food_type, r.service, r.ambience
FROM chicago r
JOIN avg_ratings ar ON r.food_type = ar.food_type
WHERE r.service > ar.avg_service AND r.ambience > ar.avg_ambience;

-- 13. Find restaurants that have the same rating across food, service, ambience, and value
SELECT rest_name, rating, food, service, ambience, value
FROM chicago
WHERE food = service AND service = ambience AND ambience = value AND value = rating;

-- 14.Find the top 5 most popular food types based on number of reviews, and average rating for each
SELECT food_type, SUM(number_of_reviews) AS total_reviews, AVG(rating) AS avg_rating
FROM chicago
GROUP BY food_type
ORDER BY total_reviews DESC
LIMIT 5;


--15. Using CASE: Categorize restaurants based on their rating.
SELECT rest_name, rating,
       CASE 
           WHEN rating >= 4.5 THEN 'Excellent'
           WHEN rating >= 4.0 THEN 'Good'
           ELSE 'Average'
       END AS rating_category
FROM chicago;

--16. Using ARRAY_AGG: Aggregate all restaurants with the same food type into a list.
SELECT food_type, ARRAY_AGG(rest_name) AS restaurant_list
FROM chicago
GROUP BY food_type;

--17. Using STRING_AGG: Concatenate restaurant names of a specific food type into a single string.
SELECT food_type, STRING_AGG(rest_name, ', ') AS restaurant_names
FROM chicago
GROUP BY food_type;

--18.Using CTE (Common Table Expression): Find restaurants with a rating higher than the average rating of all Mediterranean restaurants.
WITH avg_mediterranean_rating AS (
    SELECT AVG(rating) AS avg_rating
    FROM chicago
    WHERE food_type = 'Mediterranean'
)
SELECT rest_name, rating
FROM chicago, avg_mediterranean_rating
WHERE rating > avg_mediterranean_rating.avg_rating
  AND food_type = 'Mediterranean';

--19. Using DENSE_RANK(): Get the rankings of restaurants with equal ratings.
SELECT rest_name, rating, 
       DENSE_RANK() OVER (ORDER BY rating DESC) AS rating_rank
FROM chicago;

/* 20.Using COUNT() with FILTER: Count the number of high-rated restaurants (rating ≥ 4.5) and 
low-rated restaurants (rating < 4.5) in a single query.*/

SELECT 
    COUNT(*) FILTER (WHERE rating >= 4.5) AS high_rated_count,
    COUNT(*) FILTER (WHERE rating < 4.5) AS low_rated_count
FROM chicago;



-- 21.Find Restaurants with the Highest Service Rating in Each Food Type (Subquery)
SELECT rest_name, food_type, service
FROM chicago R1
WHERE service = (
    SELECT MAX(service)
    FROM chicago R2
    WHERE R1.food_type = R2.food_type
);


-- 22. List restaurants from all datasets with the same name.
SELECT la.rest_name 
FROM Los_angeles la
JOIN new_york ny ON la.rest_name = ny.rest_name
JOIN san_diego sd ON la.rest_name = sd.rest_name
JOIN san_francisco sf ON la.rest_name = sf.rest_name
JOIN chicago ch ON la.rest_name = ch.rest_name;

--23. Find restaurants that offer 'Mediterranean' cuisine in San Francisco and New York.
SELECT rest_name, 'San Francisco' AS city
FROM San_Francisco
WHERE food_type = 'Mediterranean'
UNION All
SELECT rest_name, 'New York' AS city
FROM New_York
WHERE food_type = 'Mediterranean';

--24.Calculate the average value score for each cuisine type across all datasets.
SELECT food_type, AVG(value) AS avg_value
FROM (
  SELECT food_type, value FROM Los_Angeles
  UNION ALL
  SELECT food_type, value FROM New_York
  UNION ALL
  SELECT food_type, value FROM San_Diego
  UNION ALL
  SELECT food_type, value FROM San_Francisco
  UNION ALL
  SELECT food_type, value FROM Chicago
) AS combined
GROUP BY food_type;


--25. Find the restaurant with the highest combined score of food, service, and ambience in all datasets.
SELECT rest_name, city, (food + service + ambience) AS total_score 
FROM (
  SELECT rest_name, 'Los Angeles' AS city, food, service, ambience FROM Los_Angeles
  UNION ALL
  SELECT rest_name, 'New York' AS city, food, service, ambience FROM New_York
  UNION ALL
  SELECT rest_name, 'San Diego' AS city, food, service, ambience FROM San_Diego
  UNION ALL
  SELECT rest_name, 'San Francisco' AS city, food, service, ambience FROM San_Francisco
  UNION ALL
  SELECT rest_name, 'Chicago' AS city, food, service, ambience FROM Chicago
) AS combined
ORDER BY total_score DESC
LIMIT 5;


-- 26.Get the number of restaurants offering 'Asian' cuisine across all datasets.
SELECT city, COUNT(*) AS asian_cuisine_restaurants
FROM (
  SELECT rest_name, 'Los Angeles' AS city FROM Los_Angeles WHERE food_type = 'Asian'
  UNION ALL
  SELECT rest_name, 'New York' AS city FROM New_York WHERE food_type = 'Asian'
  UNION ALL
  SELECT rest_name, 'San Diego' AS city FROM San_Diego WHERE food_type = 'Asian'
  UNION ALL
  SELECT rest_name, 'San Francisco' AS city FROM San_Francisco WHERE food_type = 'Asian'
  UNION ALL
  SELECT rest_name, 'Chicago' AS city FROM Chicago WHERE food_type = 'Asian'
) AS combined
GROUP BY city;


-- 27.Find the Restaurant with the Highest Rating in Each Cuisine Type
WITH RankedRestaurants AS (
    SELECT 
        rest_name, 
        food_type, 
        rating, 
        RANK() OVER (PARTITION BY food_type ORDER BY rating DESC) AS rank
    FROM (
        SELECT rest_name, food_type, rating FROM Los_Angeles
        UNION ALL
        SELECT rest_name, food_type, rating FROM San_Francisco
        UNION ALL
        SELECT rest_name, food_type, rating FROM San_Diego
        UNION ALL
        SELECT rest_name, food_type, rating FROM Chicago
        UNION ALL
        SELECT rest_name, food_type, rating FROM New_York
    ) AS combined
)
SELECT rest_name, food_type, rating
FROM RankedRestaurants
WHERE rank = 1;

-- 28.  Count Total Restaurants by City
SELECT 
    'Los Angeles' AS city, COUNT(*) AS total_restaurants FROM Los_Angeles
UNION ALL
SELECT 
    'San Francisco', COUNT(*) FROM San_Francisco
UNION ALL
SELECT 
    'San Diego', COUNT(*) FROM San_Diego
UNION ALL
SELECT 
    'Chicago', COUNT(*) FROM Chicago
UNION ALL
SELECT 
    'New York', COUNT(*) FROM New_York;

-- 29.Find the Restaurant with the Most Reviews in All Cities
SELECT rest_name, number_of_reviews, city
FROM (
    SELECT rest_name, number_of_reviews, 'Los Angeles' AS city FROM Los_Angeles
    UNION ALL
    SELECT rest_name, number_of_reviews, 'San Francisco' AS city FROM San_Francisco
    UNION ALL
    SELECT rest_name, number_of_reviews, 'San Diego' AS city FROM San_Diego
    UNION ALL
    SELECT rest_name, number_of_reviews, 'Chicago' AS city FROM Chicago
    UNION ALL
    SELECT rest_name, number_of_reviews, 'New York' AS city FROM New_York
) AS combined
ORDER BY number_of_reviews DESC
LIMIT 1


-- 30.Count the Number of Unique Cuisines Offered in Each City
SELECT city, COUNT(DISTINCT food_type) AS unique_cuisines
FROM (
    SELECT 'Los Angeles' AS city, food_type FROM Los_Angeles
    UNION ALL
    SELECT 'San Francisco', food_type FROM San_Francisco
    UNION ALL
    SELECT 'San Diego', food_type FROM San_Diego
    UNION ALL
    SELECT 'Chicago', food_type FROM Chicago
    UNION ALL
    SELECT 'New York', food_type FROM New_York
) AS combined
GROUP BY city;