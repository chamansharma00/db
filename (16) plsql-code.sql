-- 🅰️ (a) Activate inactive accounts — using implicit cursor
-- ✅ Step 1: Create table
CREATE TABLE Account (
    acc_no INT PRIMARY KEY,
    status VARCHAR(10),
    last_transaction DATE
);

-- Sample data
INSERT INTO Account VALUES
(101, 'Inactive', '2023-10-01'),
(102, 'Inactive', '2023-08-01'),
(103, 'Active', '2025-10-01'),
(104, 'Inactive', '2024-10-30');

-- ✅ Step 2: Stored Procedure using implicit cursor
DELIMITER //

CREATE PROCEDURE ActivateOldAccounts()
BEGIN
    DECLARE rows_updated INT;

    -- Update all inactive accounts whose last transaction was before 365 days
    UPDATE Account
    SET status = 'Active'
    WHERE status = 'Inactive'
      AND DATEDIFF(CURDATE(), last_transaction) > 365;

    SET rows_updated = ROW_COUNT();

    -- Check using implicit cursor attributes
    IF rows_updated = 0 THEN
        SELECT 'No accounts activated — none were inactive beyond 1 year.' AS Message;
    ELSE
        SELECT CONCAT(rows_updated, ' account(s) activated successfully.') AS Message;
    END IF;
END //

DELIMITER ;

-- 🧪 Run commands
CALL ActivateOldAccounts();
SELECT * FROM Account;


-- ✅ This demonstrates implicit cursor — MySQL automatically opens, fetches, and closes the update operation internally, and ROW_COUNT() behaves like %ROWCOUNT.

-------------------------------------------------------------------------------------------------------------------
-- 🅱️ (b) Increase salary by 10% if below organization average (explicit cursor)
-- ✅ Step 1: Create tables
CREATE TABLE Employee (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    salary DECIMAL(10,2)
);

CREATE TABLE Increment_Salary (
    emp_id INT,
    old_salary DECIMAL(10,2),
    new_salary DECIMAL(10,2),
    increment_date DATE
);

-- Sample data
INSERT INTO Employee VALUES
(101, 'Ravi', 25000.00),
(102, 'Meena', 32000.00),
(103, 'Amit', 28000.00),
(104, 'Priya', 40000.00);

-- ✅ Step 2: Stored Procedure with explicit cursor
DELIMITER //

CREATE PROCEDURE IncreaseSalaryBelowAvg()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE eid INT;
    DECLARE esal DECIMAL(10,2);
    DECLARE avg_sal DECIMAL(10,2);
    DECLARE new_sal DECIMAL(10,2);

    -- Calculate organization average salary
    SELECT AVG(salary) INTO avg_sal FROM Employee;

    -- Declare cursor for employees below average salary
    DECLARE cur CURSOR FOR
        SELECT emp_id, salary FROM Employee WHERE salary < avg_sal;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO eid, esal;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Increase salary by 10%
        SET new_sal = esal + (esal * 0.10);

        -- Update employee table
        UPDATE Employee
        SET salary = new_sal
        WHERE emp_id = eid;

        -- Log the increment
        INSERT INTO Increment_Salary VALUES (eid, esal, new_sal, CURDATE());
    END LOOP;

    CLOSE cur;

    SELECT 'Salary increment process completed.' AS Message;
END //

DELIMITER ;

-- 🧪 Run commands
CALL IncreaseSalaryBelowAvg();

-- See updates
SELECT * FROM Employee;
SELECT * FROM Increment_Salary;
-------------------------------------------------------------------------------------------------------

-- 🅱️ (c) Mark detained students — using explicit cursor
✅ Step 1: Create tables
CREATE TABLE stud21 (
    roll INT,
    att INT,
    status VARCHAR(1)
);

CREATE TABLE D_Stud (
    roll INT,
    att INT,
    detained_date DATE
);

-- Sample data
INSERT INTO stud21 VALUES
(1, 80, 'N'),
(2, 70, 'N'),
(3, 60, 'N'),
(4, 76, 'N');

-- ✅ Step 2: Stored Procedure using explicit cursor
DELIMITER //

CREATE PROCEDURE DetainStudents()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE r INT;
    DECLARE a INT;
    
    -- Declare cursor
    DECLARE cur CURSOR FOR
        SELECT roll, att FROM stud21 WHERE att < 75;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO r, a;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Update status to 'D'
        UPDATE stud21
        SET status = 'D'
        WHERE roll = r;

        -- Insert record into D_Stud
        INSERT INTO D_Stud VALUES (r, a, CURDATE());
    END LOOP;

    CLOSE cur;

    SELECT 'Students with attendance < 75% have been detained.' AS Message;
END //

DELIMITER ;

-- 🧪 Run commands
CALL DetainStudents();

-- See updates
SELECT * FROM stud21;
SELECT * FROM D_Stud;