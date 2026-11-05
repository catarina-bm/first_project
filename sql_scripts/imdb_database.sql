USE imdb_movies;

-- directors
LOAD DATA LOCAL INFILE 'C:/Users/catar/Documents/Ironhack/Week_4/First_Project/first_project/data/clean/directors.csv'
-- LOAD DATA LOCAL INFILE '/Users/binduvalmiki/Desktop/Ironhack/Week_4/Day_1/first_project/data/clean/directors.csv'
INTO TABLE directors
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(director_id, @director_name)
SET director_name = TRIM(TRAILING '\r' FROM @director_name);
 
-- certificates
LOAD DATA LOCAL INFILE 'C:/Users/catar/Documents/Ironhack/Week_4/First_Project/first_project/data/clean/certificates.csv'
-- LOAD DATA LOCAL INFILE '/Users/binduvalmiki/Desktop/Ironhack/Week_4/Day_1/first_project/data/clean/certificates.csv'
INTO TABLE certificates
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(certificate_id, certificate_name, @audience)
SET audience = TRIM(TRAILING '\r' FROM @audience);
 
-- genres
LOAD DATA LOCAL INFILE 'C:/Users/catar/Documents/Ironhack/Week_4/First_Project/first_project/data/clean/genres.csv'
-- LOAD DATA LOCAL INFILE '/Users/binduvalmiki/Desktop/Ironhack/Week_4/Day_1/first_project/data/clean/genres.csv'
INTO TABLE genres
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(genre_id, @genre_name)
SET genre_name = TRIM(TRAILING '\r' FROM @genre_name);
 
-- actors
LOAD DATA LOCAL INFILE 'C:/Users/catar/Documents/Ironhack/Week_4/First_Project/first_project/data/clean/actors.csv'
-- LOAD DATA LOCAL INFILE '/Users/binduvalmiki/Desktop/Ironhack/Week_4/Day_1/first_project/data/clean/actors.csv'
INTO TABLE actors
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(actor_id, @actor_name)
SET actor_name = TRIM(TRAILING '\r' FROM @actor_name);
 
-- movies (empty gross_revenue becomes NULL)
LOAD DATA LOCAL INFILE 'C:/Users/catar/Documents/Ironhack/Week_4/First_Project/first_project/data/clean/movies.csv'
-- LOAD DATA LOCAL INFILE '/Users/binduvalmiki/Desktop/Ironhack/Week_4/Day_1/first_project/data/clean/movies.csv'
INTO TABLE movies
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(movie_id, movie_title, released_year, runtime, @gross_revenue, director_id, @certificate_id)
SET gross_revenue = NULLIF(@gross_revenue, ''),
    certificate_id = TRIM(TRAILING '\r' FROM @certificate_id);
 
-- ratings (empty meta_score becomes NULL)
LOAD DATA LOCAL INFILE 'C:/Users/catar/Documents/Ironhack/Week_4/First_Project/first_project/data/clean/ratings.csv'
-- LOAD DATA LOCAL INFILE '/Users/binduvalmiki/Desktop/Ironhack/Week_4/Day_1/first_project/data/clean/ratings.csv'
INTO TABLE ratings
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(rating_id, imdb_rating, @meta_score, number_of_votes, @movie_id)
SET meta_score = NULLIF(@meta_score, ''),
    movie_id = TRIM(TRAILING '\r' FROM @movie_id);
 
-- movie_genres
LOAD DATA LOCAL INFILE 'C:/Users/catar/Documents/Ironhack/Week_4/First_Project/first_project/data/clean/movie_genres.csv'
-- LOAD DATA LOCAL INFILE '/Users/binduvalmiki/Desktop/Ironhack/Week_4/Day_1/first_project/data/clean/movie_genres.csv'
INTO TABLE movie_genres
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(movie_genre_id, movie_id, @genre_id)
SET genre_id = TRIM(TRAILING '\r' FROM @genre_id);
 
-- movie_cast
LOAD DATA LOCAL INFILE 'C:/Users/catar/Documents/Ironhack/Week_4/First_Project/first_project/data/clean/movie_cast.csv'
-- LOAD DATA LOCAL INFILE '/Users/binduvalmiki/Desktop/Ironhack/Week_4/Day_1/first_project/data/clean/movie_cast.csv'
INTO TABLE movie_cast
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(movie_cast_id, movie_id, actor_id, @billing_order)
SET billing_order = TRIM(TRAILING '\r' FROM @billing_order);
 
-- Check: row counts should match notebook 02
SELECT 'directors' AS table_name, COUNT(*) AS total_rows FROM directors   -- 548
UNION ALL SELECT 'certificates', COUNT(*) FROM certificates              -- 16
UNION ALL SELECT 'genres', COUNT(*) FROM genres                          -- 21
UNION ALL SELECT 'actors', COUNT(*) FROM actors                          -- 2709
UNION ALL SELECT 'movies', COUNT(*) FROM movies                          -- 1000
UNION ALL SELECT 'ratings', COUNT(*) FROM ratings                        -- 1000
UNION ALL SELECT 'movie_genres', COUNT(*) FROM movie_genres              -- 2541
UNION ALL SELECT 'movie_cast', COUNT(*) FROM movie_cast;                 -- 3996
 
-- Check: missing values loaded as NULL
SELECT COUNT(*) AS missing_gross FROM movies WHERE gross_revenue IS NULL;   -- 169
SELECT COUNT(*) AS missing_meta FROM ratings WHERE meta_score IS NULL;      -- 157
 