DROP TABLE IF EXISTS authors CASCADE;
DROP TABLE IF EXISTS comments CASCADE;
DROP TABLE IF EXISTS submissions CASCADE;
DROP TABLE IF EXISTS subreddits CASCADE;

CREATE TABLE IF NOT EXISTS authors (
    id VARCHAR(16),
    retrieved_on INTEGER,
    name VARCHAR(32),
    created_utc INTEGER,
    link_karma INTEGER,
    comment_karma INTEGER,
    profile_img VARCHAR(256),
    profile_color VARCHAR(16),
    profile_over_18 BOOLEAN
);

CREATE TABLE IF NOT EXISTS comments (
    distinguished VARCHAR(16),
    downs INTEGER,
    created_utc INTEGER,
    controversiality INTEGER,
    edited BOOLEAN,
    gilded INTEGER,
    author_flair_css_class TEXT,
    id VARCHAR(16),
    author VARCHAR(32),
    retrieved_on INTEGER,
    score_hidden BOOLEAN,
    subreddit_id VARCHAR(32),
    score INTEGER,
    name VARCHAR(16),
    author_flair_text TEXT,
    link_id VARCHAR(16),
    archived BOOLEAN,
    ups INTEGER,
    parent_id VARCHAR(16),
    subreddit VARCHAR(32),
    body TEXT
);

CREATE TABLE IF NOT EXISTS submissions (
    downs INTEGER,
    url TEXT,
    id VARCHAR(16),
    edited BOOLEAN,
    num_reports REAL,
    created_utc INTEGER,
    name VARCHAR(16),
    title VARCHAR(512),
    author VARCHAR(32),
    permalink VARCHAR(128),
    num_comments INTEGER,
    likes BOOLEAN,
    subreddit_id VARCHAR(32),
    ups INTEGER
);

CREATE TABLE IF NOT EXISTS submissions (
    downs INTEGER,
    url TEXT,
    id VARCHAR(16),
    edited BOOLEAN,
    num_reports INTEGER,
    created_utc INTEGER,
    name VARCHAR(16),
    title VARCHAR(512),
    author VARCHAR(32),
    permalink VARCHAR(128),
    num_comments INTEGER,
    likes BOOLEAN,
    subreddit_id VARCHAR(32),
    ups INTEGER
);

CREATE TABLE IF NOT EXISTS subreddits (
    banner_background_image VARCHAR(256),
    created_utc INTEGER,
    description TEXT,
    display_name VARCHAR(32),
    header_img VARCHAR(128),
    hide_ads BOOLEAN,
    id VARCHAR(16),
    over18 BOOLEAN,
    public_description VARCHAR(1024),
    retrieved_utc INTEGER,
    name VARCHAR(32),
    subreddit_type VARCHAR(16),
    subscribers REAL,
    title VARCHAR(128),
    whitelist_status VARCHAR(16)
);

CREATE EXTENSION pg_bulkload;
