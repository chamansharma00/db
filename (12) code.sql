-- 1. Create Branch table
CREATE TABLE Branch (
    bname VARCHAR(20) PRIMARY KEY,
    city VARCHAR(20)
);

-- 2. Create Customers table
CREATE TABLE Customers (
    cname VARCHAR(20) PRIMARY KEY,
    city VARCHAR(20)
);

-- 3. Create Deposit table
CREATE TABLE Deposit (
    actno INT PRIMARY KEY,
    cname VARCHAR(20),
    bname VARCHAR(20),
    amount DECIMAL(10,2),
    adate DATE,
    FOREIGN KEY (cname) REFERENCES Customers(cname),
    FOREIGN KEY (bname) REFERENCES Branch(bname)
);

-- 4. Create Borrow table
CREATE TABLE Borrow (
    loanno INT PRIMARY KEY,
    cname VARCHAR(20),
    bname VARCHAR(20),
    amount DECIMAL(10,2),
    FOREIGN KEY (cname) REFERENCES Customers(cname),
    FOREIGN KEY (bname) REFERENCES Branch(bname)
);


-- Branch entries
INSERT INTO Branch VALUES ('CAMP', 'Pune');
INSERT INTO Branch VALUES ('KAROLBAGH', 'Delhi');
INSERT INTO Branch VALUES ('MGROAD', 'Bombay');
INSERT INTO Branch VALUES ('GPO', 'Nagpur');

-- Customers entries
INSERT INTO Customers VALUES ('Anil', 'Bombay');
INSERT INTO Customers VALUES ('Sunil', 'Nagpur');
INSERT INTO Customers VALUES ('Raj', 'Pune');
INSERT INTO Customers VALUES ('Amit', 'Nagpur');
INSERT INTO Customers VALUES ('Kiran', 'Delhi');

-- Deposit entries
INSERT INTO Deposit VALUES (101, 'Anil', 'MGROAD', 2000, '2023-05-01');
INSERT INTO Deposit VALUES (102, 'Sunil', 'GPO', 1500, '2023-06-10');
INSERT INTO Deposit VALUES (103, 'Raj', 'CAMP', 1200, '2023-07-15');
INSERT INTO Deposit VALUES (104, 'Amit', 'GPO', 2500, '2023-07-25');
INSERT INTO Deposit VALUES (105, 'Kiran', 'KAROLBAGH', 1800, '2023-08-20');

-- Borrow entries
INSERT INTO Borrow VALUES (201, 'Anil', 'MGROAD', 3000);
INSERT INTO Borrow VALUES (202, 'Sunil', 'GPO', 2200);
INSERT INTO Borrow VALUES (203, 'Raj', 'CAMP', 1800);
INSERT INTO Borrow VALUES (204, 'Amit', 'GPO', 2500);
INSERT INTO Borrow VALUES (205, 'Kiran', 'KAROLBAGH', 1900);


-- 1️⃣ Display customer name having living city Bombay and branch city Nagpur
SELECT d.cname
FROM Deposit d
JOIN Customers c ON d.cname = c.cname
JOIN Branch b ON d.bname = b.bname
WHERE c.city = 'Bombay' AND b.city = 'Nagpur';

-- 2️⃣ Display customer name having same living city as their branch city
SELECT d.cname
FROM Deposit d
JOIN Customers c ON d.cname = c.cname
JOIN Branch b ON d.bname = b.bname
WHERE c.city = b.city;


-- 3️⃣ Display customer name who are borrowers as well as depositors and having living city Nagpur
SELECT DISTINCT c.cname
FROM Customers c
JOIN Deposit d ON c.cname = d.cname
JOIN Borrow b ON c.cname = b.cname
WHERE c.city = 'Nagpur';

-- 4️⃣ Display borrower names having deposit amount > 1000 and loan amount > 2000
SELECT DISTINCT b.cname
FROM Borrow b
JOIN Deposit d ON b.cname = d.cname
WHERE d.amount > 1000 AND b.amount > 2000;

-- 5️⃣ Display customer name living in the city where branch of depositor Sunil is located
SELECT cname
FROM Customers
WHERE city = (
    SELECT city
    FROM Branch
    WHERE bname = (
        SELECT bname
        FROM Deposit
        WHERE cname = 'Sunil'
    )
);

-- 6️⃣ Create an index on Deposit table
CREATE INDEX idx_deposit_cname
ON Deposit(cname);