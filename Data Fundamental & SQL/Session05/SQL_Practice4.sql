-- MSc in DMDS - 2023-24
-- 7CPSQL / emlyon 
-- Practice 3 - Solutions

-- We will work here on the movies database. 
-- We will take a look on the different table and try to stire out some well summarized informations. 
-- We will focus on the table metadata but but what we will see is applicable to the other tables as well.

-- ------ 
-- Exercice 1: CAST()
-- (On the table metadata from the movies database).
-- We want to sort our data depending on the cost of the film.
-- 1) Select name, director name, duration, genre of the film and budget in million, order by the column budget. 
--    Try ascending and descending order. What do you think of the result? (Look at the budget datatype ith describe).
-- 2) Do the same but cast the budget as an unsigned integer.

-- 1)
SELECT director_name, duration, movie_title, genres, budget/1000000 FROM metadata
WHERE budget <> ""
ORDER BY budget ASC;

SELECT director_name, duration, movie_title, genres, budget/1000000 FROM metadata
WHERE budget <> ""
ORDER BY budget DESC;
-- The order is not correct!
-- It is in fact alphabetical order because of the datatype of the clumn budget


-- 2)
SELECT director_name, duration, movie_title, genres, budget/1000000 FROM metadata
WHERE budget <> ""
ORDER BY CAST(budget AS UNSIGNED INTEGER) ASC;

SELECT director_name, duration, movie_title, genres, budget/1000000 FROM metadata
WHERE budget <> ""
ORDER BY CAST(budget AS UNSIGNED INTEGER) DESC;



-- Exercice 2: CONCAT()
-- (On the table metadata from the movies database).
-- We want to have the names of director and actors and their respective number of likes in one column.
-- Q) Write a query that display for each film its title and then some columns with de following format: 
--    « [director/actor name]: [nb_of_fb_likes] likes ». Don’t forget to use aliases to name your columns!
SELECT * FROM metadata;
SELECT movie_title, CONCAT(director_name, ": ", director_facebook_likes, " likes") AS Director, 
CONCAT(actor_1_name, ": ", actor_1_facebook_likes, " likes") AS Actor_1, 
CONCAT(actor_2_name, ": ", actor_2_facebook_likes, " likes") AS Actor_2, 
CONCAT(actor_3_name, ": ", actor_3_facebook_likes, " likes") AS Actor_3
FROM metadata;




-- Exercice 3: SUBSTRING_INDEX()
-- (On the table metadata from the movies database).
-- We want to have the first and last names of the director in separate columns.
-- Q- Write a query to extract in separate column the movie title, the director firstname, the director last name and 
--    some other relevant information about the film (eg. duration, year, genres,…).
SELECT SUBSTRING_INDEX(genres, '|', 2) AS Two_first_genres 
FROM metadata;



-- Exercice 4: ROUND()
-- (On the table metadata from the movies database).
-- We want to study the evolution of the imdb score through the year.
-- Q- Compute the average imdb score per year. Round your result to 1 decimal and order it by year ascending. 
--    Be careful to exclude missing or corrupted values.
SELECT title_year, ROUND(AVG(imdb_score),1) AS Avg_imdb_score FROM metadata
WHERE title_year >= 1916 AND title_year <= 2016 AND imdb_score <> 0
GROUP BY title_year
ORDER BY title_year;
