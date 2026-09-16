WITH bus_arrival AS (
    SELECT
        bus_id,
        arrival_time,
        LAG(arrival_time, 1, 0) OVER (ORDER BY arrival_time) "min_time"
    FROM
        Buses)

SELECT
    b.bus_id,
    COUNT(passenger_id) AS "passengers_cnt"
FROM
    bus_arrival b
    LEFT JOIN
        passengers p
        ON p.arrival_time > b.min_time
        AND p.arrival_time <= b.arrival_time
GROUP BY 1
ORDER BY 1

-------------------------------------- NOTES -------------------------------------
--> query goal: report # of users that used each bus using the following criteria:
    --> if t(passenger) <= t(bus) => passenger didn't catch the bus, will use the next
    --> ORDER BY bus_id ASC
----------------------------------------------------------------------------------

-- clarifying questions:
    --> do buses have capacity?
    --> 

