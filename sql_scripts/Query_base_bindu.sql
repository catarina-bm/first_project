USE imdb_movies;
-- Q1. Genres: Which genres produce the most top-rated films, and which earn the most at the box office?

-- Top-rated = IMDb rating >= 8.5

DROP TEMPORARY TABLE IF EXISTS genre_stats;

CREATE TEMPORARY TABLE genre_stats AS
SELECT g.genre_name,
       COUNT(*)                  AS films,
       SUM(r.imdb_rating >= 8.5) AS top_rated_films,
       RANK() OVER (ORDER BY SUM(r.imdb_rating >= 8.5) DESC) AS rating_rank,
       SUM(m.gross_revenue)      AS total_gross,
       RANK() OVER (ORDER BY SUM(m.gross_revenue) DESC)      AS gross_rank
FROM genres g
JOIN movie_genres mg ON g.genre_id = mg.genre_id
JOIN movies m        ON mg.movie_id = m.movie_id
JOIN ratings r       ON m.movie_id = r.movie_id
GROUP BY g.genre_id, g.genre_name;

-- Genres with the most top-rated films
SELECT genre_name, top_rated_films, rating_rank
FROM genre_stats
ORDER BY rating_rank
LIMIT 5;

-- Genres that earn the most at the box office
SELECT genre_name, total_gross, gross_rank
FROM genre_stats
ORDER BY gross_rank
LIMIT 5;


-- Q2.: Do critics (meta_score) and audiences (imdb_rating) agree?

-- 1. Overall: average score from each side
SELECT ROUND(AVG(imdb_rating * 10), 1) AS avg_audience_score,
       ROUND(AVG(meta_score), 1)       AS avg_critic_score
FROM ratings
WHERE meta_score IS NOT NULL;

-- 2. How many films do they agree on?
SELECT CASE
         WHEN ABS(meta_score - imdb_rating * 10) <= 10 THEN 'Agree'
         WHEN meta_score > imdb_rating * 10           THEN 'Critics liked it more'
         ELSE 'Audiences liked it more'
       END AS opinion,
       COUNT(*) AS films
FROM ratings
WHERE meta_score IS NOT NULL
GROUP BY opinion;

-- 3. Films where they disagree the most
SELECT m.movie_title,
       ROUND(r.imdb_rating * 10,2) AS audience_score,
       r.meta_score       AS critic_score
FROM movies m
JOIN ratings r ON m.movie_id = r.movie_id
WHERE r.meta_score IS NOT NULL
ORDER BY ABS(r.meta_score - r.imdb_rating * 10) DESC
LIMIT 10;


-- 3. Talent: Which directors and actors consistently deliver highly rated and profitable films? 
 -- directors
 -- Q3: Which directors consistently deliver highly rated and profitable films?

SELECT d.director_name,
       COUNT(*)                     AS films,
       ROUND(AVG(r.imdb_rating), 2) AS avg_rating,
       ROUND(AVG(m.gross_revenue))  AS avg_gross
FROM directors d
JOIN movies m  ON d.director_id = m.director_id
JOIN ratings r ON m.movie_id = r.movie_id
GROUP BY d.director_id, d.director_name
HAVING COUNT(*) >= 4
ORDER BY avg_rating DESC
LIMIT 10;
-- actors
SELECT a.actor_name,
       COUNT(*)                     AS films,
       ROUND(AVG(r.imdb_rating), 2) AS avg_rating,
       ROUND(AVG(m.gross_revenue))  AS avg_gross
FROM actors a
JOIN movie_cast mc ON a.actor_id = mc.actor_id
JOIN movies m      ON mc.movie_id = m.movie_id
JOIN ratings r     ON m.movie_id = r.movie_id
GROUP BY a.actor_id, a.actor_name
HAVING COUNT(*) >= 4
ORDER BY avg_rating DESC
LIMIT 10;
