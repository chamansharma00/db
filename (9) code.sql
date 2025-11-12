-- 1️⃣ Create Branch table
CREATE TABLE Branch (
    bname VARCHAR(20) PRIMARY KEY,
    city VARCHAR(20)
);

-- 2️⃣ Create Customers table
CREATE TABLE Customers (
    cname VARCHAR(20) PRIMARY KEY,
    city VARCHAR(20)
);

-- 3️⃣ Create Deposit table
CREATE TABLE Deposit (
    actno INT PRIMARY KEY,
    cname VARCHAR(20),
    bname VARCHAR(20),
    amount DECIMAL(10,2),
    adate DATE,
    FOREIGN KEY (cname) REFERENCES Customers(cname),
    FOREIGN KEY (bname) REFERENCES Branch(bname)
);

-- 4️⃣ Create Borrow table
CREATE TABLE Borrow (
    loanno INT PRIMARY KEY,
    cname VARCHAR(20),
    bname VARCHAR(20),
    amount DECIMAL(10,2),
    FOREIGN KEY (cname) REFERENCES Customers(cname),
    FOREIGN KEY (bname) REFERENCES Branch(bname)
);

-- Insert data into Branch
INSERT INTO Branch VALUES 
('Perryridge', 'New York'),
('Downtown', 'Chicago'),
('Brighton', 'Boston');

-- Insert data into Customers
INSERT INTO Customers VALUES 
('Anil', 'Delhi'),
('Sunita', 'Mumbai'),
('Rahul', 'Kolkata'),
('Meena', 'Chennai');

-- Insert data into Deposit
INSERT INTO Deposit VALUES
(101, 'Anil', 'Perryridge', 5000.00, '1997-01-12'),
(102, 'Sunita', 'Downtown', 3500.00, '1996-12-15'),
(103, 'Rahul', 'Brighton', 7000.00, '1997-03-10'),
(104, 'Meena', 'Perryridge', 2500.00, '1997-04-20');

-- Insert data into Borrow
INSERT INTO Borrow VALUES
(201, 'Anil', 'Perryridge', 10000.00),
(202, 'Sunita', 'Downtown', 5000.00),
(203, 'Rahul', 'Brighton', 8000.00);

-- 1️⃣ Display names of depositors having amount greater than 4000
SELECT cname, amount
FROM Deposit
WHERE amount > 4000;

-- 2️⃣ Display account date of customer ‘Anil’
SELECT adate
FROM Deposit
WHERE cname = 'Anil';

-- 3️⃣ Display account no. and deposit amount of customers having account opened between dates 1-12-96 and 1-5-97
SELECT actno, amount
FROM Deposit
WHERE adate BETWEEN '1996-12-01' AND '1997-05-01';

-- 4️⃣ Find the average account balance at the Perryridge branch
SELECT AVG(amount) AS Avg_Balance
FROM Deposit
WHERE bname = 'Perryridge';

-- 5️⃣ Find the names of all branches where the average account balance is more than $1,200
SELECT bname
FROM Deposit
GROUP BY bname
HAVING AVG(amount) > 1200;

-- 6️⃣ Delete depositors having deposit less than 5000
DELETE FROM Deposit
WHERE amount < 5000;

-- 7️⃣ Create a view on deposit table
CREATE VIEW Deposit_View AS
SELECT actno, cname, bname, amount
FROM Deposit;

-- Query the view
SELECT * FROM Deposit_View;