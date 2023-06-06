use `steam store`;


-- QUERY 1 -- Retrieve the names of all games by date of release

SELECT gi.name, DATE_FORMAT(gi.release_date, '%Y-%m-%d') AS release_day
FROM game_info gi
JOIN game_ratings gr ON gi.appid = gr.appid
ORDER BY gr.positive_ratings DESC
LIMIT 50;

SELECT gi.name, DATE_FORMAT(gi.release_date, '%Y-%m-%d') AS release_day, gr.positive_ratings
FROM game_info gi
JOIN game_ratings gr ON gi.appid = gr.appid
ORDER BY gi.release_date DESC
LIMIT 50;



-- QUERY 2 -- Find the average positive and negative ratings for games in a specific genre:
SELECT AVG(gr.positive_ratings) AS avg_positive_ratings, AVG(gr.negative_ratings) AS avg_negative_ratings
FROM game_genres gg
JOIN game_ratings gr ON gg.appid = gr.appid
WHERE gg.genres = 'genre_name';


-- QUERY 3 -- Get the total number of games in each category:
SELECT c.categories, COUNT(*) AS total_games
FROM game_categories c
GROUP BY c.categories
ORDER BY total_games DESC;


-- QUERY 4 -- Calculate the average price of games published by a specific developer:
SELECT gi.publisher, AVG(gp.price) AS avg_price
FROM game_info gi
JOIN game_pricing gp ON gi.appid = gp.appid
JOIN (
    SELECT publisher
    FROM game_info
    GROUP BY publisher
    ORDER BY COUNT(*) DESC
    LIMIT 50
) AS top_publishers ON gi.publisher = top_publishers.publisher
GROUP BY gi.publisher
ORDER BY avg_price DESC;



-- QUERY 4.5 -- Determine the top 50 games with the highest positive ratings from the game_ratings table. Then, the main query joins the game_info and game_pricing tables with the derived table top_games based on the appid column, and calculates the average price for each publisher. The results are ordered in descending order of the average price.

SELECT gi.publisher, AVG(gp.price) AS avg_price
FROM game_info gi
JOIN game_pricing gp ON gi.appid = gp.appid
JOIN (
    SELECT appid
    FROM game_ratings
    ORDER BY positive_ratings DESC
    LIMIT 50
) AS top_games ON gi.appid = top_games.appid
GROUP BY gi.publisher
ORDER BY avg_price DESC;


SELECT gi.publisher, gi.name, AVG(gp.price) AS avg_price
FROM game_info gi
JOIN game_pricing gp ON gi.appid = gp.appid
JOIN (
    SELECT appid, positive_ratings
    FROM game_ratings
    ORDER BY positive_ratings DESC
    LIMIT 50
) AS top_games ON gi.appid = top_games.appid
GROUP BY gi.publisher, gi.name
ORDER BY avg_price DESC;


-- QUERY 5 -- Find the top 10 games with the highest positive ratings:
SELECT gi.name, gr.positive_ratings
FROM game_info gi
JOIN game_ratings gr ON gi.appid = gr.appid
ORDER BY gr.positive_ratings DESC
LIMIT 10;
