CREATE DATABASE hotel_management;
USE hotel_management;


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


-- Hotel Data
INSERT INTO Hotel VALUES
(1, 'Grosvenor Hotel', 'London'),
(2, 'Sea View Resort', 'Goa'),
(3, 'Mountain Stay', 'Manali'),
(4, 'City Inn', 'London');

-- Room Data
INSERT INTO Room VALUES
(101, 1, 'Single', 100.00),
(102, 1, 'Double', 180.00),
(201, 2, 'Suite', 250.00),
(202, 2, 'Single', 120.00),
(301, 3, 'Double', 160.00),
(401, 4, 'Single', 90.00);

-- Guest Data
INSERT INTO Guest VALUES
(11, 'Ishaan', 'Mumbai'),
(12, 'Riya', 'Pune'),
(13, 'Aman', 'Delhi'),
(14, 'Tara', 'London');

-- Booking Data
INSERT INTO Booking VALUES
(1, 11, '2025-11-01', '2025-11-05', 101),
(2, 12, '2025-11-03', '2025-11-06', 201),
(1, 13, '2025-11-02', '2025-11-07', 102),
(4, 14, '2025-11-01', '2025-11-04', 401);



-- 1️⃣ List full details of all hotels
SELECT * FROM Hotel;

-- 2️⃣ How many hotels are there?
SELECT COUNT(*) AS Total_Hotels FROM Hotel;

-- 3️⃣ List the price and type of all rooms at the Grosvenor Hotel
SELECT r.Type, r.Price
FROM Room r
JOIN Hotel h ON r.HotelNo = h.HotelNo
WHERE h.Name = 'Grosvenor Hotel';

-- 4️⃣ List the number of rooms in each hotel
SELECT h.Name AS Hotel_Name, COUNT(r.RoomNo) AS No_of_Rooms
FROM Hotel h
JOIN Room r ON h.HotelNo = r.HotelNo
GROUP BY h.Name;

-- 5️⃣ Update the price of all rooms by 5%
UPDATE Room
SET Price = Price * 1.05;

-- 6️⃣ List full details of all hotels in London
SELECT * FROM Hotel WHERE City = 'London';

-- 7️⃣ What is the average price of a room?
SELECT AVG(Price) AS Avg_Price FROM Room;

-- 8️⃣ List all guests currently staying at the Grosvenor Hotel
SELECT g.GuestName, g.GuestAddress
FROM Guest g
JOIN Booking b ON g.GuestNo = b.GuestNo
JOIN Hotel h ON b.HotelNo = h.HotelNo
WHERE h.Name = 'Grosvenor Hotel'
AND CURDATE() BETWEEN b.DateFrom AND b.DateTo;

-- 9️⃣ List the number of rooms in each hotel in London
SELECT h.Name AS Hotel_Name, COUNT(r.RoomNo) AS No_of_Rooms
FROM Hotel h
JOIN Room r ON h.HotelNo = r.HotelNo
WHERE h.City = 'London'
GROUP BY h.Name;

-- 🔟 Create one view and query it
CREATE VIEW LondonHotels AS
SELECT * FROM Hotel WHERE City = 'London';

-- Query the view
SELECT * FROM LondonHotels;
