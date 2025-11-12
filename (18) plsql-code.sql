
-- ========================================================
-- 🧩 Part (a) — Track UPDATE / DELETE on clientmstr
-- ========================================================
-- Step 1: Create Tables
CREATE TABLE clientmstr (
  client_id INT PRIMARY KEY,
  name VARCHAR(50),
  balance DECIMAL(10,2)
);

CREATE TABLE audit_trade (
  audit_id INT AUTO_INCREMENT PRIMARY KEY,
  client_id INT,
  name VARCHAR(50),
  balance DECIMAL(10,2),
  action_type VARCHAR(10),
  action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Step 2: Create Triggers
DELIMITER $$

CREATE TRIGGER trg_clientmstr_update
BEFORE UPDATE ON clientmstr
FOR EACH ROW
BEGIN
  INSERT INTO audit_trade (client_id, name, balance, action_type)
  VALUES (OLD.client_id, OLD.name, OLD.balance, 'UPDATE');
END $$

CREATE TRIGGER trg_clientmstr_delete
BEFORE DELETE ON clientmstr
FOR EACH ROW
BEGIN
  INSERT INTO audit_trade (client_id, name, balance, action_type)
  VALUES (OLD.client_id, OLD.name, OLD.balance, 'DELETE');
END $$

DELIMITER ;

-- Step 3: Insert Sample Data
INSERT INTO clientmstr VALUES (1, 'Ravi', 20000.00);
INSERT INTO clientmstr VALUES (2, 'Sonia', 30000.00);
INSERT INTO clientmstr VALUES (3, 'Kiran', 25000.00);

-- Step 4: Test UPDATE Trigger
UPDATE clientmstr
SET balance = balance + 1000
WHERE client_id = 2;


-- ✅ Expected result:
-- Record in clientmstr updated.
-- Old record (before update) inserted into audit_trade.

-- Check it:
SELECT * FROM audit_trade;

-- Step 5: Test DELETE Trigger
DELETE FROM clientmstr WHERE client_id = 3;


-- Now check again:
SELECT * FROM audit_trade;


-- ========================================================
-- 🧩 Part (b) — Salary Check Trigger (Insert/Update)
-- ========================================================

-- Step 1: Create Tables
CREATE TABLE Emp (
  e_no INT PRIMARY KEY,
  e_name VARCHAR(50),
  salary DECIMAL(10,2)
);

CREATE TABLE Tracking (
  track_id INT AUTO_INCREMENT PRIMARY KEY,
  e_no INT,
  salary DECIMAL(10,2),
  action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Step 2: Create Triggers
DELIMITER $$

CREATE TRIGGER trg_emp_before_insert
BEFORE INSERT ON Emp
FOR EACH ROW
BEGIN
  IF NEW.salary < 50000 THEN
    INSERT INTO Tracking (e_no, salary) VALUES (NEW.e_no, NEW.salary);
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Error: Salary must be at least 50000 for insert.';
  END IF;
END $$

CREATE TRIGGER trg_emp_before_update
BEFORE UPDATE ON Emp
FOR EACH ROW
BEGIN
  IF NEW.salary < 50000 THEN
    INSERT INTO Tracking (e_no, salary) VALUES (NEW.e_no, NEW.salary);
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Error: Salary must be at least 50000 for update.';
  END IF;
END $$

DELIMITER ;

-- Step 3: Test Insert Trigger
-- This will succeed
INSERT INTO Emp VALUES (1, 'Amit', 60000);

-- This will FAIL and log in Tracking
INSERT INTO Emp VALUES (2, 'Neha', 40000);


-- ✅ Output:
-- ERROR 1644 (45000): Error: Salary must be at least 50000 for insert.

-- Check Tracking:
SELECT * FROM Tracking;


-- Increase salary (works fine)
UPDATE Emp SET salary = 70000 WHERE e_no = 1;

-- Try decreasing salary below limit (will fail)
UPDATE Emp SET salary = 30000 WHERE e_no = 1;


-- ✅ Output:
-- ERROR 1644 (45000): Error: Salary must be at least 50000 for update.


-- Check Tracking again:
SELECT * FROM Tracking;