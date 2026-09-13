--> Appraoch:
    --> 1/ find what the most frequent product (rnk = 1) purhcased (COUNT() & DENSE_RANK)

    WITH orders_ranked AS (
        SELECT
            customer_id,
            product_id,
            COUNT(product_id) AS product_count,
            DENSE_RANK() OVER (
                PARTITION BY customer_id 
                ORDER BY COUNT(product_id) DESC
            ) AS rnk
        FROM orders
        GROUP BY customer_id, product_id
    )

    --> 2/ find out the name of the price (JOIN to products to pull the name)

    SELECT
        o.customer_id,
        o.product_id,
        p.product_name
    FROM orders_ranked o
    JOIN products p
        ON p.product_id = o.product_id
        AND o.rnk = 1