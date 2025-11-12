-- ================================================================
-- HOTEL MANAGEMENT DATABASE (Set 6)
-- ================================================================

-- 1️⃣ Create Database
CREATE DATABASE hotel_management_v6;
USE hotel_management_v6;

-- ================================================================
-- 2️⃣ Create Tables
-- ================================================================

CREATE TABLE Hotel (
    HotelNo INT PRIMARY KEY,
    Name VARCHAR(50),
    City VARCHAR(50)
);

CREATE TABLE Room (
    RoomNo INT,
    HotelNo INT,
    Type VARCHAR(20),
    Price DECIMAL(10,2),
    PRIMARY KEY (RoomNo, HotelNo),
    FOREIGN KEY (HotelNo) REFERENCES Hotel(HotelNo)
);

CREATE TABLE Guest (
    GuestNo INT PRIMARY KEY,
    GuestName VARCHAR(50),
    GuestAddress VARCHAR(100)
);

CREATE TABLE Booking (
    HotelNo INT,
    GuestNo INT,
    DateFrom DATE,
    DateTo DATE,
    RoomNo INT,
    PRIMARY KEY (HotelNo, GuestNo, DateFrom),
    FOREIGN KEY (HotelNo) REFERENCES Hotel(HotelNo),
    FOREIGN KEY (GuestNo) REFERENCES Guest(GuestNo)
);

-- ================================================================
-- 3️⃣ Insert Sample Data
-- ================================================================

INSERT INTO Hotel VALUES
(1, 'Grosvenor Hotel', 'London'),
(2, 'Sea View Hotel', 'Brighton'),
(3, 'Palm Resort', 'London'),
(4, 'Hilltop Inn', 'Manchester');

INSERT INTO Room VALUES
(101, 1, 'Single', 35.00),
(102, 1, 'Double', 45.00),
(103, 1, 'Family', 60.00),
(201, 2, 'Double', 38.00),
(202, 2, 'Family', 55.00),
(301, 3, 'Double', 42.00),
(302, 3, 'Family', 58.00),
(401, 4, 'Single', 30.00);

INSERT INTO Guest VALUES
(1, 'John Smith', '221B Baker Street, London'),
(2, 'Emma Johnson', '45 Queen Road, London'),
(3, 'Michael Brown', '78 Lake View, Brighton'),
(4, 'Sophia Lee', '14 Hill Street, Manchester');

INSERT INTO Booking VALUES
(1, 1, '2025-11-05', '2025-11-12', 101),
(1, 2, '2025-11-07', NULL, 102),
(3, 3, '2025-11-10', '2025-11-15', 301),
(2, 4, '2025-11-09', '2025-11-11', 201);

-- ================================================================
-- 4️⃣ QUERIES
-- ================================================================

-- 1️⃣ List full details of all hotels
SELECT * FROM Hotel;

-- 2️⃣ List full details of all hotels in London
SELECT * 
FROM Hotel
WHERE City = 'London';

-- 3️⃣ List all guests currently staying at the Grosvenor Hotel
SELECT g.GuestName, g.GuestAddress
FROM Guest g
JOIN Booking b ON g.GuestNo = b.GuestNo
JOIN Hotel h ON b.HotelNo = h.HotelNo
WHERE h.Name = 'Grosvenor Hotel'
  AND CURDATE() BETWEEN b.DateFrom AND COALESCE(b.DateTo, CURDATE());

-- 4️⃣ List the names and addresses of all guests in London, alphabetically ordered by name
SELECT GuestName, GuestAddress
FROM Guest
WHERE GuestAddress LIKE '%London%'
ORDER BY GuestName ASC;

-- 5️⃣ List the bookings for which no DateTo has been specified
SELECT *
FROM Booking
WHERE DateTo IS NULL;

-- 6️⃣ How many hotels are there?
SELECT COUNT(*) AS Total_Hotels FROM Hotel;

-- 7️⃣ List the rooms that are currently unoccupied at the Grosvenor Hotel
SELECT r.RoomNo, r.Type, r.Price
FROM Room r
JOIN Hotel h ON r.HotelNo = h.HotelNo
WHERE h.Name = 'Grosvenor Hotel'
  AND r.RoomNo NOT IN (
      SELECT RoomNo FROM Booking b 
      WHERE h.HotelNo = b.HotelNo 
        AND CURDATE() BETWEEN b.DateFrom AND COALESCE(b.DateTo, CURDATE())
  );

-- 8️⃣ What is the lost income from unoccupied rooms at each hotel today?
SELECT h.Name AS Hotel_Name, 
       SUM(r.Price) AS Lost_Income
FROM Hotel h
JOIN Room r ON h.HotelNo = r.HotelNo
WHERE (r.RoomNo, r.HotelNo) NOT IN (
    SELECT b.RoomNo, b.HotelNo 
    FROM Booking b 
    WHERE CURDATE() BETWEEN b.DateFrom AND COALESCE(b.DateTo, CURDATE())
)
GROUP BY h.HotelNo;

-- 9️⃣ Create index on one of the fields (e.g., Room.Price) and show performance
CREATE INDEX idx_price ON Room(Price);

-- Check performance using EXPLAIN (optional)
EXPLAIN SELECT * FROM Room WHERE Price < 50;

-- 🔟 Create one view and query it
CREATE VIEW LondonHotels AS
SELECT * FROM Hotel WHERE City = 'London';

-- Query the created view
SELECT * FROM LondonHotels;

