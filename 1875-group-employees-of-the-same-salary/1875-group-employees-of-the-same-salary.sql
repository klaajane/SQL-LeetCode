-- clarifying questions:
    --> should the table returns no records if there is only one employee_id?

-- approach:
    -- 1/ assign the ranks based on salary (WINDOW FUNCTIONs: DENSE_RANK)
    -- 2/ only return teams with at least two people (GROUP BY & COUNT)


SELECT DISTINCT
    e1.employee_id,
    e1.name,
    e1.salary,
    DENSE_RANK() OVER (
        ORDER BY e1.salary 
    ) AS team_id
FROM employees e1
JOIN employees e2
    ON e1.employee_id <> e2.employee_id
    AND e1.salary = e2.salary
ORDER BY 
    team_id,
    employee_id