CREATE DATABASE organization;
USE organization;

-- Employee table
CREATE TABLE employee (
    emp_name VARCHAR(50) PRIMARY KEY,
    street VARCHAR(50),
    city VARCHAR(50)
);

-- Works table
CREATE TABLE works (
    emp_name VARCHAR(50),
    company_name VARCHAR(50),
    salary DECIMAL(10,2),
    FOREIGN KEY (emp_name) REFERENCES employee(emp_name)
);

-- Company table
CREATE TABLE company (
    company_name VARCHAR(50) PRIMARY KEY,
    city VARCHAR(50)
);

-- Manages table
CREATE TABLE manages (
    emp_name VARCHAR(50),
    manager_name VARCHAR(50)
);

-- Companies
INSERT INTO company VALUES
('First Bank Corporation', 'Mumbai'),
('Small Bank Corporation', 'Pune'),
('Tech Solutions', 'Delhi'),
('FinCorp', 'Mumbai');

-- Employees
INSERT INTO employee VALUES
('Ishaan', 'MG Road', 'Mumbai'),
('Riya', 'Park Street', 'Pune'),
('Aman', 'Link Road', 'Delhi'),
('Tara', 'FC Road', 'Pune'),
('Ravi', 'Marine Drive', 'Mumbai');

-- Works Table
INSERT INTO works VALUES
('Ishaan', 'First Bank Corporation', 12000),
('Riya', 'Small Bank Corporation', 9500),
('Aman', 'Tech Solutions', 15000),
('Tara', 'First Bank Corporation', 8000),
('Ravi', 'FinCorp', 11000);

-- Manages Table
INSERT INTO manages VALUES
('Ishaan', 'Ravi'),
('Riya', 'Aman'),
('Aman', 'Ravi'),
('Tara', 'Ishaan'),
('Ravi', 'NULL');


--1️⃣ Find the names of all employees who work for First Bank Corporation
SELECT emp_name
FROM works
WHERE company_name = 'First Bank Corporation';


--2️⃣ Find all employees who do not work for First Bank Corporation
SELECT emp_name
FROM works
WHERE company_name <> 'First Bank Corporation';


--3️⃣ Find the company that has the most employees
SELECT company_name, COUNT(emp_name) AS Total_Employees
FROM works
GROUP BY company_name
ORDER BY Total_Employees DESC
LIMIT 1;


--4️⃣ Find all companies located in every city in which Small Bank Corporation is located
SELECT company_name
FROM company
WHERE city IN (
    SELECT city
    FROM company
    WHERE company_name = 'Small Bank Corporation'
);


--5️⃣ Find details of employee having salary greater than 10,000
SELECT e.emp_name, e.street, e.city, w.salary
FROM employee e
JOIN works w ON e.emp_name = w.emp_name
WHERE w.salary > 10000;


--6️⃣ Update salary of all employees who work for First Bank Corporation by 10%
UPDATE works
SET salary = salary * 1.10
WHERE company_name = 'First Bank Corporation';

--7️⃣ Find employee and their managers
SELECT emp_name, manager_name
FROM manages;


--8️⃣ Find the names, street, and cities of all employees who work for First Bank Corporation and earn more than 10,000
SELECT e.emp_name, e.street, e.city
FROM employee e
JOIN works w ON e.emp_name = w.emp_name
WHERE w.company_name = 'First Bank Corporation' AND w.salary > 10000;


--9️⃣ Find those companies whose employees earn a higher average salary than the average salary at First Bank Corporation
SELECT company_name
FROM works
GROUP BY company_name
HAVING AVG(salary) > (
    SELECT AVG(salary)
    FROM works
    WHERE company_name = 'First Bank Corporation'
);
