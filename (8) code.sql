-- ================================================================
-- EMPLOYEE DUTY ALLOCATION DATABASE (Set 8)
-- ================================================================

-- 1️⃣ Create Database
CREATE DATABASE employee_duty_allocation_db;
USE employee_duty_allocation_db;

-- ================================================================
-- 2️⃣ Create Tables
-- ================================================================

CREATE TABLE Employee (
    emp_no INT PRIMARY KEY,
    name VARCHAR(50),
    skill VARCHAR(30),
    pay_rate DECIMAL(10,2)
);

CREATE TABLE Position (
    posting_no INT PRIMARY KEY,
    skill VARCHAR(30)
);

CREATE TABLE Duty_allocation (
    posting_no INT,
    emp_no INT,
    day DATE,
    shift VARCHAR(20),
    FOREIGN KEY (posting_no) REFERENCES Position(posting_no),
    FOREIGN KEY (emp_no) REFERENCES Employee(emp_no)
);

-- ================================================================
-- 3️⃣ Insert Sample Data
-- ================================================================

INSERT INTO Employee VALUES
(123458, 'Ravi', 'Chef', 2500.00),
(123459, 'Meera', 'Waiter', 1800.00),
(123460, 'Ishaan', 'Chef', 2700.00),
(123461, 'XYZ', 'Manager', 3000.00),
(123462, 'Tara', 'Chef', 2600.00),
(123463, 'Aman', 'Waiter', 1700.00);

INSERT INTO Position VALUES
(1, 'Chef'),
(2, 'Waiter'),
(3, 'Manager');

INSERT INTO Duty_allocation VALUES
(1, 123458, '1986-04-02', 'Morning'),
(1, 123460, '1986-04-04', 'Evening'),
(2, 123459, '1986-04-03', 'Morning'),
(3, 123461, '1986-04-05', 'Night'),
(3, 123461, '1986-04-06', 'Evening'),
(1, 123462, '1986-04-07', 'Morning'),
(2, 123463, '1986-04-08', 'Night'),
(1, 123462, '1986-04-09', 'Evening');

-- ================================================================
-- 4️⃣ QUERIES
-- ================================================================

-- 1️⃣ Get the duty allocation details for emp_no 123461 for the month of April 1986
SELECT * 
FROM Duty_allocation
WHERE emp_no = 123461 
  AND MONTH(day) = 4 
  AND YEAR(day) = 1986;

-- 2️⃣ Find the shift details for Employee 'XYZ'
SELECT d.shift, d.day, p.skill
FROM Duty_allocation d
JOIN Employee e ON d.emp_no = e.emp_no
JOIN Position p ON d.posting_no = p.posting_no
WHERE e.name = 'XYZ';

-- 3️⃣ Get employees whose rate of pay is >= the rate of pay of employee 'XYZ'
SELECT * 
FROM Employee
WHERE pay_rate >= (
    SELECT pay_rate FROM Employee WHERE name = 'XYZ'
);

-- 4️⃣ Get names and pay rates of employees with emp_no < 123460
--     whose pay_rate > pay_rate of at least one emp_no >= 123460
SELECT name, pay_rate
FROM Employee e1
WHERE e1.emp_no < 123460
  AND pay_rate > ANY (
      SELECT e2.pay_rate 
      FROM Employee e2 
      WHERE e2.emp_no >= 123460
  );

-- 5️⃣ Find names of employees assigned to all positions that require a Chef’s skill
SELECT e.name
FROM Employee e
WHERE e.skill = 'Chef'
AND NOT EXISTS (
    SELECT p.posting_no
    FROM Position p
    WHERE p.skill = 'Chef'
      AND p.posting_no NOT IN (
          SELECT d.posting_no
          FROM Duty_allocation d
          WHERE d.emp_no = e.emp_no
      )
);

-- 6️⃣ Find employees with the lowest pay rate
SELECT * 
FROM Employee
WHERE pay_rate = (SELECT MIN(pay_rate) FROM Employee);

-- 7️⃣ Get employee numbers of all employees working on at least two dates
SELECT emp_no
FROM Duty_allocation
GROUP BY emp_no
HAVING COUNT(DISTINCT day) >= 2;

-- 8️⃣ Get names of employees with the skill of Chef who are assigned a duty
SELECT DISTINCT e.name
FROM Employee e
JOIN Duty_allocation d ON e.emp_no = d.emp_no
WHERE e.skill = 'Chef';

-- 9️⃣ Get a list of employees not assigned a duty
SELECT e.name
FROM Employee e
WHERE e.emp_no NOT IN (SELECT emp_no FROM Duty_allocation);

-- 🔟 Get a count of different employees on each shift
SELECT shift, COUNT(DISTINCT emp_no) AS total_employees
FROM Duty_allocation
GROUP BY shift;

