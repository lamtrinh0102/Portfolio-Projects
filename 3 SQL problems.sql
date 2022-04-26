/*1. Write an SQL query to report all customers who never order anything*/

SELECT name
FROM Customers
WHERE NOT EXISTS 
(SELECT *
 FROM Orders
 WHERE Customers.id = Orders.Customerid);

/*2. Write an SQL query to report the second highest salary from the Employee table. If there is no second highest salary, the query should report null.*/

WITH rank_salary AS (
SELECT *, 
  RANK() OVER (ORDER BY Salary DESC) AS ranks
FROM Employee)

SELECT DISTINCT salary AS SecondHighestSalary
FROM rank_salary
WHERE ranks = 2

/*3. Write an SQL query to display the records with three or more rows with consecutive id's, and the number of people is greater than or equal to 100 for each. (HARD)*/

WITH 
CTE_Group AS (
SELECT *,  id - ROW_NUMBER () OVER (ORDER BY id) AS grp
FROM Stadium
WHERE people > 100),
CTE_Count AS (
SELECT id,visit_date,people, COUNT(*) OVER (PARTITION BY grp) AS cnt 
FROM CTE_Group)

SELECT id, visit_date, people
FROM CTE_Count
WHERE cnt > 3