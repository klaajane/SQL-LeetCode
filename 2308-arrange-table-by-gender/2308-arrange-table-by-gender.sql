-- clarifying questions:
    --> 

--> approach:
    --> create some helper functions to help me sort the columns as desired

WITH gender_with_rnks AS (
    SELECT
        user_id,
        gender,
        
        -- 1/ id sort rank helper function:
        DENSE_RANK() OVER (
            PARTITION BY gender
            ORDER BY user_id
        ) AS id_sort_rnk,

        -- 2/ gender sort helper:
        CASE 
            WHEN gender = 'female' THEN 1
            WHEN gender = 'other' THEN 2
            WHEN gender = 'male' THEN 3
        END AS gender_sort

    FROM genders
)

SELECT user_id, gender
FROM gender_with_rnks
ORDER BY id_sort_rnk, gender_sort 