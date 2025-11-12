-- ========================================================
-- DATABASE SETUP
-- ========================================================
CREATE DATABASE IF NOT EXISTS CursorDB;
USE CursorDB;

-- ========================================================
-- (a) Implicit Cursor Example
-- ========================================================

-- Create Accounts Table
CREATE TABLE Accounts (
    acc_no INT PRIMARY KEY,
    acc_name VARCHAR(50),
    last_transaction DATE,
    status VARCHAR(10)
);

-- Insert Sample Data
INSERT INTO Accounts VALUES
(101, 'Ravi', DATE_SUB(CURDATE(), INTERVAL 400 DAY), 'Inactive'),
(102, 'Priya', DATE_SUB(CURDATE(), INTERVAL 200 DAY), 'Active'),
(103, 'Amit', DATE_SUB(CURDATE(), INTERVAL 370 DAY), 'Inactive'),
(104, 'Meena', DATE_SUB(CURDATE(), INTERVAL 100 DAY), 'Active');

-- Procedure using Implicit Cursor
DELIMITER //
CREATE PROCEDURE ActivateOldAccounts()
BEGIN
    UPDATE Accounts
    SET status = 'Active'
    WHERE DATEDIFF(CURDATE(), last_transaction) > 365;

    -- Display result using implicit cursor attributes
    SELECT ROW_COUNT() AS 'Number_of_Accounts_Activated';
END //
DELIMITER ;

-- Run Procedure
CALL ActivateOldAccounts();

-- Check Results
SELECT * FROM Accounts;


-- ========================================================
-- (b) Parameterized Cursor Example - Merge RollCall Tables
-- ========================================================

-- Create Tables
CREATE TABLE O_RollCall (
    roll_no INT PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE N_RollCall (
    roll_no INT PRIMARY KEY,
    name VARCHAR(50)
);

-- Insert Data
INSERT INTO O_RollCall VALUES (1, 'Ravi'), (2, 'Amit');
INSERT INTO N_RollCall VALUES (2, 'Amit'), (3, 'Priya'), (4, 'Meena');

-- Procedure using Parameterized Cursor
DELIMITER //
CREATE PROCEDURE MergeRollCall()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE nroll INT;
    DECLARE nname VARCHAR(50);

    DECLARE cur CURSOR FOR SELECT roll_no, name FROM N_RollCall;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO nroll, nname;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Insert only if record does not already exist
        IF NOT EXISTS (SELECT * FROM O_RollCall WHERE roll_no = nroll) THEN
            INSERT INTO O_RollCall VALUES (nroll, nname);
        END IF;
    END LOOP;

    CLOSE cur;

    SELECT 'Data merged successfully' AS Result;
END //
DELIMITER ;

-- Run Procedure
CALL MergeRollCall();

-- Check Results
SELECT * FROM O_RollCall;


-- ========================================================
-- (c) Parameterized Cursor Example - Department Wise Average
-- ========================================================

-- Create Tables
CREATE TABLE EMP (
    e_no INT,
    d_no INT,
    salary DECIMAL(10,2)
);

CREATE TABLE Dept_Salary (
    d_no INT,
    Avg_Salary DECIMAL(10,2)
);

-- Insert Sample Data
INSERT INTO EMP VALUES
(1, 10, 30000),
(2, 10, 25000),
(3, 20, 40000),
(4, 20, 42000),
(5, 30, 20000);

-- Procedure for Department-wise Average Salary
DELIMITER //
CREATE PROCEDURE CalculateDeptSalary()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE dept INT;
    DECLARE avg_sal DECIMAL(10,2);

    DECLARE cur CURSOR FOR
        SELECT d_no, AVG(salary)
        FROM EMP
        GROUP BY d_no;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO dept, avg_sal;
        IF done THEN
            LEAVE read_loop;
        END IF;

        INSERT INTO Dept_Salary VALUES (dept, avg_sal);
    END LOOP;

    CLOSE cur;
    SELECT 'Average salary inserted successfully' AS Message;
END //
DELIMITER ;

-- Run Procedure
CALL CalculateDeptSalary();

-- Check Results
SELECT * FROM Dept_Salary;
