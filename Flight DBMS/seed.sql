INSERT INTO Airline (AirlineCode, AirlineName, Country) VALUES
('TK', 'Turkish Airlines', 'Turkey'),
('QR', 'Qatar Airways', 'Qatar'),
('EK', 'Emirates', 'UAE');

INSERT INTO Airport (AirportCode, Name, City, Country) VALUES
('IST', 'Istanbul Airport', 'Istanbul', 'Turkey'),
('DOH', 'Hamad International Airport', 'Doha', 'Qatar'),
('DXB', 'Dubai International Airport', 'Dubai', 'UAE');

INSERT INTO Aircraft (AircraftID, Model, Capacity, AirlineCode) VALUES
(101, 'Airbus A350', 350, 'QR'),
(102, 'Boeing 777', 396, 'EK'),
(103, 'Airbus A321', 220, 'TK');

INSERT INTO CrewMember (CrewID, FirstName, LastName, Role) VALUES
(1, 'Ali', 'Yilmaz', 'Pilot'),
(2, 'Sara', 'Khan', 'CoPilot'),
(3, 'Mehmet', 'Demir', 'Flight Attendant'),
(4, 'Lina', 'Hassan', 'Engineer');

INSERT INTO Flight (FlightID, FlightCode, AircraftID, AirlineCode, 
                    OriginAirport, DestinationAirport, DepartureTime, ArrivalTime)
VALUES
(1001, 'TK700', 103, 'TK', 'IST', 'DOH', 
 '2025-02-01 10:00:00', '2025-02-01 14:00:00'),

(1002, 'QR201', 101, 'QR', 'DOH', 'DXB', 
 '2025-02-02 09:30:00', '2025-02-02 11:00:00'),

(1003, 'EK350', 102, 'EK', 'DXB', 'IST',
 '2025-02-03 18:00:00', '2025-02-03 22:00:00');

INSERT INTO FlightCrew (FlightID, CrewID) VALUES
(1001, 1),
(1001, 3),
(1002, 2),
(1002, 3),
(1003, 1),
(1003, 4);

INSERT INTO Passenger (PassengerID, FirstName, LastName, Email, Phone) VALUES
(501, 'Ali', 'Saleh', 'omar.ali@gmail.com', '555-0001'),
(502, 'Mohammed', 'Alzol', 'layla.h@gmail.com', '555-0002'),
(503, 'Majed', 'Alzobidi', 'johnsmith@example.com', '555-0003');

INSERT INTO Booking (BookingID, PassengerID, FlightID, Status) VALUES
(2001, 501, 1001, 'Confirmed'),
(2002, 502, 1002, 'Pending'),
(2003, 503, 1003, 'Confirmed');

INSERT INTO Ticket (TicketID, BookingID, FlightID, SeatNumber, Class, Price) VALUES
(3001, 2001, 1001, '12A', 'Economy', 950.00),
(3002, 2002, 1002, '4C', 'Business', 2300.00),
(3003, 2003, 1003, '2A', 'First', 4200.00);

INSERT INTO Payment (PaymentID, BookingID, Amount, Method) VALUES
(4001, 2001, 950.00, 'CreditCard'),
(4002, 2003, 4200.00, 'PayPal');

UPDATE Booking
SET Status = 'Confirmed'
WHERE BookingID = 2002;

DELETE FROM Payment
WHERE PaymentID = 4002;