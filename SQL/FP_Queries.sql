use `steam store`;

-- QUERY 1 -- Retrieve the top 50 games with the highest positive ratings:
SELECT gi.name, gr.positive_ratings
FROM game_info gi
JOIN game_ratings gr ON gi.appid = gr.appid
ORDER BY gr.positive_ratings DESC
LIMIT 50;


-- QUERY 2 -- Retrieve the top 50 games with the highest negative ratings:
SELECT gi.name, gr.negative_ratings
FROM game_info gi
JOIN game_ratings gr ON gi.appid = gr.appid
ORDER BY gr.positive_ratings DESC
LIMIT 50;


-- QUERY 3 -- Retrieve the top 50 games with the highest positve ratings and display their respective negative ratings: In this query, the JOIN condition connects the game_info and game_ratings tables based on the appid column. The results are then ordered first by the positive ratings in descending order (gr.positive_ratings DESC), and for games with the same positive ratings, the negative ratings are used for further sorting in descending order (gr.negative_ratings DESC). Finally, the LIMIT 50 clause limits the result to the top 50 games.
SELECT gi.name, gr.positive_ratings, gr.negative_ratings, 
       ROUND((gr.positive_ratings / (gr.positive_ratings + gr.negative_ratings)) * 100, 2) AS positive_ratio
FROM game_info gi
JOIN game_ratings gr ON gi.appid = gr.appid
ORDER BY gr.positive_ratings DESC, gr.negative_ratings DESC
LIMIT 50;


-- QUERY 4 -- Retriedve how many games were released for each year
SELECT YEAR(release_date) AS release_year, COUNT(*) AS game_count
FROM game_info
GROUP BY YEAR(release_date)
ORDER BY release_year;


-- QUERY 5 -- Retrieve the names of all games by date of release
SELECT gi.name, DATE_FORMAT(gi.release_date, '%Y-%m-%d') AS release_day, gr.positive_ratings, gr.negative_ratings
FROM game_info gi
JOIN game_ratings gr ON gi.appid = gr.appid
ORDER BY gi.release_date ASC
LIMIT 1000;

-- QUERY 6 -- Retrieve the names of the most positively rated games by date of release
SELECT gi.name, DATE_FORMAT(gi.release_date, '%Y-%m-%d') AS release_day, gr.positive_ratings, gr.negative_ratings
FROM game_info gi
JOIN game_ratings gr ON gi.appid = gr.appid
ORDER BY gr.positive_ratings DESC
LIMIT 50;

-- QUERY 7 -- Retrieve the total number of games in each category:
SELECT c.categories, COUNT(*) AS total_games
FROM game_categories c
GROUP BY c.categories
ORDER BY total_games DESC;

-- QUERY 8 -- Retrieve the total number of games for each genres:
SELECT gg.genre, COUNT(*) AS total_games, ROUND(AVG(gp.price), 2) AS avg_price, ROUND(AVG(gr2.positive_ratings / gr2.negative_ratings), 2) AS avg_rating
FROM game_genres_reindexed gr
JOIN game_genres_list gg ON gr.genre_id = gg.genre_id
JOIN game_pricing gp ON gr.appid = gp.appid
JOIN game_ratings gr2 ON gr2.appid = gp.appid
GROUP BY gg.genre
ORDER BY total_games DESC;


-- QUERY 8 -- Retrieve the average price of games published by a specific developer:
SELECT gi.publisher, ROUND(AVG(gp.price), 2) AS avg_price
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