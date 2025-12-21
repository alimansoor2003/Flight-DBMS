--List ALL system data: passenger → booking → payment → ticket → flight → airports → aircraft → airline

SELECT 
    P.FirstName || ' ' || P.LastName AS PassengerName,
    B.BookingID,
    Pay.Amount AS PaymentAmount,
    T.SeatNumber,
    T.Class,
    F.FlightCode,
    O.Name AS OriginAirport,
    D.Name AS DestinationAirport,
    AC.Model AS AircraftModel,
    A.AirlineName
FROM Passenger P
JOIN Booking B ON P.PassengerID = B.PassengerID
LEFT JOIN Payment Pay ON B.BookingID = Pay.BookingID
JOIN Ticket T ON B.BookingID = T.BookingID
JOIN Flight F ON B.FlightID = F.FlightID
JOIN Airport O ON F.OriginAirport = O.AirportCode
JOIN Airport D ON F.DestinationAirport = D.AirportCode
JOIN Aircraft AC ON F.AircraftID = AC.AircraftID
JOIN Airline A ON F.AirlineCode = A.AirlineCode;


--Show all passengers and their bookings

SELECT P.FirstName, P.LastName, B.BookingID, B.Status
FROM Passenger P
JOIN Booking B ON P.PassengerID = B.PassengerID;

-- Count number of bookings per flight

SELECT 
    F.FlightCode,
    COUNT(B.BookingID) AS TotalBookings
FROM Flight F
LEFT JOIN Booking B ON F.FlightID = B.FlightID
GROUP BY F.FlightCode;

--Find the most expensive ticket

SELECT TicketID, Price
FROM Ticket
ORDER BY Price DESC
LIMIT 1;

--Find passengers who have booked flights but never made a payment
 
SELECT P.FirstName, P.LastName
FROM Passenger P
WHERE EXISTS (
    SELECT 1
    FROM Booking B
    WHERE B.PassengerID = P.PassengerID
)
AND NOT EXISTS (
    SELECT 1
    FROM Booking B
    JOIN Payment Pay ON B.BookingID = Pay.BookingID
    WHERE B.PassengerID = P.PassengerID
);

--Passenger total spending vs average booking spending

SELECT P.PassengerID,
       P.FirstName,
       P.LastName,
       SUM(Pay.Amount) AS TotalSpent
FROM Passenger P
JOIN Booking B ON P.PassengerID = B.PassengerID
JOIN Payment Pay ON B.BookingID = Pay.BookingID
GROUP BY P.PassengerID, P.FirstName, P.LastName
HAVING SUM(Pay.Amount) >
       (SELECT AVG(sub.TotalPaid)
        FROM (
            SELECT SUM(Amount) AS TotalPaid
            FROM Payment
            GROUP BY BookingID
        ) sub);

--Get the top 1 most booked airline
SELECT A.AirlineName,
       COUNT(B.BookingID) AS TotalBookings
FROM Booking B
JOIN Flight F ON B.FlightID = F.FlightID
JOIN Airline A ON F.AirlineCode = A.AirlineCode
GROUP BY A.AirlineName
ORDER BY TotalBookings DESC
LIMIT 1;


--Get passenger details with their most expensive ticket

SELECT P.FirstName, P.LastName, T.Price AS HighestTicket
FROM Ticket T
JOIN Booking B ON T.BookingID = B.BookingID
JOIN Passenger P ON B.PassengerID = P.PassengerID
WHERE T.Price = (
    SELECT MAX(Price)
    FROM Ticket
    WHERE BookingID = B.BookingID
);

-- Total revenue collected per airline (from payments)

SELECT A.AirlineName,
       SUM(Pay.Amount) AS TotalRevenue
FROM Airline A
JOIN Flight F ON A.AirlineCode = F.AirlineCode
JOIN Booking B ON F.FlightID = B.FlightID
JOIN Payment Pay ON B.BookingID = Pay.BookingID
GROUP BY A.AirlineName
ORDER BY TotalRevenue DESC;

-- Number of flights assigned to each crew member

SELECT C.CrewID,
       C.FirstName,
       C.LastName,
       C.Role,
       COUNT(FC.FlightID) AS FlightsAssigned
FROM CrewMember C
LEFT JOIN FlightCrew FC ON C.CrewID = FC.CrewID
GROUP BY C.CrewID, C.FirstName, C.LastName, C.Role
ORDER BY FlightsAssigned DESC;

-- List passengers who have a flight in February 2025

SELECT DISTINCT
       P.PassengerID,
       P.FirstName,
       P.LastName,
       F.FlightCode,
       F.DepartureTime
FROM Passenger P
JOIN Booking B ON P.PassengerID = B.PassengerID
JOIN Flight F ON B.FlightID = F.FlightID
WHERE F.DepartureTime >= '2025-02-01'
  AND F.DepartureTime <  '2025-03-01'
ORDER BY F.DepartureTime;

-- Airports that appear both as an origin and as a destination (INTERSECT)

SELECT OriginAirport AS AirportCode
FROM Flight
INTERSECT
SELECT DestinationAirport AS AirportCode
FROM Flight;

-- List passengers who use Gmail (case-insensitive)

SELECT PassengerID,
       FirstName,
       LastName,
       Email
FROM Passenger
WHERE LOWER(Email) LIKE '%@gmail.com';

-- Show bookings with payment status (Paid/Unpaid) and amount (0 if unpaid)

SELECT
    B.BookingID,
    F.FlightCode,
    P.FirstName,
    P.LastName,
    B.Status AS BookingStatus,
    COALESCE(SUM(Pay.Amount), 0) AS TotalPaid,
    CASE
        WHEN COUNT(Pay.PaymentID) > 0 THEN 'Paid'
        ELSE 'Unpaid'
    END AS PaymentStatus
FROM Booking B
JOIN Passenger P ON B.PassengerID = P.PassengerID
JOIN Flight F ON B.FlightID = F.FlightID
LEFT JOIN Payment Pay ON B.BookingID = Pay.BookingID
GROUP BY B.BookingID, F.FlightCode, P.FirstName, P.LastName, B.Status
ORDER BY B.BookingID;

