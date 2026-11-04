-- Create the imdb_movies database and its 8 tables
-- Running this file again deletes the database and recreates it empty

DROP DATABASE IF EXISTS imdb_movies;
CREATE DATABASE imdb_movies;
USE imdb_movies;

-- Tables without foreign keys

CREATE TABLE directors (
	director_id INTEGER NOT NULL,
	director_name VARCHAR(255) NOT NULL,
	PRIMARY KEY (director_id)
);

CREATE TABLE certificates (
	certificate_id INTEGER NOT NULL,
	certificate_name VARCHAR(255) NOT NULL,
	audience VARCHAR(255) NOT NULL,
	PRIMARY KEY (certificate_id)
);

CREATE TABLE genres (
	genre_id INTEGER NOT NULL,
	genre_name VARCHAR(255) NOT NULL,
	PRIMARY KEY (genre_id)
);

CREATE TABLE actors (
	actor_id INTEGER NOT NULL,
	actor_name VARCHAR(255) NOT NULL,
	PRIMARY KEY (actor_id)
);

-- Movies (depends on directors and certificates)

CREATE TABLE movies (
	movie_id INTEGER NOT NULL,
	movie_title VARCHAR(255) NOT NULL,
	released_year INTEGER NOT NULL,
	runtime INTEGER NOT NULL,
	gross_revenue BIGINT,
	director_id INTEGER NOT NULL,
	certificate_id INTEGER NOT NULL,
	PRIMARY KEY (movie_id),
	FOREIGN KEY (director_id) REFERENCES directors (director_id)
		ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (certificate_id) REFERENCES certificates (certificate_id)
		ON UPDATE CASCADE ON DELETE CASCADE
);

-- Tables that depend on movies

CREATE TABLE ratings (
	rating_id INTEGER NOT NULL,
	imdb_rating FLOAT NOT NULL,
	meta_score FLOAT,
	number_of_votes BIGINT NOT NULL,
	movie_id INTEGER NOT NULL,
	PRIMARY KEY (rating_id),
	UNIQUE (movie_id),
	FOREIGN KEY (movie_id) REFERENCES movies (movie_id)
		ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE movie_genres (
	movie_genre_id INTEGER NOT NULL,
	movie_id INTEGER NOT NULL,
	genre_id INTEGER NOT NULL,
	PRIMARY KEY (movie_genre_id),
	UNIQUE (movie_id, genre_id),
	FOREIGN KEY (movie_id) REFERENCES movies (movie_id)
		ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (genre_id) REFERENCES genres (genre_id)
		ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE movie_cast (
	movie_cast_id INTEGER NOT NULL,
	movie_id INTEGER NOT NULL,
	actor_id INTEGER NOT NULL,
	billing_order INTEGER NOT NULL,
	PRIMARY KEY (movie_cast_id),
	UNIQUE (movie_id, actor_id),
	FOREIGN KEY (movie_id) REFERENCES movies (movie_id)
		ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (actor_id) REFERENCES actors (actor_id)
		ON UPDATE CASCADE ON DELETE CASCADE
);
