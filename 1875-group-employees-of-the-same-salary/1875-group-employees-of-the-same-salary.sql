-- clarifying questions:
    --> should the table returns no records if there is only one employee_id?

-- approach:
    -- 1/ assign the ranks based on salary (WINDOW FUNCTIONs: DENSE_RANK)
    -- 2/ only return teams with at least two people (GROUP BY & COUNT)


SELECT
    employee_id,
    name,
    salary,
    DENSE_RANK() OVER (
        ORDER BY salary 
    ) AS team_id
FROM employees
WHERE salary IN (SELECT salary FROM employees GROUP BY 1 HAVING COUNT(*) > 1)
ORDER BY 
    team_id,
    employee_id

-- why do we need DISTINCT in a self-join?
-- why DENSE_RANK and not RANK or ROW_NUMBER?