-- 🅰️ (a) User-defined exception when business rule violated
-- Business rule: bal_due must not be less than 0.
-- ✅ Create table
CREATE TABLE client_master (
    client_id INT PRIMARY KEY,
    name VARCHAR(50),
    bal_due DECIMAL(10,2)
);

-- ✅ Stored Procedure
DELIMITER //

CREATE PROCEDURE InsertClient(
    IN cid INT,
    IN cname VARCHAR(50),
    IN bal DECIMAL(10,2)
)
BEGIN
    -- Business Rule Check
    IF bal < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Business Rule Violated: Balance due cannot be negative';
    ELSE
        INSERT INTO client_master VALUES (cid, cname, bal);
        SELECT 'Client inserted successfully!' AS Message;
    END IF;
END //

DELIMITER ;

-- 🧪 Run commands
CALL InsertClient(1, 'Ramesh', 500);     -- ✅ OK
CALL InsertClient(2, 'Suresh', -200);    -- ❌ Will raise custom error

-- ✅ View table
SELECT * FROM client_master;

-- 🅱️ (b) Fine calculation and exception handling
-- ✅ Create tables
CREATE TABLE Borrow (
    Roll_no INT,
    Name VARCHAR(50),
    DateofIssue DATE,
    NameofBook VARCHAR(50),
    Status CHAR(1)     -- 'I' = Issued, 'R' = Returned
);

CREATE TABLE Fine (
    Roll_no INT,
    Date DATE,
    Amt DECIMAL(10,2)
);

-- Sample Data
INSERT INTO Borrow VALUES
(1, 'Amit', '2025-10-10', 'DBMS', 'I'),
(2, 'Ravi', '2025-11-01', 'CNS', 'I');

-- ✅ Stored Procedure
DELIMITER //

CREATE PROCEDURE ReturnBook(
    IN roll INT,
    IN book_name VARCHAR(50),
    IN return_date DATE
)
BEGIN
    DECLARE issue_date DATE;
    DECLARE days_late INT;
    DECLARE fine_amt DECIMAL(10,2);
    
    -- Get issue date
    SELECT DateofIssue INTO issue_date
    FROM Borrow
    WHERE Roll_no = roll AND NameofBook = book_name;
    
    -- If book not found
    IF issue_date IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No such book issued to this roll number';
    END IF;
    
    -- Calculate days
    SET days_late = DATEDIFF(return_date, issue_date);
    
    -- Fine calculation logic
    IF days_late > 30 THEN
        SET fine_amt = (days_late * 50);
    ELSEIF days_late >= 15 THEN
        SET fine_amt = (days_late * 5);
    ELSE
        SET fine_amt = 0;
    END IF;
    
    -- Update status
    UPDATE Borrow
    SET Status = 'R'
    WHERE Roll_no = roll AND NameofBook = book_name;
    
    -- Insert fine if applicable
    IF fine_amt > 0 THEN
        INSERT INTO Fine VALUES (roll, return_date, fine_amt);
        SELECT CONCAT('Fine of Rs.', fine_amt, ' applied for ', days_late, ' days delay.') AS Message;
    ELSE
        SELECT 'No fine. Book returned on time.' AS Message;
    END IF;
END //

DELIMITER ;

-- 🧪 Run commands
CALL ReturnBook(1, 'DBMS', '2025-11-05');  -- Late > 15 days, fine = 5/day
CALL ReturnBook(2, 'CNS', '2025-12-10');   -- Late > 30 days, fine = 50/day

-- ✅ Check results
SELECT * FROM Borrow;
SELECT * FROM Fine;