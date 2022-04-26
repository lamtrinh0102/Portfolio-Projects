/*1. Give me the count of employees?*/ 

SELECT COUNT(DISTINCT employee_id)
FROM employee;

/*2. Give me an avg salary by department?*/

SELECT department  ,
       AVG(salary) AS avg_salary
FROM employee
GROUP BY department;

/*3. Give me a list of buildings where there are no employees in them?*/

SELECT building_name ,
       building_id
FROM building AS b
LEFT JOIN employee AS e ON e.building_id = b.building_id
WHERE employee_id IS NULL;

/*4. Give me a list of employees who earn the second-highest in each department?*/

SELECT first_name ,
       last_name ,
       employee_id
FROM
  (SELECT first_name ,
          last_name ,
          employee_id ,
          DENSE_RANK() OVER(PARTITION BY department
                            ORDER BY salary DESC) 
                                               AS r
   FROM employee)AS table_name
WHERE r = 2;

/*5. Give me a list of employees who have started before their manager?*/

SELECT first_name ,
       last_name
FROM employee AS e1
LEFT JOIN employee AS e2 ON e2.manager_id = e1.employee_id
WHERE e1.start_date < e2.start_date;

/*6. Write a query to show the companies in the US that have no sales yet.*/ 

SELECT catalog.company
FROM CATALOG
WHERE NOT EXISTS
    (SELECT *
     FROM orders
     WHERE orders.item_id = catalog.item_id )
GROUP BY catalog.company;

/*7. Write a SQL query to calculate the total time spent working out by each olympian by day of the week.*/

SELECT oly_id,
       date_at_gym,
       SUM(time_in_hours) AS time_in_hours
FROM
  (SELECT oly_id,
          CONVERT(date,time,101) AS date_at_gym,
          DATEPART(hour,time - PrevInOutTimeStamp) 
          AS time_in_hours
   FROM
     (SELECT *,
             LAG(time, 1, NULL) OVER (PARTITION BY oly_id 
ORDER BY time) AS PrevInOutTimeStamp
      FROM Olympian) AS Olympians
   WHERE Olympian.in_out = 'out' ) AS hours
GROUP BY oly_id,
         date_at_gym;

/*8. Find the number of times each question was solved and the total minutes needed and the difficulty level in the month of December 2018.*/

SELECT members.total_minutes_needed,
       members.number_of_times_solved,
       questions.name,
       questions.level
FROM questions
INNER JOIN
  (SELECT members.question_id,
          COUNT(*) AS number_of_times_solved,
          SUM(members.minutes) AS total_minutes_needed
   FROM members
   WHERE MONTH(start_time) = 12
   GROUP BY members.question_id)AS members 
ON questions.question_id = members.question_id;

/*9. How many unique toys does the company have in inventory?*/

SELECT factory,
       COUNT(*) AS product_count
FROM factory_inventory
GROUP BY factory
ORDER BY factory;

/*10. How many units per factory?*/

SELECT factory,
       SUM(units) AS unit_sum
FROM factory_inventory
GROUP BY factory
ORDER BY factory;

/*11. How much cubic feet of volume does the inventory occupy in each factory?*/

SELECT factory,
       SUM(units * COALESCE(dim.W,0) * COALESCE(dim.L,0) * COALESCE(dim.H,0)) AS unit_dimensions_sum
FROM factory_inventory
INNER JOIN product_dimensions_inches AS dim ON factory_inventory.product = dim.product
GROUP BY factory
ORDER BY factory;

/*12. What percent of cubic feet of volume does each factory contribute to the entire company?*/

SELECT factory,
       CASE
           WHEN total_dimensions_sum = 0 THEN NULL
           ELSE unit_dimensions_sum * 100.0 / total_dimensions_sum
       END AS percentage_of_total
FROM
  (SELECT factory,
          SUM(units * COALESCE(dim.W, 0) * COALESCE(dim.L, 0) * COALESCE(dim.H, 0)) AS unit_dimensions_sum
   FROM factory_inventory
   INNER JOIN product_dimensions_inches AS dim ON factory_inventory.product = dim.product
   GROUP BY factory)AS factory_unit_dimension
