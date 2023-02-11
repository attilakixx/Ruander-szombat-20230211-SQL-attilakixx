-- Megoldasok
USE classicmodels;

-- 1. List all the employees who reports to Mary Patterson!

SELECT concat(firstName, " ", lastName) AS "Name"
FROM employees
WHERE reportsTo =
    (SELECT employeeNumber
     FROM employees
     WHERE firstName like "Mary"
       AND lastName like "Patterson");

-- 2. How many sales rep works in the NYC office?

SELECT count(employeeNumber)AS "Number of sales reps in NYC"
FROM employees
INNER JOIN offices ON offices.officeCode = employees.officeCode
WHERE jobTitle like "sales rep"
  AND offices.city like "NYC";

-- 3.How many percent of all the orders are not shipped?

SELECT 100.0 * SUM(status <> 'Shipped') / COUNT(*) AS "Percent of orders not shipped"
FROM orders;

-- 4. Which customer copleted the highest amount of total payment?

SELECT customerName,
       SUM(priceEach * quantityOrdered) AS "Total order price"
FROM customers
INNER JOIN orders ON orders.customerNumber = customers.customerNumber
INNER JOIN orderdetails ON orderdetails.orderNumber = orders.orderNumber
GROUP BY customerName
HAVING SUM(priceEach * quantityOrdered) =
  (SELECT MAX(s)
   FROM
     (SELECT SUM(priceEach * quantityOrdered) AS s
      FROM customers
      INNER JOIN orders ON orders.customerNumber = customers.customerNumber
      INNER JOIN orderdetails ON orderdetails.orderNumber = orders.orderNumber
      GROUP BY customerName) AS x);

-- 5. List the 3 productlines that has the most products.

SELECT productlines.productLine,
       count(productCode)
FROM productlines
INNER JOIN products ON productlines.productLine = products.productLine
GROUP BY productlines.productLine
ORDER BY 2 DESC
LIMIT 3;

-- 6. From which products were the no orders at all?

SELECT productName,
       products.productCode
FROM products
LEFT JOIN orderdetails ON products.productCode = orderdetails.productCode
WHERE orderdetails.productCode IS NULL;

-- 7. Who ordered from the most expensive product?

SELECT customers.customerName,
       products.MSRP,
       products.productName
FROM customers
INNER JOIN orders ON customers.customerNumber = orders.customerNumber
INNER JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber
INNER JOIN products ON orderdetails.productCode = products.productCode
WHERE products.MSRP =
    (SELECT max(products.MSRP)
     FROM products)
GROUP BY customers.customerNumber;

-- 8. List the employees of the office that has the postal code 94080!

SELECT concat(firstName, " ", lastName) AS "Name"
FROM employees
INNER JOIN offices ON employees.officeCode = offices.officeCode
WHERE offices.postalCode like "94080";

-- 9. List the 10 most recent shipped orders.

SELECT *
FROM orders
INNER JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber
GROUP BY orders.orderNumber
ORDER BY orderDate DESC
LIMIT 10;

-- 10. Which customers have ordered a product, that has 'Ford' or 'Honda' in its name?

SELECT customers.customerName
FROM products
INNER JOIN orderdetails ON products.productCode = orderdetails.productCode
INNER JOIN orders ON orders.orderNumber = orderdetails.orderNumber
INNER JOIN customers ON orders.customerNumber = customers.customerNumber
WHERE products.productName like "%Honda%"
  OR products.productName like "%Ford%"
GROUP BY customers.customerName;