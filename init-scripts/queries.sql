--1. query1: Write a SQL query to return the total number of comments authored by the user `xymemez`.
--a. Your column names MUST be: ‘count of comments’ 

DROP TABLE IF EXISTS query1;
CREATE TABLE query1 AS
SELECT COUNT(*) AS "count of comments"
FROM comments
WHERE author = 'xymemez';

--2. query2: Write a SQL query to return the total number of subreddits for each subreddit type.
--a. Your column names MUST be: ‘subreddit type’, ‘subreddit count’ 

DROP TABLE IF EXISTS query2;
CREATE TABLE query2 AS
SELECT subreddit_type AS "subreddit type", COUNT(*) AS "subreddit count"
FROM subreddits
GROUP BY subreddit_type
order by subreddit_type;


--3. query3: Write a SQL query to return the top 10 subreddits arranged by the number of comments. 
--Calculate the average score for each of these subreddits and round it to 2 decimal places.
--a. Your column names MUST be: ‘name’, ‘comments count’, ‘average score’ 


DROP TABLE IF EXISTS query3;
CREATE TABLE query3 AS
SELECT 
    s.name AS "name",
    COUNT(c.id) AS "comments count",
    ROUND(AVG(c.score), 2) AS "average score"
FROM comments c
JOIN subreddits s ON c.subreddit_id = s.name
GROUP BY s.name
ORDER BY COUNT(c.id) DESC
LIMIT 10;

--4. query4: Write a SQL query to print name, link_karma, comment_karma for users with >1,000,000 average karma in descending order. 
--Additionally, also have a column ‘label’ which shows 1 if the link_karma >= comment_karma, else 0
--a. Your column names MUST be: ‘name’, ‘link karma’, ‘comment karma’, ‘label’
--b. You can write this query with both having and where clauses (both will be considered correct and submit only one), 
--however, try doing both just to see the speed difference. (if you do try it) let us know the results in the README along with your theory for why!
--c. To fairly compare times between 2 queries, you need to clear the postgres cache! A helpful link: See and clear Postgres caches/buffers? - Stack Overflow 

DROP TABLE IF EXISTS query4;
CREATE TABLE query4 AS
SELECT 
    name AS "name",
    link_karma AS "link karma",
    comment_karma AS "comment karma",
    CASE 
        WHEN link_karma >= comment_karma THEN 1 
        ELSE 0 
    END AS "label"
FROM authors
WHERE (link_karma + comment_karma) / 2 > 1000000
ORDER BY link_karma DESC;

--5. query5: Write a SQL query to give count of comments in subreddit types where the user has commented. Write this query for the user `[deleted_user]`
--a. Your column names MUST be: ‘sr type’, ‘comments num’

DROP TABLE IF EXISTS query5;
CREATE TABLE query5 AS
SELECT 
    s.subreddit_type AS "sr type",
    COUNT(c.id) AS "comments num"
FROM comments c
JOIN subreddits s ON c.subreddit_id = s.name
WHERE c.author = '[deleted_user]'
GROUP BY s.subreddit_type;

