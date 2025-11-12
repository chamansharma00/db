-- 🅰️ (a) Attendance check procedure (MySQL version)
-- ✅ Create table first:
CREATE TABLE Stud (
    Roll INT PRIMARY KEY,
    Att DECIMAL(5,2),
    Status VARCHAR(5)
);

-- Sample data
INSERT INTO Stud VALUES (1, 80.5, NULL), (2, 70.0, NULL), (3, 90.0, NULL);

-- ✅ Procedure (with IF condition and message output)
DELIMITER //

CREATE PROCEDURE CheckAttendance(IN roll_no INT)
BEGIN
    DECLARE attendance DECIMAL(5,2);

    -- Check if roll number exists
    SELECT Att INTO attendance FROM Stud WHERE Roll = roll_no;

    IF attendance < 75 THEN
        UPDATE Stud SET Status = 'D' WHERE Roll = roll_no;
        SELECT 'Term not granted' AS Message;
    ELSE
        UPDATE Stud SET Status = 'ND' WHERE Roll = roll_no;
        SELECT 'Term granted' AS Message;
    END IF;

END //

DELIMITER ;

-- 🧪 Run command:
CALL CheckAttendance(2);

-- ✅ View result:
SELECT * FROM Stud;

-- 🅱️ (b) Withdrawal with user-defined exception handling

-- MySQL doesn’t have EXCEPTION like PL/SQL,
-- but we can simulate it using conditional checks + SIGNAL (to raise custom errors).

-- ✅ Create table:
CREATE TABLE account_master (
    acc_no INT PRIMARY KEY,
    balance DECIMAL(10,2)
);

-- Sample data
INSERT INTO account_master VALUES (101, 5000.00), (102, 2000.00);

-- ✅ Procedure (using SIGNAL for custom exception)
DELIMITER //

CREATE PROCEDURE WithdrawAmount(IN acc INT, IN amount DECIMAL(10,2))
BEGIN
    DECLARE curr_balance DECIMAL(10,2);

    SELECT balance INTO curr_balance FROM account_master WHERE acc_no = acc;

    IF curr_balance IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Account not found';
    ELSEIF amount > curr_balance THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient balance!';
    ELSE
        UPDATE account_master
        SET balance = balance - amount
        WHERE acc_no = acc;
        SELECT CONCAT('Withdrawal of ', amount, ' successful. Remaining balance: ', (curr_balance - amount)) AS Message;
    END IF;
END //

DELIMITER ;

-- 🧪 Run commands:
CALL WithdrawAmount(102, 2500);   -- will raise "Insufficient balance"
CALL WithdrawAmount(101, 2000);   -- will succeed

-- ✅ Check result:
SELECT * FROM account_master;