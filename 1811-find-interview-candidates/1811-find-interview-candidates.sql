--> GOAL:
    --> report name and mail for all interview candidates

--> pseucode:
    --> data prep: unpivot the columns so we can create a one user_id column (UNION ALL)

    WITH contests_unpivoted AS (
        SELECT contest_id, gold_medal AS user_id, 'gold' AS medal_type FROM contests
            UNION ALL 
        SELECT contest_id, silver_medal AS user_id, 'silver' AS medal_type FROM contests
            UNION ALL
        SELECT contest_id, bronze_medal AS user_id, 'bronze' AS medal_type FROM contests
    )
    ,

    --> 1/ find users who won any medal in 3 or more consecutive contests (Gap and Island)
    contests_islands AS (
        SELECT
            user_id,
            contest_id
            -
            ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY contest_id)
            AS island_id
        FROM contests_unpivoted
    ),

    contests_first_condition AS (
        SELECT user_id
        FROM contests_islands
        GROUP BY user_id, island_id
        HAVING COUNT(*) >= 3 
    )
    --> 2/ find users who won GOLD medal in 3 or more contests (WHERE = 'gold')
    ,

    contests_second_condition AS (
        SELECT user_id
        FROM contests_unpivoted
        WHERE medal_type = 'gold'
        GROUP BY user_id
        HAVING COUNT(user_id) >= 3
    )
    ,

    qualified_users AS (
    SELECT user_id FROM contests_first_condition
        UNION 
    SELECT user_id FROM contests_second_condition
    )
    ,

    final_answer AS (
        SELECT
            u.name,
            u.mail
        FROM qualified_users q
        JOIN users u
            ON u.user_id = q.user_id
    )

    SELECT * FROM final_answer