-- ================================================================
-- PROJECT ASSIGNMENT DATABASE (Set 7)
-- ================================================================

-- 1️⃣ Create Database
CREATE DATABASE project_assignment_db;
USE project_assignment_db;

-- ================================================================
-- 2️⃣ Create Tables
-- ================================================================

CREATE TABLE Project (
    project_id VARCHAR(10) PRIMARY KEY,
    proj_name VARCHAR(50),
    chief_arch VARCHAR(50)
);

CREATE TABLE Employee (
    Emp_id INT PRIMARY KEY,
    Emp_name VARCHAR(50)
);

CREATE TABLE Assigned_To (
    Project_id VARCHAR(10),
    Emp_id INT,
    FOREIGN KEY (Project_id) REFERENCES Project(project_id),
    FOREIGN KEY (Emp_id) REFERENCES Employee(Emp_id)
);

-- ================================================================
-- 3️⃣ Insert Sample Data
-- ================================================================

-- Projects
INSERT INTO Project VALUES
('C353', 'Database Project', 'Ravi Kumar'),
('C354', 'AI System Design', 'Ishaan Mehta'),
('C453', 'Web Development', 'Tara Patel');

-- Employees
INSERT INTO Employee VALUES
(101, 'Aman'),
(102, 'Riya'),
(103, 'Ishita'),
(104, 'Taran'),
(105, 'Ravi');

-- Assignments
INSERT INTO Assigned_To VALUES
('C353', 101),
('C353', 102),
('C354', 102),
('C354', 103),
('C453', 104),
('C353', 105);

-- ================================================================
-- 4️⃣ QUERIES
-- ================================================================

-- 1️⃣ Get the details of employees working on project C353
SELECT e.Emp_id, e.Emp_name
FROM Employee e
JOIN Assigned_To a ON e.Emp_id = a.Emp_id
WHERE a.Project_id = 'C353';

-- 2️⃣ Get employee number of employees working on project C353
SELECT COUNT(*) AS Total_Employees
FROM Assigned_To
WHERE Project_id = 'C353';

-- 3️⃣ Obtain details of employees working on Database project
SELECT e.Emp_id, e.Emp_name
FROM Employee e
JOIN Assigned_To a ON e.Emp_id = a.Emp_id
JOIN Project p ON a.Project_id = p.project_id
WHERE p.proj_name = 'Database Project';

-- 4️⃣ Get details of employees working on both C353 and C354
SELECT e.Emp_id, e.Emp_name
FROM Employee e
WHERE e.Emp_id IN (
    SELECT Emp_id FROM Assigned_To WHERE Project_id = 'C353'
)
AND e.Emp_id IN (
    SELECT Emp_id FROM Assigned_To WHERE Project_id = 'C354'
);

-- 5️⃣ Get employee numbers of employees who do not work on project C453
SELECT e.Emp_id, e.Emp_name
FROM Employee e
WHERE e.Emp_id NOT IN (
    SELECT Emp_id FROM Assigned_To WHERE Project_id = 'C453'
);