CROSS JOIN
  (SELECT SUM(units * COALESCE(dim.W, 0) * COALESCE(dim.L, 0) * COALESCE(dim.H, 0)) AS total_dimensions_sum
   FROM factory_inventory
   INNER JOIN product_dimensions_inches AS dim ON factory_inventory.product = dim.product) AS total
ORDER BY factory;

/*13. How many units of inventory in the company are either missing or have incomplete dimensions?*/

SELECT SUM(units) AS total_units_without_dimensions
FROM factory_inventory
WHERE NOT EXISTS
    (SELECT *
     FROM product_dimensions_inches AS dim
     WHERE factory_inventory.product = dim.product)
  OR EXISTS
    (SELECT *
     FROM product_dimensions_inches AS dim
     WHERE factory_inventory.product = dim.product
       AND ("W" IS NULL
            OR "L" IS NULL
            OR "H" IS NULL));

/*14. What are the 3 most common toys per factory?*/

SELECT factory,
       string_agg(product, ', ')
FROM
  (SELECT factory,
          product,
          units,
          ROW_NUMBER() OVER (PARTITION BY factory
                             ORDER BY units DESC) AS row_number_by_units
   FROM factory_inventory) AS factory_inventory
WHERE row_number_by_units <= 3
GROUP BY factory
ORDER BY factory;

/*15. How many bids were there yesterday?*/ 

SELECT SUM(order_quantity)
FROM bids
WHERE order_datetime = (GETDATE() - 1);

/*16. How many bids have been completed in the last 7 days for each category?*/

SELECT categories.item_category,
       COALESCE(units_ordered, 0) AS units_ordered
FROM
  (SELECT item_category
   FROM items
   GROUP BY item_category) AS categories
LEFT JOIN
  (SELECT SUM(order_quantity) AS units_ordered,
          i.item_category
   FROM bids AS o
   INNER JOIN items AS i ON o.item_id = i.item_id
   WHERE order_datetime <= GETDATE()
     AND order_datetime > (GETDATE() - 7)
   GROUP BY i.item_category)AS totals ON categories.item_category = totals.item_category;

/*17. How many bids have been completed in each category for each day of the week?*/

SELECT categories.item_category,                  CONVERT(date,dates_from_last_week.date_from_last_week,101) AS date_from_last_week,
       COALESCE(total_quantity, 0) AS total_quantity
FROM
  (SELECT item_category
   FROM items
   GROUP BY item_category) AS categories
CROSS JOIN
  (SELECT date_from_last_week
   FROM (
         VALUES (GETDATE()), (GETDATE() - 1), (GETDATE() - 2), (GETDATE() - 3), (GETDATE() - 4), (GETDATE() - 5), (GETDATE() - 6))AS dates(date_from_last_week)) AS dates_from_last_week
LEFT JOIN
  (SELECT item_category,
          order_datetime AS order_date,
          SUM(order_quantity) AS total_quantity
   FROM bids AS o
   INNER JOIN items AS i ON o.item_id = i.item_id
   WHERE order_datetime <= GETDATE()
     AND order_datetime > (GETDATE() - 7)
   GROUP BY item_category,
            order_datetime) AS order_quantities ON order_quantities.item_category = categories.item_category
AND order_quantities.order_date = dates_from_last_week.date_from_last_week;

/*18. Write a query to get the earliest bid_id for each customer for each date that placed a bid.*/ 

SELECT first_order.bid_id,
       CONVERT(date,first_order.order_datetime, 101) AS order_date,
       first_order.customer_id
FROM
  (SELECT order_datetime AS order_date,
          customer_id
   FROM bids
   GROUP BY order_datetime,
            customer_id) AS customer_order_dates
INNER JOIN
  (SELECT bids.*
   FROM
     (SELECT bid_id,
             order_datetime,
             order_datetime AS order_date,
             customer_id,
             ROW_NUMBER() OVER (PARTITION BY order_datetime, customer_id 
ORDER BY order_datetime) AS order_number_of_day
      FROM bids)AS bids
   WHERE order_number_of_day = 1 )AS first_order ON customer_order_dates.order_date = first_order.order_date
AND customer_order_dates.customer_id = first_order.customer_id;

/*19. Write a query to get the second earliest bid_id for each customer for each date they placed > 2 bids.*/

SELECT second_order.bid_id,
       CONVERT(Date,second_order.order_datetime,101) AS order_date,
       second_order.customer_id
