-- Create Database
CREATE DATABASE hotel_management;
USE hotel_management;

-- Create Tables
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

-- Insert Sample Data
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
(1, 'John Smith', '221B Baker Street'),
(2, 'Emma Johnson', '45 Queen Road'),
(3, 'Michael Brown', '78 Lake View'),
(4, 'Sophia Lee', '14 Hill Street');

INSERT INTO Booking VALUES
(1, 1, '2025-08-10', '2025-08-15', 102),
(1, 2, '2025-08-05', '2025-08-12', 103),
(2, 3, '2025-08-20', '2025-08-25', 201),
(3, 4, '2025-08-10', '2025-08-13', 301);

-- -------------------------------------------------------------
-- 1️⃣ List full details of all hotels
SELECT * FROM Hotel;

-- -------------------------------------------------------------
-- 2️⃣ How many hotels are there?
SELECT COUNT(*) AS Total_Hotels FROM Hotel;

-- -------------------------------------------------------------
-- 3️⃣ List the price and type of all rooms at the Grosvenor Hotel
SELECT r.Type, r.Price
FROM Room r
JOIN Hotel h ON r.HotelNo = h.HotelNo
WHERE h.Name = 'Grosvenor Hotel';

-- -------------------------------------------------------------
-- 4️⃣ List the number of rooms in each hotel
SELECT h.Name AS Hotel_Name, COUNT(r.RoomNo) AS Total_Rooms
FROM Hotel h
JOIN Room r ON h.HotelNo = r.HotelNo
GROUP BY h.HotelNo;

-- -------------------------------------------------------------
-- 5️⃣ List all guests currently staying at the Grosvenor Hotel
SELECT g.GuestName, g.GuestAddress
FROM Guest g
JOIN Booking b ON g.GuestNo = b.GuestNo
JOIN Hotel h ON b.HotelNo = h.HotelNo
WHERE h.Name = 'Grosvenor Hotel'
  AND CURDATE() BETWEEN b.DateFrom AND b.DateTo;

-- -------------------------------------------------------------
-- 6️⃣ List all double or family rooms with a price below £40.00 per night, in ascending order of price
SELECT * 
FROM Room
WHERE (Type = 'Double' OR Type = 'Family') AND Price < 40
ORDER BY Price ASC;

-- -------------------------------------------------------------
-- 7️⃣ How many different guests have made bookings for August?
SELECT COUNT(DISTINCT GuestNo) AS Total_Guests_August
FROM Booking
WHERE MONTH(DateFrom) = 8;

-- -------------------------------------------------------------
-- 8️⃣ What is the total income from bookings for the Grosvenor Hotel today?
-- (Assume each booking’s price is based on the room type and total nights)
SELECT h.Name AS Hotel, 
       SUM(DATEDIFF(b.DateTo, b.DateFrom) * r.Price) AS Total_Income
FROM Booking b
JOIN Hotel h ON b.HotelNo = h.HotelNo
JOIN Room r ON b.RoomNo = r.RoomNo AND b.HotelNo = r.HotelNo
WHERE h.Name = 'Grosvenor Hotel'
GROUP BY h.HotelNo;

-- -------------------------------------------------------------
-- 9️⃣ What is the most commonly booked room type for each hotel in London?
SELECT h.Name AS Hotel_Name, r.Type AS Most_Booked_Type, COUNT(*) AS Total_Bookings
FROM Booking b
JOIN Hotel h ON b.HotelNo = h.HotelNo
JOIN Room r ON b.RoomNo = r.RoomNo AND b.HotelNo = r.HotelNo
WHERE h.City = 'London'
GROUP BY h.HotelNo, r.Type
ORDER BY h.Name, Total_Bookings DESC;

-- -------------------------------------------------------------
-- 🔟 Update the price of all rooms by 5%
UPDATE Room
SET Price = Price * 1.05;
