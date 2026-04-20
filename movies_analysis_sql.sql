-- CREATE A DATABASE, WHERE I STORE MY MOVIE DATA....
create database movie;
-- AFTER CREATE, USE THIS DATABASE THROUGH THIS COMMENT..
use movie;


-- HOW THIS THE DATASET?
/* SO, THERE ARE 15 COLUMN, WHERE NO-NULL VALUE PRESENT...IN THIS DATASET 2 COLUMN( runtime,release_year )INTEGER AND release_year IS DOUBLE 
REST OF ARE TEXT...

IN THE DATASET, THERE ARE TWO TYPES OF DATA PRESENT ONE IS [MOVIE DATA] AND ANOTHER IS [SHOW DATA].....MOVIE-68, SHOW-11

IN THERE, OLD MOVIES AND SHOWA ARE PRESENT BETWEEN 1945 TO 1990... MOST MOVIES HADE MADE IN 1989(12 MOVIES)...IN 19980 CIRCLE TOTAL 41 MOVIES MADE....
*/


DESCRIBE titles; 


-- CHECK NUMBER OF COLUMNS
SELECT COUNT(*) AS total_columns
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'titles';


-- WHICH COLUMNS ARE INT AND DOUBLE DATATYPES....
SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='titles' and data_type in ('int','double');


-- CHECK EACH COLUMN DATA-TYPE
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'titles';


-- CHECK NULL VALUES COLUMNS WISE
SELECT 
    SUM(age_certification IS NULL) AS age_certification,
    SUM(tmdb_score IS NULL) AS tmdb_score,
    SUM(runtime IS NULL) AS runtime,
    SUM(imdb_votes IS NULL) AS imdb_votes,
    SUM(imdb_score IS NULL) AS imdb_score,
    SUM(tmdb_popularity IS NULL) AS tmdb_popularity
FROM titles;


-- SHOW FIRST 5 ENTRIES...
select * from titles limit 5;


-- COUNT TOTAL ENTRIES BASED ON TYPES...
select count(title),type from titles group by type;


-- COUNT BASED ON 'RELEASE_YEAR'
SELECT 
    release_year,
    COUNT(*) AS count
FROM titles
GROUP BY release_year
ORDER BY release_year DESC;


select count(title), genres from titles group by genres;

-- What were the top 10 movies according to IMDB score?
SELECT title, 
type, 
imdb_score
FROM titles
WHERE imdb_score >= 8.0
AND type = 'MOVIE'
ORDER BY imdb_score DESC
LIMIT 10;


-- What were the top 10 showa according to IMDB score?
SELECT title, 
type, 
imdb_score
FROM titles
WHERE imdb_score >= 8.0
AND type = 'SHOW'
ORDER BY imdb_score DESC
LIMIT 10;


-- What were the bottom 10 movies according to IMDB score? 
SELECT title, 
type, 
imdb_score
FROM  titles
WHERE type = 'MOVIE'
ORDER BY imdb_score ASC
LIMIT 10;


-- What were the bottom 10 shows according to IMDB score? 
SELECT title, 
type, 
imdb_score
FROM  titles
WHERE type = 'SHOW'
ORDER BY imdb_score ASC
LIMIT 10;


-- What were the average IMDB and TMDB scores for shows and movies? 
SELECT DISTINCT type, 
ROUND(AVG(imdb_score),2) AS avg_imdb_score,
ROUND(AVG(tmdb_score),2) as avg_tmdb_score
FROM titles
GROUP BY type ;



-- Count of movies and shows in each decade
SELECT CONCAT(FLOOR(release_year / 10) * 10, 's') AS decade,
	COUNT(*) AS movies_shows_count
FROM titles
WHERE release_year >= 1940
GROUP BY CONCAT(FLOOR(release_year / 10) * 10, 's')
ORDER BY decade;



-- What were the average IMDB and TMDB scores for each production country?
SELECT DISTINCT production_countries, 
ROUND(AVG(imdb_score),2) AS avg_imdb_score,
ROUND(AVG(tmdb_score),2) AS avg_tmdb_score
FROM  titles
GROUP BY production_countries
ORDER BY avg_imdb_score DESC;



-- What were the average IMDB and TMDB scores for each age certification for shows and movies?
SELECT DISTINCT age_certification, 
ROUND(AVG(imdb_score),2) AS avg_imdb_score,
ROUND(AVG(tmdb_score),2) AS avg_tmdb_score
FROM titles
GROUP BY age_certification
ORDER BY avg_imdb_score DESC;



