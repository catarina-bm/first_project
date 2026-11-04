CREATE TABLE IF NOT EXISTS `directors` (
	`director_id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
	`director_name` VARCHAR(255) NOT NULL,
	PRIMARY KEY(`director_id`)
);


CREATE TABLE IF NOT EXISTS `movies` (
	`movie_id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
	`movie_title` VARCHAR(255) NOT NULL,
	`released_year` INTEGER NOT NULL,
	`runtime` INTEGER NOT NULL,
	`gross_revenue` BIGINT,
	`director_id` INTEGER NOT NULL,
	`certificate_id` INTEGER NOT NULL,
	PRIMARY KEY(`movie_id`)
);


CREATE TABLE IF NOT EXISTS `certificates` (
	`certificate_id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
	`certificate_name` VARCHAR(255) NOT NULL,
	`audience` VARCHAR(255) NOT NULL,
	PRIMARY KEY(`certificate_id`)
);


CREATE TABLE IF NOT EXISTS `movie_genres` (
	`movie_genre_id` INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
	`movie_id` INTEGER NOT NULL UNIQUE,
	`genre_id` INTEGER NOT NULL UNIQUE,
	PRIMARY KEY(`movie_genre_id`)
);


CREATE TABLE IF NOT EXISTS `movie_cast` (
	`movie_cast_id` INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
	`movie_id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
	`actor_id` INTEGER NOT NULL,
	`billing_order` INTEGER NOT NULL,
	PRIMARY KEY(`movie_cast_id`)
);


CREATE TABLE IF NOT EXISTS `genres` (
	`genre_id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
	`genre_name` VARCHAR(255) NOT NULL,
	PRIMARY KEY(`genre_id`)
);


CREATE TABLE IF NOT EXISTS `actors` (
	`actor_id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
	`actor_name` VARCHAR(255) NOT NULL,
	PRIMARY KEY(`actor_id`)
);


CREATE TABLE IF NOT EXISTS `ratings` (
	`rating_id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
	`imdb_rating` FLOAT NOT NULL,
	`meta_score` FLOAT,
	`number_of_votes` BIGINT NOT NULL,
	`movie_id` INTEGER NOT NULL UNIQUE,
	PRIMARY KEY(`rating_id`)
);


ALTER TABLE `movies`
ADD FOREIGN KEY(`director_id`) REFERENCES `directors`(`director_id`)
ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE `movies`
ADD FOREIGN KEY(`certificate_id`) REFERENCES `certificates`(`certificate_id`)
ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE `movie_genres`
ADD FOREIGN KEY(`movie_id`) REFERENCES `movies`(`movie_id`)
ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE `ratings`
ADD FOREIGN KEY(`movie_id`) REFERENCES `movies`(`movie_id`)
ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE `movie_cast`
ADD FOREIGN KEY(`movie_id`) REFERENCES `movies`(`movie_id`)
ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE `movie_cast`
ADD FOREIGN KEY(`actor_id`) REFERENCES `actors`(`actor_id`)
ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE `movie_genres`
ADD FOREIGN KEY(`genre_id`) REFERENCES `genres`(`genre_id`)
ON UPDATE CASCADE ON DELETE CASCADE;