/* Tables for reference */
CREATE TABLE users (
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE photos (
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    image_url VARCHAR(255) NOT NULL,
    user_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY(user_id) REFERENCES users(id)
);

CREATE TABLE comments (
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    comment_text VARCHAR(255) NOT NULL,
    photo_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY(photo_id) REFERENCES photos(id),
    FOREIGN KEY(user_id) REFERENCES users(id)
);

CREATE TABLE likes (
    user_id INTEGER NOT NULL,
    photo_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY(user_id) REFERENCES users(id),
    FOREIGN KEY(photo_id) REFERENCES photos(id),
    PRIMARY KEY(user_id, photo_id)
);

CREATE TABLE follows (
    follower_id INTEGER NOT NULL,
    followee_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY(follower_id) REFERENCES users(id),
    FOREIGN KEY(followee_id) REFERENCES users(id),
    PRIMARY KEY(follower_id, followee_id)
);

CREATE TABLE tags (
  id INTEGER AUTO_INCREMENT PRIMARY KEY,
  tag_name VARCHAR(255) UNIQUE,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE photo_tags (
    photo_id INTEGER NOT NULL,
    tag_id INTEGER NOT NULL,
    FOREIGN KEY(photo_id) REFERENCES photos(id),
    FOREIGN KEY(tag_id) REFERENCES tags(id),
    PRIMARY KEY(photo_id, tag_id)
);

/* IG clone exercises */ 

/* Find the 5 oldest users */
SELECT username, created_at
FROM users
ORDER BY created_at LIMIT 5;


/* What day of the week do most users register on? */
SELECT 
    DAYNAME(created_at) AS day,
    COUNT(*) AS users
FROM users
GROUP BY day
ORDER BY users DESC;

/* Find the users who have never posted a photo */
SELECT 
    username AS 'Inactive users'
FROM users
LEFT JOIN photos
ON users.id = photos.user_id
WHERE photos.user_id IS NULL;


/* Who has the most likes on a photo? What is the single most liked photo? */
SELECT 
    user_id,
    photo_id,
    COUNT(photo_id) AS likes
FROM likes 
INNER JOIN users
GROUP BY photo_id
ORDER BY likes DESC LIMIT 1;


/* Average number of times a user posts */
SELECT
    ROUND((SELECT COUNT(*) FROM photos) / (SELECT COUNT(*) FROM users),2) AS avg;



/* What are the top 5 most commonly used hashtags? */
SELECT 
    tags.tag_name,
    COUNT(photo_tags.tag_id) AS amount
FROM tags
JOIN photo_tags
    ON tags.id = photo_tags.tag_id
GROUP BY tags.id
ORDER BY amount DESC LIMIT 5;

/* Find users who have liked every single photo on the site */ 
SELECT
    username, 
    COUNT(likes.user_id) AS total
FROM likes
JOIN users
    ON likes.user_id = users.id
GROUP BY likes.user_id
HAVING total = (SELECT COUNT(*) FROM photos);


