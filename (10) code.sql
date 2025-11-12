-- Branch table
CREATE TABLE Branch (
    bname VARCHAR(30) PRIMARY KEY,
    city VARCHAR(30)
);

-- Customers table
CREATE TABLE Customers (
    cname VARCHAR(30) PRIMARY KEY,
    city VARCHAR(30)
);

-- Deposit table
CREATE TABLE Deposit (
    actno INT PRIMARY KEY,
    cname VARCHAR(30),
    bname VARCHAR(30),
    amount DECIMAL(10,2),
    adate DATE,
    FOREIGN KEY (cname) REFERENCES Customers(cname),
    FOREIGN KEY (bname) REFERENCES Branch(bname)
);

-- Borrow table
CREATE TABLE Borrow (
    loanno INT PRIMARY KEY,
    cname VARCHAR(30),
    bname VARCHAR(30),
    amount DECIMAL(10,2),
    FOREIGN KEY (cname) REFERENCES Customers(cname),
    FOREIGN KEY (bname) REFERENCES Branch(bname)
);


-- Insert into Branch
INSERT INTO Branch VALUES
('Perryridge', 'Bombay'),
('Downtown', 'Delhi'),
('Brighton', 'Bombay'),
('Main', 'Pune');

-- Insert into Customers
INSERT INTO Customers VALUES
('Anil', 'Pune'),
('Sunita', 'Mumbai'),
('Ravi', 'Bombay'),
('Meena', 'Delhi');

-- Insert into Deposit
INSERT INTO Deposit VALUES
(1001, 'Anil', 'Perryridge', 5000.00, '1997-01-10'),
(1002, 'Sunita', 'Downtown', 3000.00, '1996-12-20'),
(1003, 'Ravi', 'Brighton', 7000.00, '1997-03-15'),
(1004, 'Meena', 'Main', 2500.00, '1997-02-05');

-- Insert into Borrow
INSERT INTO Borrow VALUES
(2001, 'Anil', 'Perryridge', 10000.00),
(2002, 'Sunita', 'Downtown', 4000.00),
(2003, 'Ravi', 'Brighton', 6000.00);


-- (a) Display names of all branches located in city Bombay
SELECT bname
FROM Branch
WHERE city = 'Bombay';


-- (b) Display account no. and amount of depositors
SELECT actno, amount
FROM Deposit;


-- (c) Update the city of customer Anil from Pune to Mumbai
UPDATE Customers
SET city = 'Mumbai'
WHERE cname = 'Anil';

SELECT * FROM Customers;

-- (d) Find the number of depositors in the bank
SELECT COUNT(*) AS Number_of_Depositors
FROM Deposit;



-- (e) Calculate Min, Max amount of customers
SELECT MIN(amount) AS Min_Amount, MAX(amount) AS Max_Amount
FROM Deposit;



-- (f) Create an index on deposit table
CREATE INDEX idx_cname ON Deposit(cname);

SHOW INDEX FROM Deposit;


-- (g) Create View on Borrow table
CREATE VIEW Borrow_View AS
SELECT loanno, cname, bname, amount
FROM Borrow;

-- Query the view
SELECT * FROM Borrow_View;