--select * from comments c  limit 100; -- join to subreddits with name
--select * from authors a limit 100;
--select * from submissions sm  limit 100;
--select * from subreddits sr  limit 100; -- join to comments with subreddit_id
--
--
--subreddits.display_name = comments.subreddit
--subreddits.name = comments.subreddit_id
--
--authors.name = comments.author
--authors.name = submissions.author
--
--submissions.subreddit_id = subreddits.name
--
--SELECT 
--    c.subreddit, 
--    s.display_name
--FROM 
--    comments c
--JOIN 
--    subreddits s ON c.subreddit = s.display_name
--LIMIT 10;
--
--SELECT 
--    c.subreddit_id, 
--    s.name
--FROM 
--    comments c
--JOIN 
--    subreddits s ON c.subreddit_id = s.name
--LIMIT 10;
--
--SELECT 
--    c.author, 
--    a.name AS author_name
--FROM 
--    comments c
--JOIN 
--    authors a ON c.author = a.name
--LIMIT 10;
--
--SELECT 
--    s.author, 
--    a.name AS author_name
--FROM 
--    submissions s
--JOIN 
--    authors a ON s.author = a.name
--LIMIT 10;
--
--SELECT 
--    s.subreddit_id, 
--    sr.name AS subreddit_name
--FROM 
--    submissions s
--JOIN 
--    subreddits sr ON s.subreddit_id = sr.name
--LIMIT 10;


--SELECT conname, conrelid::regclass AS table_name
--FROM pg_constraint
--WHERE conrelid::regclass::text IN ('subreddits', 'comments');
--
--SELECT name, COUNT(*)
--FROM subreddits
--GROUP BY name
--HAVING COUNT(*) > 1;
--
--SELECT display_name, COUNT(*)
--FROM subreddits
--GROUP BY display_name
--HAVING COUNT(*) > 1;
--
--
--select display_name, name
--from subreddits 
--where subreddits.display_name  <> subreddits."name" limit 100;
--
--select c.subreddit, c.subreddit_id  from "comments" c
--where c.subreddit <> c.subreddit_id limit 100; 

ALTER TABLE subreddits
ADD CONSTRAINT subreddits_name_pk PRIMARY KEY (name);

ALTER TABLE comments
ADD CONSTRAINT comments_subreddit_fk FOREIGN KEY (subreddit_id) REFERENCES subreddits(name);

ALTER TABLE authors
ADD CONSTRAINT authors_name_pk PRIMARY KEY (name);

ALTER TABLE comments
ADD CONSTRAINT comments_author_fk FOREIGN KEY (author) REFERENCES authors(name);

ALTER TABLE submissions
ADD CONSTRAINT submissions_author_fk FOREIGN KEY (author) REFERENCES authors(name);

ALTER TABLE submissions
ADD CONSTRAINT submissions_subreddit_id_fk FOREIGN KEY (subreddit_id) REFERENCES subreddits(name);

-- Index need to optimize query
CREATE INDEX IF NOT EXISTS idx_comments_subreddit_id ON comments(subreddit_id);
CREATE INDEX IF NOT EXISTS idx_comments_author ON comments(author);
CREATE INDEX IF NOT EXISTS idx_comments_subreddit_display ON comments(subreddit);
CREATE INDEX IF NOT EXISTS idx_submissions_author ON submissions(author);
CREATE INDEX IF NOT EXISTS idx_submissions_subreddit_id ON submissions(subreddit_id);
