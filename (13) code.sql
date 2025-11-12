-- 1. Publisher Table
CREATE TABLE Publisher (
    PID INT PRIMARY KEY,
    PNAME VARCHAR(30),
    ADDRESS VARCHAR(50),
    STATE VARCHAR(30),
    PHONE VARCHAR(15),
    EMAILID VARCHAR(40)
);

-- 2. Book Table
CREATE TABLE Book (
    ISBN VARCHAR(20) PRIMARY KEY,
    BOOK_TITLE VARCHAR(50),
    CATEGORY VARCHAR(30),
    PRICE DECIMAL(10,2),
    COPYRIGHT_DATE DATE,
    YEAR INT,
    PAGE_COUNT INT,
    PID INT,
    FOREIGN KEY (PID) REFERENCES Publisher(PID)
);

-- 3. Author Table
CREATE TABLE Author (
    AID INT PRIMARY KEY,
    ANAME VARCHAR(40),
    STATE VARCHAR(30),
    CITY VARCHAR(30),
    ZIP VARCHAR(10),
    PHONE VARCHAR(15),
    URL VARCHAR(50)
);

-- 4. Author_Book Table (Many-to-Many Relationship)
CREATE TABLE Author_Book (
    AID INT,
    ISBN VARCHAR(20),
    PRIMARY KEY (AID, ISBN),
    FOREIGN KEY (AID) REFERENCES Author(AID),
    FOREIGN KEY (ISBN) REFERENCES Book(ISBN)
);

-- 5. Review Table
CREATE TABLE Review (
    RID INT PRIMARY KEY,
    ISBN VARCHAR(20),
    RATING DECIMAL(3,1),
    FOREIGN KEY (ISBN) REFERENCES Book(ISBN)
);


-- Publishers
INSERT INTO Publisher VALUES (1, 'MEHTA', 'MG Road', 'Maharashtra', '9876543210', 'mehta@pub.com');
INSERT INTO Publisher VALUES (2, 'OXFORD', 'Connaught Place', 'Delhi', '9898989898', 'oxford@pub.com');

-- Books
INSERT INTO Book VALUES ('B101', 'Half Girlfriend', 'Fiction', 350, '2014-05-01', 2014, 280, 1);
INSERT INTO Book VALUES ('B102', 'Fundamentals of DBMS', 'Education', 450, '2019-07-15', 2019, 500, 2);
INSERT INTO Book VALUES ('B103', 'Tiny Tales', 'Story', 150, '2021-01-01', 2021, 80, 1);

-- Authors
INSERT INTO Author VALUES (1, 'CHETAN BHAGAT', 'Maharashtra', 'Mumbai', '400001', '9123456789', 'chetanbhagat.com');
INSERT INTO Author VALUES (2, 'S.KORTH', 'Delhi', 'Delhi', '110001', '9876567890', 'korth.com');
INSERT INTO Author VALUES (3, 'C.MEHTA', 'Maharashtra', 'Pune', '411001', '9876501234', 'cmehta.in');

-- Author_Book
INSERT INTO Author_Book VALUES (1, 'B101');
INSERT INTO Author_Book VALUES (2, 'B102');
INSERT INTO Author_Book VALUES (3, 'B103');

-- Review
INSERT INTO Review VALUES (1, 'B101', 4.5);
INSERT INTO Review VALUES (2, 'B102', 4.2);
INSERT INTO Review VALUES (3, 'B103', 3.8);

-- 1️⃣ Retrieve city, phone, and URL of author whose name is ‘CHETAN BHAGAT’
SELECT CITY, PHONE, URL
FROM Author
WHERE ANAME = 'CHETAN BHAGAT';

-- 2️⃣ Retrieve book title, review id, and rating of all books
SELECT B.BOOK_TITLE, R.RID, R.RATING
FROM Book B
JOIN Review R ON B.ISBN = R.ISBN;

-- 3️⃣ Retrieve book title, price, author name, and URL for publisher ‘MEHTA’
SELECT B.BOOK_TITLE, B.PRICE, A.ANAME, A.URL
FROM Book B
JOIN Publisher P ON B.PID = P.PID
JOIN Author_Book AB ON B.ISBN = AB.ISBN
JOIN Author A ON AB.AID = A.AID
WHERE P.PNAME = 'MEHTA';

-- 4️⃣ Update phone number of publisher ‘MEHTA’ to 123456
UPDATE Publisher
SET PHONE = '123456'
WHERE PNAME = 'MEHTA';

-- 5️⃣ Calculate average, max, and min price of each publisher
SELECT P.PNAME,
       AVG(B.PRICE) AS AVG_PRICE,
       MAX(B.PRICE) AS MAX_PRICE,
       MIN(B.PRICE) AS MIN_PRICE
FROM Publisher P
JOIN Book B ON P.PID = B.PID
GROUP BY P.PNAME;

-- 6️⃣ Delete all books having page count < 100
DELETE FROM Book
WHERE PAGE_COUNT < 100;

-- 7️⃣ Retrieve authors from city Pune whose name starts with ‘C’
SELECT *
FROM Author
WHERE CITY = 'Pune' AND ANAME LIKE 'C%';

-- 8️⃣ Retrieve authors living in the same city as ‘KORTH’
SELECT *
FROM Author
WHERE CITY = (
    SELECT CITY FROM Author WHERE ANAME = 'S.KORTH'
)
AND ANAME <> 'S.KORTH';


-- 9️⃣ Create a procedure to update page count for given ISBN
DELIMITER //
CREATE PROCEDURE UpdatePageCount(IN book_isbn VARCHAR(20), IN new_pages INT)
BEGIN
    UPDATE Book
    SET PAGE_COUNT = new_pages
    WHERE ISBN = book_isbn;
END //
DELIMITER ;

>>CALL UpdatePageCount('B101', 350);  --run this to update page count

-- 🔟 Create a function to return price of a book with given ISBN
DELIMITER //
CREATE FUNCTION GetBookPrice(book_isbn VARCHAR(20))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE book_price DECIMAL(10,2);
    SELECT PRICE INTO book_price
    FROM Book
    WHERE ISBN = book_isbn;
    RETURN book_price;
END //
DELIMITER ;

>>SELECT GetBookPrice('B101') AS Price; --run this to get price of book with given ISBN
