-- clarifying questions:
    -- the table only includes Senior and Junior candidates?


-- approach:
    -- 0/ data prep:
    
    WITH cumulative_salary_by_experience AS (
        SELECT
        employee_id,
        experience,
        SUM(salary) OVER (
            PARTITION BY experience 
            ORDER BY salary
            ROWS UNBOUNDED PRECEDING
            ) AS cumulative_sum
    FROM candidates
    )

    -- 1/ find out the qualifying Seniors (calculate the cum sum of Senior salaries)
,
    qualified_seniors AS (
    SELECT employee_id, experience, cumulative_sum
    FROM cumulative_salary_by_experience
    WHERE 
        experience = 'Senior' 
        AND
        cumulative_sum <= 70000
    )

    -- 2/ find out the qualifying Juniors
,

    qualified_juniors AS (
    SELECT employee_id, experience, cumulative_sum
    FROM cumulative_salary_by_experience
    WHERE 
        experience = 'Junior'
        AND
        cumulative_sum <= 70000 - (SELECT COALESCE(MAX(cumulative_sum), 0) FROM qualified_seniors)
    )

SELECT 'Senior' AS experience, COUNT(*) AS accepted_candidates FROM qualified_seniors
    UNION ALL
SELECT 'Junior' AS experience, COUNT(*) AS accepted_candidates FROM qualified_juniors
