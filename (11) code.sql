-- Create Database
CREATE DATABASE BankDB11;
USE BankDB11;

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
('KAROLBAGH', 'Delhi'),
('PERRRIDGE', 'Mumbai'),
('MAIN', 'Pune');

-- Insert into Customers
INSERT INTO Customers VALUES
('Anil', 'Pune'),
('Sunil', 'Delhi'),
('Ravi', 'Mumbai'),
('Meena', 'Pune');

-- Insert into Deposit
INSERT INTO Deposit VALUES
(101, 'Anil', 'MAIN', 6000.00, '1996-12-10'),
(102, 'Sunil', 'KAROLBAGH', 4000.00, '1997-01-12'),
(103, 'Ravi', 'PERRRIDGE', 7000.00, '1997-02-15'),
(104, 'Meena', 'MAIN', 8000.00, '1997-03-10');

-- Insert into Borrow
INSERT INTO Borrow VALUES
(201, 'Anil', 'MAIN', 10000.00),
(202, 'Sunil', 'KAROLBAGH', 5000.00),
(203, 'Ravi', 'PERRRIDGE', 8000.00);

-- (a) Display account date of customers Anil
SELECT adate
FROM Deposit
WHERE cname = 'Anil';

-- (b) Modify the size of attribute of amount in deposit
ALTER TABLE Deposit
MODIFY amount DECIMAL(12,2);

-- (c) Display names of customers living in city Pune
SELECT cname
FROM Customers
WHERE city = 'Pune';

-- (d) Display name of the city where branch KAROLBAGH is located
SELECT city
FROM Branch
WHERE bname = 'KAROLBAGH';

-- (e) Find the number of tuples in the customer relation
SELECT COUNT(*) AS Total_Customers
FROM Customers;

-- (f) Delete all the record of customer Sunil
DELETE FROM Customers
WHERE cname = 'Sunil';

SELECT * FROM Customers;

-- (g) Create a view on deposit table
CREATE VIEW Deposit_View AS
SELECT actno, cname, bname, amount
FROM Deposit;

-- Query the view
SELECT * FROM Deposit_View;
