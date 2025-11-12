CREATE DATABASE hotel_management_part2;
USE hotel_management_part2;

-- ============================================
-- 1️⃣ CREATE TABLES
-- ============================================

-- Hotel Table
CREATE TABLE Hotel (
    HotelNo INT PRIMARY KEY,
    Name VARCHAR(50),
    City VARCHAR(50)
);

-- Room Table
CREATE TABLE Room (
    RoomNo INT,
    HotelNo INT,
    Type VARCHAR(30),
    Price DECIMAL(10,2),
    PRIMARY KEY (HotelNo, RoomNo),
    FOREIGN KEY (HotelNo) REFERENCES Hotel(HotelNo)
);

-- Guest Table
CREATE TABLE Guest (
    GuestNo INT PRIMARY KEY,
    GuestName VARCHAR(50),
    GuestAddress VARCHAR(100)
);

-- Booking Table
CREATE TABLE Booking (
    HotelNo INT,
    GuestNo INT,
    DateFrom DATE,
    DateTo DATE,
    RoomNo INT,
    PRIMARY KEY (HotelNo, GuestNo, DateFrom),
    FOREIGN KEY (HotelNo) REFERENCES Hotel(HotelNo),
    FOREIGN KEY (GuestNo) REFERENCES Guest(GuestNo),
    FOREIGN KEY (RoomNo, HotelNo) REFERENCES Room(RoomNo, HotelNo)
);

-- ============================================
-- 2️⃣ INSERT SAMPLE DATA
-- ============================================

-- Hotel Data
INSERT INTO Hotel VALUES
(1, 'Grosvenor Hotel', 'London'),
(2, 'Sea View Resort', 'Goa'),
(3, 'Mountain Stay', 'Manali'),
(4, 'City Inn', 'London');

-- Room Data
INSERT INTO Room VALUES
(101, 1, 'Single', 90.00),
(102, 1, 'Double', 130.00),
(103, 1, 'Double', 150.00),
(201, 2, 'Suite', 250.00),
(202, 2, 'Double', 120.00),
(301, 3, 'Family', 80.00),
(302, 3, 'Double', 70.00),
(401, 4, 'Single', 60.00);

-- Guest Data
INSERT INTO Guest VALUES
(11, 'Ishaan', 'Mumbai'),
(12, 'Riya', 'Pune'),
(13, 'Aman', 'Delhi'),
(14, 'Tara', 'London');

-- Booking Data
INSERT INTO Booking VALUES
(1, 11, '2025-04-10', '2025-04-15', 102),
(1, 12, '2025-04-11', '2025-04-12', 103),
(2, 13, '2025-04-12', '2025-04-15', 201),
(4, 14, '2025-04-10', '2025-04-11', 401);

-- ============================================
-- 3️⃣ QUERIES
-- ============================================

-- 1️⃣ What is the total revenue per night from all double rooms?
SELECT SUM(Price) AS Total_Revenue_Per_Night
FROM Room
WHERE Type = 'Double';

-- 2️⃣ List the details of all rooms at the Grosvenor Hotel, including the guest name if occupied
SELECT r.RoomNo, r.Type, r.Price, g.GuestName
FROM Room r
JOIN Hotel h ON r.HotelNo = h.HotelNo
LEFT JOIN Booking b ON r.HotelNo = b.HotelNo AND r.RoomNo = b.RoomNo
LEFT JOIN Guest g ON b.GuestNo = g.GuestNo
WHERE h.Name = 'Grosvenor Hotel';

-- 3️⃣ What is the average number of bookings for each hotel in April?
SELECT h.Name AS Hotel_Name, 
       COUNT(b.GuestNo) / COUNT(DISTINCT h.HotelNo) AS Avg_Bookings
FROM Hotel h
LEFT JOIN Booking b ON h.HotelNo = b.HotelNo
WHERE MONTH(b.DateFrom) = 4
GROUP BY h.Name;

-- 4️⃣ Create index on one of the fields and show its performance in a query
CREATE INDEX idx_room_type ON Room(Type);

-- Use the indexed field in a query
SELECT * FROM Room WHERE Type = 'Double';

-- 5️⃣ List full details of all hotels
SELECT * FROM Hotel;

-- 6️⃣ List full details of all hotels in London
SELECT * FROM Hotel WHERE City = 'London';

-- 7️⃣ Update the price of all rooms by 5%
UPDATE Room
SET Price = Price * 1.05;

-- 8️⃣ List the number of rooms in each hotel in London
SELECT h.Name AS Hotel_Name, COUNT(r.RoomNo) AS No_of_Rooms
FROM Hotel h
JOIN Room r ON h.HotelNo = r.HotelNo
WHERE h.City = 'London'
GROUP BY h.Name;

-- 9️⃣ List all double or family rooms with a price below £40.00 per night, in ascending order of price
SELECT *
FROM Room
WHERE (Type = 'Double' OR Type = 'Family') AND Price < 40.00
ORDER BY Price ASC;
