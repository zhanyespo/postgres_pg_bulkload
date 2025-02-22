-- Enable timing in PostgreSQL
\timing

-- Store start time
SELECT clock_timestamp() AS "Total Start Time";

-- disable WAL loggin
ALTER TABLE authors SET UNLOGGED;
ALTER TABLE comments SET UNLOGGED;;
ALTER TABLE submissions SET UNLOGGED;;
ALTER TABLE subreddits SET UNLOGGED;;

-- Disable triggers and foreign keys for faster inserts
ALTER TABLE authors DISABLE TRIGGER ALL;
ALTER TABLE comments DISABLE TRIGGER ALL;
ALTER TABLE submissions DISABLE TRIGGER ALL;
ALTER TABLE subreddits DISABLE TRIGGER ALL;

-- Optimize settings for bulk insert
SET synchronous_commit = OFF;
-- SET wal_level = minimal;
SET maintenance_work_mem = '2GB';
SET work_mem = '512MB';


SELECT clock_timestamp() AS "Start Time: authors";
-- Start transaction
BEGIN;

-- pg_bulkload -i /csv_files/authors.csv -o "COPY authors FROM STDIN WITH (FORMAT csv, HEADER true);"
-- pg_bulkload -i /csv_files/comments.csv -o "COPY comments FROM STDIN WITH (FORMAT csv, HEADER true);"
-- pg_bulkload -i /csv_files/submissions.csv -o "COPY submissions FROM STDIN WITH (FORMAT csv, HEADER true);"
-- pg_bulkload -i /csv_files/subreddits.csv -o "COPY subreddits FROM STDIN WITH (FORMAT csv, HEADER true);"

\copy authors FROM 'csv_files/authors.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');
\copy comments FROM 'csv_files/comments.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');
\copy submissions FROM 'csv_files/submissions.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');
\copy subreddits FROM 'csv_files/subreddits.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');

COMMIT;

SELECT clock_timestamp() AS "End Time: subreddits";

-- Restore settings
SET synchronous_commit = ON;
-- SET wal_level = replica;

-- Enable triggers again
ALTER TABLE authors ENABLE TRIGGER ALL;
ALTER TABLE comments ENABLE TRIGGER ALL;
ALTER TABLE submissions ENABLE TRIGGER ALL;
ALTER TABLE subreddits ENABLE TRIGGER ALL;

-- enable WAL loggin
ALTER TABLE authors SET LOGGED;
ALTER TABLE comments SET LOGGED;;
ALTER TABLE submissions SET LOGGED;;
ALTER TABLE subreddits SET LOGGED;;

-- Store end time
SELECT clock_timestamp() AS "Total End Time";

-- Calculate total duration
SELECT age(
    (SELECT clock_timestamp()),  -- Total End Time
    (SELECT clock_timestamp())   -- End Time: subreddits
) AS "Time Difference (HH:MM:SS)";

-- Validation: Check row counts
SELECT 'authors' AS table_name, COUNT(*) AS row_count FROM authors;
SELECT 'comments' AS table_name, COUNT(*) AS row_count FROM comments;
SELECT 'submissions' AS table_name, COUNT(*) AS row_count FROM submissions;
SELECT 'subreddits' AS table_name, COUNT(*) AS row_count FROM subreddits;
