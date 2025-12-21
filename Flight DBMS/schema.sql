CREATE TABLE Airline (
    AirlineCode CHAR(2) PRIMARY KEY,
    AirlineName VARCHAR(100) NOT NULL UNIQUE,
    Country VARCHAR(50) NOT NULL,
    CHECK (CHAR_LENGTH(AirlineCode) = 2)
);

CREATE TABLE Airport (
    AirportCode CHAR(3) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    City VARCHAR(50) NOT NULL,
    Country VARCHAR(50) NOT NULL,
    CHECK (CHAR_LENGTH(AirportCode) = 3)
);

CREATE TABLE Aircraft (
    AircraftID INT PRIMARY KEY,
    Model VARCHAR(50) NOT NULL,
    Capacity INT NOT NULL,
    AirlineCode CHAR(2),
    CHECK (Capacity > 0),
    FOREIGN KEY (AirlineCode) REFERENCES Airline(AirlineCode)
        ON UPDATE CASCADE ON DELETE SET NULL
);



CREATE TABLE CrewMember (
    CrewID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Role VARCHAR(20) NOT NULL,
    CHECK (Role IN ('Pilot', 'CoPilot', 'Flight Attendant', 'Engineer'))
);


CREATE TABLE Flight (
    FlightID INT PRIMARY KEY,
    FlightCode VARCHAR(10) NOT NULL UNIQUE,
    AircraftID INT NOT NULL,
    AirlineCode CHAR(2) NOT NULL,
    OriginAirport CHAR(3) NOT NULL,
    DestinationAirport CHAR(3) NOT NULL,
    DepartureTime  TIMESTAMP NOT NULL,
    ArrivalTime TIMESTAMP NOT NULL,
    CHECK (ArrivalTime > DepartureTime),
    CHECK (OriginAirport <> DestinationAirport),
    FOREIGN KEY (AircraftID) REFERENCES Aircraft(AircraftID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (AirlineCode) REFERENCES Airline(AirlineCode)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (OriginAirport) REFERENCES Airport(AirportCode)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (DestinationAirport) REFERENCES Airport(AirportCode)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE FlightCrew (
    FlightID INT NOT NULL,
    CrewID INT NOT NULL,
    PRIMARY KEY (FlightID, CrewID),
    FOREIGN KEY (FlightID) REFERENCES Flight(FlightID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (CrewID) REFERENCES CrewMember(CrewID)
        ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE TABLE Passenger (
    PassengerID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Phone VARCHAR(20),
    CHECK (Email LIKE '%@%')
);


CREATE TABLE Booking (
    BookingID INT PRIMARY KEY,
    PassengerID INT NOT NULL,
    FlightID INT NOT NULL,
    BookingDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Status VARCHAR(15) NOT NULL,
    CHECK (Status IN ('Confirmed','Cancelled','Pending')),
    FOREIGN KEY (PassengerID) REFERENCES Passenger(PassengerID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (FlightID) REFERENCES Flight(FlightID)
        ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE TABLE Ticket (
    TicketID INT PRIMARY KEY,
    BookingID INT NOT NULL,
    SeatNumber VARCHAR(5) NOT NULL,
    Class VARCHAR(10) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    CHECK (Price > 0),
    CHECK (Class IN ('Economy', 'Business', 'First')),
    UNIQUE (FlightID, SeatNumber),
    FOREIGN KEY (BookingID) REFERENCES Booking(BookingID)
        ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE Payment (
    PaymentID INT PRIMARY KEY,
    BookingID INT NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    PaymentDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Method VARCHAR(20) NOT NULL,
    CHECK (Amount > 0),
    CHECK (Method IN ('CreditCard','PayPal','Cash')),
    FOREIGN KEY (BookingID) REFERENCES Booking(BookingID)
        ON UPDATE CASCADE ON DELETE CASCADE
);
