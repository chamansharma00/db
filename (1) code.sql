CREATE DATABASE company;
USE company;

CREATE TABLE dept (
    deptno INT PRIMARY KEY,
    deptname VARCHAR(30),
    location VARCHAR(30)
);

CREATE TABLE emp (
    eno INT PRIMARY KEY,
    ename VARCHAR(30),
    job VARCHAR(30),
    hiredate DATE,
    salary DECIMAL(10,2),
    commission DECIMAL(10,2),
    deptno INT,
    FOREIGN KEY (deptno) REFERENCES dept(deptno)
);

INSERT INTO dept VALUES 
(10, 'HR', 'Pune'),
(20, 'Sales', 'Mumbai'),
(30, 'Dev', 'Delhi');


INSERT INTO emp VALUES
(1, 'Ishaan', 'Manager', '1981-05-20', 50000, 2000, 10),
(2, 'Ira', 'Clerk', '1983-10-15', 20000, NULL, 10),
(3, 'Ramesh', 'Salesman', '1982-02-11', 25000, 3000, 20),
(4, 'Suresh', 'Salesman', '1981-01-22', 28000, 1500, 20),
(5, 'Indra', 'Analyst', '1980-12-05', 35000, NULL, 30),
(6, 'Karan', 'Developer', '1982-05-30', 40000, NULL, 30);

--1. List the maximum salary paid to salesman
SELECT MAX(salary) AS Max_Salary
FROM emp
WHERE job = 'Salesman';

--2️.List name of employees whose name starts with ‘I’
SELECT ename
FROM emp
WHERE ename LIKE 'I%';


--3.List details of employees who have joined before ‘30-sept-81’
SELECT *
FROM emp
WHERE hiredate < '1981-09-30';


--4️.List employee details in descending order of their basic salary
SELECT *
FROM emp
ORDER BY salary DESC;


--5️.List number of employees & average salary for dept no ‘20’
SELECT COUNT(*) AS No_of_Employees, AVG(salary) AS Avg_Salary
FROM emp
WHERE deptno = 20;


--6️.List average and minimum salary of employees hiredate-wise for dept no ‘10’
SELECT hiredate, AVG(salary) AS Avg_Salary, MIN(salary) AS Min_Salary
FROM emp
WHERE deptno = 10
GROUP BY hiredate;


--7️.List employee name and its department
SELECT e.ename, d.deptname
FROM emp e
JOIN dept d ON e.deptno = d.deptno;


--8️.List total salary paid to each department
SELECT d.deptname, SUM(e.salary) AS Total_Salary
FROM emp e
JOIN dept d ON e.deptno = d.deptno
GROUP BY d.deptname;


--9️.List details of employee working in ‘Dev’ department
SELECT e.*
FROM emp e
JOIN dept d ON e.deptno = d.deptno
WHERE d.deptname = 'Dev';


-- 10.Update salary of all employees in deptno 10 by 5%
UPDATE emp
SET salary = salary * 1.05
WHERE deptno = 10;