SET GLOBAL local_infile = 1;
SHOW GLOBAL VARIABLES LIKE 'local_infile';

USE imdb_movies;

-- Q1. Rating vs. box office
-- Does a high rating mean high box office, or does popularity (number of votes) matter more?

SELECT
    COUNT(*) AS total_films,
    COUNT(gross_revenue) AS films_with_gross,
    COUNT(*) - COUNT(gross_revenue) AS films_without_gross
FROM movies;

-- Average box office by IMDb rating group
SELECT
    CASE
        WHEN r.imdb_rating >= 8.5 THEN '8.5+'
        WHEN r.imdb_rating >= 8.0 THEN '8.0 - 8.4'
        ELSE '7.6 - 7.9'
    END AS rating_group,
    COUNT(*) AS films,
    ROUND(AVG(m.gross_revenue) / 1000000, 1) AS avg_gross_millions
FROM movies m
JOIN ratings r ON m.movie_id = r.movie_id
WHERE m.gross_revenue IS NOT NULL
GROUP BY rating_group
ORDER BY rating_group DESC;
 
-- Average box office by popularity (number of votes) group
SELECT
    CASE
        WHEN r.number_of_votes >= 1000000 THEN '1M+ votes'
        WHEN r.number_of_votes >= 500000 THEN '500k - 1M votes'
        WHEN r.number_of_votes >= 100000 THEN '100k - 500k votes'
        ELSE 'under 100k votes'
    END AS votes_group,
    COUNT(*) AS films,
    ROUND(AVG(m.gross_revenue) / 1000000, 1) AS avg_gross_millions
FROM movies m
JOIN ratings r ON m.movie_id = r.movie_id
WHERE m.gross_revenue IS NOT NULL
GROUP BY votes_group
ORDER BY avg_gross_millions DESC;
 
-- Top 10 highest-earning films: are they the best rated or the most voted?
SELECT
    m.movie_title,
    m.released_year,
    ROUND(m.gross_revenue / 1000000, 1) AS gross_millions,
    r.imdb_rating,
    r.number_of_votes
FROM movies m
JOIN ratings r ON m.movie_id = r.movie_id
WHERE m.gross_revenue IS NOT NULL
ORDER BY m.gross_revenue DESC
LIMIT 10;


-- Q2. Trends over time
-- How has the mix of top films changed over the decades, and which genres are rising?

-- Number of top films per decade
SELECT
    FLOOR(released_year / 10) * 10 AS decade,
    COUNT(*) AS films,
    ROUND(AVG(runtime)) AS avg_runtime_min
FROM movies
GROUP BY decade
ORDER BY decade;
 

-- Rising and falling genres: % of films with each genre before 2000 vs. from 2000 onwards
WITH before_2000 AS (
    SELECT
        g.genre_name,
        ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM movies WHERE released_year < 2000), 1) AS pct_before_2000
    FROM movies m
    JOIN movie_genres mg ON m.movie_id = mg.movie_id
    JOIN genres g ON mg.genre_id = g.genre_id
    WHERE m.released_year < 2000
    GROUP BY g.genre_name
),
from_2000 AS (
    SELECT
        g.genre_name,
        ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM movies WHERE released_year >= 2000), 1) AS pct_from_2000
    FROM movies m
    JOIN movie_genres mg ON m.movie_id = mg.movie_id
    JOIN genres g ON mg.genre_id = g.genre_id
    WHERE m.released_year >= 2000
    GROUP BY g.genre_name
)
SELECT
    b.genre_name,
    b.pct_before_2000,
    f.pct_from_2000,
    f.pct_from_2000 - b.pct_before_2000 AS change_pct_points
FROM before_2000 b
JOIN from_2000 f ON b.genre_name = f.genre_name
ORDER BY change_pct_points DESC;


-- Most common genres in each decade 
SELECT
    FLOOR(m.released_year / 10) * 10 AS decade,
    g.genre_name,
    COUNT(*) AS films
FROM movies m
JOIN movie_genres mg ON m.movie_id = mg.movie_id
JOIN genres g ON mg.genre_id = g.genre_id
-- WHERE g.genre_name IN ('Action', 'Adventure', 'Drama', 'War', 'Western')
GROUP BY decade, g.genre_name 
ORDER BY decade, films DESC;


-- Filter 2000 onwards
-- Most common genres in recent top films (2000-2019)
SELECT
    g.genre_name,
    COUNT(*) AS films
FROM movies m
JOIN movie_genres mg ON m.movie_id = mg.movie_id
JOIN genres g ON mg.genre_id = g.genre_id
WHERE m.released_year BETWEEN 2000 AND 2019
GROUP BY g.genre_name
ORDER BY films DESC;

-- Q3. Age certificate
-- Does a film's age rating affect how much it earns?
-- Audience groups are used because the certificates mix Indian, US and TV systems.


-- Average box office by audience group
SELECT
    c.audience,
    COUNT(*) AS films,
    COUNT(m.gross_revenue) AS films_with_gross,
    ROUND(AVG(m.gross_revenue) / 1000000, 1) AS avg_gross_millions
FROM movies m
JOIN certificates c ON m.certificate_id = c.certificate_id
GROUP BY c.audience
ORDER BY avg_gross_millions DESC;
 
-- Average box office by certificate (only certificates with at least 10 films with gross)
SELECT
    c.certificate_name,
    c.audience,
    COUNT(*) AS films_with_gross,
    ROUND(AVG(m.gross_revenue) / 1000000, 1) AS avg_gross_millions
FROM movies m
JOIN certificates c ON m.certificate_id = c.certificate_id
WHERE m.gross_revenue IS NOT NULL
GROUP BY c.certificate_name, c.audience
HAVING COUNT(*) >= 10
ORDER BY avg_gross_millions DESC;
 
-- Films earning above the average box office, by audience group
SELECT
    c.audience,
    COUNT(*) AS films_above_average
FROM movies m
JOIN certificates c ON m.certificate_id = c.certificate_id
WHERE m.gross_revenue > (SELECT AVG(gross_revenue) FROM movies)
GROUP BY c.audience
ORDER BY films_above_average DESC;














