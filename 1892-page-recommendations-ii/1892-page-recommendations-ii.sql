-------------------------------------------- SOLUTION -------------------------------------------
WITH all_friends AS (
SELECT user1_id "user_id", user2_id "friend_id" FROM friendship
    UNION
SELECT user2_id "user_id", user1_id "friend_id" FROM friendship)

,

recommended_pages AS (
    SELECT
        f.user_id,
        l1.page_id,
        COUNT(f.friend_id) AS friends_likes
    FROM all_friends f
    INNER JOIN likes l1
        ON f.friend_id = l1.user_id
    GROUP BY f.user_id, l1.page_id
    ORDER BY f.user_id
)

SELECT *
FROM recommended_pages r
WHERE NOT EXISTS (
    SELECT 1
    FROM likes l
    WHERE l.user_id = r.user_id AND l.page_id = r.page_id
)