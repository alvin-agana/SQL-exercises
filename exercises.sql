/* 500 Users Exercises */

/* Find earliest date that a user joined */
SELECT 
    DATE_FORMAT(MIN(created_at), "%M %D, %Y") AS earliest_date
FROM users;


/* Find the email of the earliest user */
SELECT 
    email AS user,
    DATE_FORMAT(MIN(created_at), "%M %D, %Y") AS earliest_date
FROM users WHERE created_at = (SELECT MIN(created_at) FROM users);

/* Count how many users according to the month they joined */
SELECT 
    MONTHNAME(created_at) as month,
    COUNT(MONTHNAME(created_at)) as user_count
FROM users
GROUP BY month
ORDER BY user_count DESC;

/* Count number of users with yahoo emails */
SELECT
    COUNT(email) AS 'yahoo users'
FROM users
WHERE email LIKE '%@yahoo.com';

/* Calculate total number of users for each email host */
SELECT
    CASE    
        WHEN email LIKE '%@gmail.com' THEN 'gmail'
        WHEN email LIKE '%@yahoo.com' THEN 'yahoo'
        WHEN email LIKE '%@hotmail.com' THEN 'hotmail'
        ELSE 'other'
    END as email_provider,
    COUNT(email) AS number_of_users
FROM users
GROUP BY email_provider
ORDER BY number_of_users DESC;