FROM
  (SELECT order_datetime AS order_date,
          customer_id
   FROM bids
   GROUP BY order_datetime,
            customer_id) AS customer_order_dates
INNER JOIN
  (SELECT bids.*
   FROM
     (SELECT bid_id,
             order_datetime,
             order_datetime AS order_date,
             customer_id,
             ROW_NUMBER() OVER (PARTITION BY order_datetime,customer_id
ORDER BY order_datetime) AS order_number_of_day
      FROM bids)AS bids
   WHERE order_number_of_day = 2 )AS second_order ON customer_order_dates.order_date = second_order.order_date
AND customer_order_dates.customer_id = second_order.customer_id;

/*20. Write a query to calculate how many customers in the IN
a.	Solved a question in the last month
b.	Submitted a question in the last month
c.	Solved and submitted a question in the last month
i.	(give all the three answers in one query)*/

SELECT submitted_total AS IN_submitted,
       questions_total AS IN_questions,
       submitted_total + questions_total AS IN_submitted_and_questions
FROM
  (SELECT COUNT(*) AS submitted_total
   FROM submitted
   WHERE customer_country = 'IN'
     AND rental_date >= DATEADD(MONTH,-1,GETDATE())
     AND rental_date < GETDATE() )AS submitted
CROSS JOIN
  (SELECT COUNT(*) AS questions_total
   FROM questions
   WHERE customer_country = 'IN'
     AND question_date >= DATEADD(MONTH,-1,GETDATE())
     AND question_date < GETDATE() ) AS questions;

/*21. Among all US customers who submitted a question on Feb-01, what % of them solved a question between Feb-02 and Feb-08?*/

SELECT total_customers_01 AS total_customers_01,
       questions_total_02_08 AS customers_from_01_and_02_through_08,
       CASE
           WHEN total_customers_01 = 0 THEN NULL
           ELSE (CAST(questions_total_02_08 AS FLOAT) * 100.0 / CAST(total_customers_01 AS FLOAT))
       END AS percentage
FROM
  (SELECT COUNT(*) AS total_customers_01
   FROM
     (SELECT customer_id
      FROM questions
      WHERE customer_country = 'US'
        AND question_date = '02/01/2021'
      GROUP BY customer_id)AS unique_customer_who_question_01)AS total_customers
CROSS JOIN
  (SELECT COUNT(*) AS questions_total_02_08
   FROM
     (SELECT customer_id
      FROM questions AS s1
      WHERE customer_country = 'US'
        AND question_date >= '2/2/2021'
        AND question_date <= '2/8/2021'
        AND EXISTS
          (SELECT *
           FROM questions s2
           WHERE s2.customer_country = 'US'
             AND s2.question_date = '2/1/2021'
             AND s1.customer_id = s2.customer_id )
      GROUP BY customer_id) AS unique_customer_who_question_02_08)AS questions;

/*22. Write a query to return, each device type, the top five customers that had the highest minutes spent solving questions during the last 7 days in 'JP'*/

SELECT TOP 5 *
FROM
  (SELECT customer_id,
          SUM(time) AS total_time
   FROM questions
   WHERE customer_country = 'JP'
     AND question_date >= GETDATE() - 7
     AND question_date <= GETDATE()
   GROUP BY customer_id)AS questions
ORDER BY total_time DESC;

/*23. Write a SQL query to return the code_name that was signaled during last 1 week*/

SELECT code_name
FROM code
WHERE EXISTS
    (SELECT *
     FROM signals
     WHERE signals.code_id = code.code_id
       AND order_date <= GETDATE()
       AND order_date > (GETDATE() - 7) );

/*24. Get the code_name(s) that were above 100 signals in the last week?*/

SELECT code_name
FROM code
WHERE EXISTS
    (SELECT *
     FROM signals
     WHERE signals.code_id = code.code_id
       AND order_date <= GETDATE()
       AND order_date > (GETDATE() - 7)
       AND signals.units_sold > 100 );

/*25. Write a SQL to return the code_name that NOT signaled during last 1 week*/

SELECT code_name
FROM code
WHERE NOT EXISTS
    (SELECT *
     FROM signals
     WHERE signals.code_id = code.code_id
       AND order_date <= GETDATE()
       AND order_date > (GETDATE() - 7) );