-- What were the 5 most common age certifications for movies?
SELECT age_certification, 
COUNT(*) AS certification_count
FROM titles
WHERE type = 'Movie' 
AND age_certification != 'N/A'
GROUP BY age_certification
ORDER BY certification_count DESC
LIMIT 5;


/*
-- Who were the top 20 actors that appeared the most in movies/shows? 
SELECT DISTINCT name as actor, 
COUNT(*) AS number_of_appearences 
FROM credits
WHERE role = 'actor'
GROUP BY name
ORDER BY number_of_appearences DESC
LIMIT 20;

-- Who were the top 20 directors that directed the most movies/shows? 
SELECT DISTINCT name as director, 
COUNT(*) AS number_of_appearences 
FROM shows_movies.credits
WHERE role = 'director'
GROUP BY name
ORDER BY number_of_appearences DESC
LIMIT 20
*/



-- Calculating the average runtime of movies and TV shows separately
SELECT 
'Movies' AS content_type,
ROUND(AVG(runtime),2) AS avg_runtime_min
FROM titles
WHERE type = 'Movie'
UNION ALL
SELECT 
'Show' AS content_type,
ROUND(AVG(runtime),2) AS avg_runtime_min
FROM titles
WHERE type = 'Show';


/*
-- Finding the titles and  directors of movies released on or after 2010
SELECT DISTINCT t.title, c.name AS director, 
release_year
FROM shows_movies.titles AS t
JOIN shows_movies.credits AS c 
ON t.id = c.id
WHERE t.type = 'Movie' 
AND t.release_year >= 2010 
AND c.role = 'director'
ORDER BY release_year DESC
*/


-- Which shows on Netflix have the most seasons?
SELECT title, 
SUM(seasons) AS total_seasons
FROM titles 
WHERE type = 'Show'
GROUP BY title
ORDER BY total_seasons DESC
LIMIT 10;



-- Which genres had the most movies? 
SELECT genres, 
COUNT(*) AS title_count
FROM titles 
WHERE type = 'Movie'
GROUP BY genres
ORDER BY title_count DESC
LIMIT 10;

-- Which genres had the most shows? 
SELECT genres, 
COUNT(*) AS title_count
FROM titles 
WHERE type = 'Show'
GROUP BY genres
ORDER BY title_count DESC
LIMIT 10;


/*
-- Titles and Directors of movies with high IMDB scores (>7.5) and high TMDB popularity scores (>80) 
SELECT t.title, 
c.name AS director
FROM shows_movies.titles AS t
JOIN shows_movies.credits AS c 
ON t.id = c.id
WHERE t.type = 'Movie' 
AND t.imdb_score > 7.5 
AND t.tmdb_popularity > 80 
AND c.role = 'director';
*/


-- What were the total number of titles for each year? 
SELECT release_year, 
COUNT(*) AS title_count
FROM titles 
GROUP BY release_year
ORDER BY release_year DESC;


/*
-- Actors who have starred in the most highly rated movies or shows
SELECT c.name AS actor, 
COUNT(*) AS num_highly_rated_titles
FROM shows_movies.credits AS c
JOIN shows_movies.titles AS t 
ON c.id = t.id
WHERE c.role = 'actor'
AND (t.type = 'Movie' OR t.type = 'Show')
AND t.imdb_score > 8.0
AND t.tmdb_score > 8.0
GROUP BY c.name
ORDER BY num_highly_rated_titles DESC;

-- Which actors/actresses played the same character in multiple movies or TV shows? 
SELECT c.name AS actor_actress, 
c.character, 
COUNT(DISTINCT t.title) AS num_titles
FROM shows_movies.credits AS c
JOIN shows_movies.titles AS t 
ON c.id = t.id
WHERE c.role = 'actor' OR c.role = 'actress'
GROUP BY c.name, c.character
HAVING COUNT(DISTINCT t.title) > 1;


*/
-- What were the top 3 most common genres?
SELECT t.genres, 
COUNT(*) AS genre_count
FROM titles AS t
WHERE t.type = 'Movie'
GROUP BY t.genres
ORDER BY genre_count DESC
LIMIT 3;

/* Average IMDB score for leading actors/actresses in movies or shows 
SELECT c.name AS actor_actress, 
ROUND(AVG(t.imdb_score),2) AS average_imdb_score
FROM shows_movies.credits AS c
JOIN shows_movies.titles AS t 
ON c.id = t.id
WHERE c.role = 'actor' OR c.role = 'actress'
AND c.character = 'leading role'
GROUP BY c.name
ORDER BY average_imdb_score DESC;
*/
