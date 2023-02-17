-- 1. List all the emloyees who reports to Mary Patterson!
	SELECT * FROM employees
    	WHERE `reportsTo` = (SELECT(`employeeNumber`) FROM employees WHERE `lastName` LIKE "Patterson" AND `firstName` LIKE "Mary");

    
-- 2. How many sales rep works in the NYC office?
	SELECT COUNT(`employeeNumber`) AS "Number of 'Sales Rep's in NYC office" FROM employees
    	JOIN offices ON employees.officeCode = offices.officeCode
	WHERE `offices`.`city` LIKE "NYC" AND `employees`.`jobTitle` LIKE "Sales Rep";


-- 3.How many percent of all the orders are not shipped?
	SELECT ((SELECT COUNT(`orderNumber`) FROM orders WHERE `shippedDate` LIKE "" OR `shippedDate` IS NULL) / COUNT(`orderNumber`) * 100) AS "% of the orders what not've been shipped" FROM orders;
    

-- 4. Which customer completed the highest amount of total payment?
	SELECT `customers`.`customerNumber`, `customers`.`customerName` AS "who paid the most for an order", `customers`.`contactLastName`, `customers`.`contactFirstName`, `payments`.`amount` FROM customers
    	JOIN payments ON customers.customerNumber = payments.customerNumber
    	WHERE `payments`.`amount` = (SELECT MAX(`amount`) FROM payments);


-- 5. List the 3 productlines that has the most products.
	SELECT `productLine` AS "Top 3 productLines", COUNT(`productCode`) AS "number of the products in the productLine" FROM products
    	GROUP BY `productLine`
    	ORDER BY 2 DESC
    	LIMIT 3;


-- 6. From which products were the no orders at all?
	SELECT * FROM products
    	LEFT JOIN orderdetails ON products.productCode = orderdetails.productCode
    	WHERE `orderNumber` LIKE "" OR `orderNumber` IS NULL;


-- 7. Who ordered from the most expensive product?
	SELECT DISTINCT `customers`.`customerName` AS "companies who have ordered from the most expensive product", `customers`.`contactLastName`, `customers`.`contactFirstname` FROM products
    	JOIN orderdetails ON products.productCode = orderdetails.productCode
    	JOIN orders ON orders.orderNumber = orderdetails.orderNumber
    	JOIN customers ON customers.customerNumber = orders.customerNumber
    	WHERE `products`.`buyPrice` = (SELECT MAX(`products`.`buyPrice`) FROM products);
    

-- 8. List the employees of the office that has the postal code 94080!
	SELECT `employees`.`employeeNumber`, `employees`.`lastName`, `employees`.`firstName` FROM employees
    	JOIN offices ON employees.officeCode = offices.officeCode
    	WHERE `offices`.`postalCode` = 94080;
	
    
-- 9. List the 10 most recent shipped orders.
	SELECT * FROM orders
    	WHERE status LIKE "Shipped"
    	ORDER BY `shippedDate` DESC
    	LIMIT 10;
    
-- 10. Which customers have ordered a product, that has 'Ford' or 'Honda' in its name?
	SELECT DISTINCT `customers`.`customerName` AS "companies that have ordered from a product what has 'Ford' or a 'Honda' in its name", `customers`.`contactLastName`, `customers`.`contactFirstName` FROM orderDetails
    	JOIN orders ON orderDetails.orderNumber = orders.orderNumber
    	JOIN products ON orderDetails.productCode = products.productCode
    	JOIN customers ON orders.customerNumber = customers.customerNumber
    	WHERE `products`.`productName` LIKE "%Ford%" OR `products`.`productName` LIKE "%Honda%";
