CREATE DATABASE AirlineReservation;
USE AirlineReservation;
CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20) NOT NULL,
    passport_number VARCHAR(50) UNIQUE NOT NULL,
    date_of_birth DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE Airlines (
    airline_id INT AUTO_INCREMENT PRIMARY KEY,
    airline_name VARCHAR(100) NOT NULL,
    iata_code VARCHAR(2) UNIQUE NOT NULL,
    country VARCHAR(50) NOT NULL
);
CREATE TABLE Aircrafts (
    aircraft_id INT AUTO_INCREMENT PRIMARY KEY,
    airline_id INT NOT NULL,
    model VARCHAR(100) NOT NULL,
    capacity INT NOT NULL,
    registration_number VARCHAR(20) UNIQUE NOT NULL,
    FOREIGN KEY (airline_id) REFERENCES Airlines(airline_id)
);
CREATE TABLE Airports (
    airport_id INT AUTO_INCREMENT PRIMARY KEY,
    airport_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL,
    iata_code VARCHAR(3) UNIQUE NOT NULL,
    icao_code VARCHAR(4) UNIQUE NOT NULL
);
CREATE TABLE Flights (
    flight_id INT AUTO_INCREMENT PRIMARY KEY,
    flight_number VARCHAR(10) NOT NULL,
    airline_id INT NOT NULL,
    aircraft_id INT NOT NULL,
    departure_airport_id INT NOT NULL,
    arrival_airport_id INT NOT NULL,
    departure_time DATETIME NOT NULL,
    arrival_time DATETIME NOT NULL,
    base_price DECIMAL(10, 2) NOT NULL,
    status ENUM('Scheduled', 'Delayed', 'Departed', 'Arrived', 'Cancelled') DEFAULT 'Scheduled',
    FOREIGN KEY (airline_id) REFERENCES Airlines(airline_id),
    FOREIGN KEY (aircraft_id) REFERENCES Aircrafts(aircraft_id),
    FOREIGN KEY (departure_airport_id) REFERENCES Airports(airport_id),
    FOREIGN KEY (arrival_airport_id) REFERENCES Airports(airport_id)
);
CREATE TABLE Seats (
    seat_id INT AUTO_INCREMENT PRIMARY KEY,
    aircraft_id INT NOT NULL,
    seat_number VARCHAR(10) NOT NULL,
    class ENUM('Economy', 'Premium Economy', 'Business', 'First') NOT NULL,
    is_emergency_exit BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (aircraft_id) REFERENCES Aircrafts(aircraft_id),
    UNIQUE KEY (aircraft_id, seat_number)
);
CREATE TABLE Bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    flight_id INT NOT NULL,
    seat_id INT NOT NULL,
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    booking_status ENUM('Confirmed', 'Cancelled', 'Completed') DEFAULT 'Confirmed',
    payment_status ENUM('Pending', 'Paid', 'Refunded') DEFAULT 'Pending',
    total_price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id),
    FOREIGN KEY (seat_id) REFERENCES Seats(seat_id)
);
CREATE TABLE Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_method ENUM('Credit Card', 'Debit Card', 'Net Banking', 'UPI', 'Wallet') NOT NULL,
    transaction_id VARCHAR(100) UNIQUE NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Success', 'Failed', 'Pending') NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id)
);
INSERT INTO Airlines (airline_name, iata_code, country) VALUES
('Delta Airlines', 'DL', 'USA'),
('Emirates', 'EK', 'UAE'),
('Lufthansa', 'LH', 'Germany'),
('Air India', 'AI', 'India'),
('British Airways', 'BA', 'UK');
INSERT INTO Airports (airport_name, city, country, iata_code, icao_code) VALUES
('John F. Kennedy International Airport', 'New York', 'USA', 'JFK', 'KJFK'),
('Indira Gandhi International Airport', 'Delhi', 'India', 'DEL', 'VIDP'),
('Chhatrapati Shivaji Maharaj International Airport', 'Mumbai', 'India', 'BOM', 'VABB'),
('Heathrow Airport', 'London', 'UK', 'LHR', 'EGLL'),
('Dubai International Airport', 'Dubai', 'UAE', 'DXB', 'OMDB'),
('Frankfurt Airport', 'Frankfurt', 'Germany', 'FRA', 'EDDF');
INSERT INTO Aircrafts (airline_id, model, capacity, registration_number) VALUES
(1, 'Boeing 737-800', 162, 'N12345'),
(1, 'Airbus A320', 150, 'N54321'),
(2, 'Boeing 777-300ER', 354, 'A6-EMM'),
(3, 'Airbus A380', 509, 'D-AIMK'),
(4, 'Boeing 787-8', 256, 'VT-ANH'),
(5, 'Airbus A350-1000', 331, 'G-XWBA');
INSERT INTO Seats (aircraft_id, seat_number, class, is_emergency_exit) VALUES
(1, '1A', 'First', FALSE),
(1, '1B', 'First', FALSE),
(1, '2A', 'Business', FALSE),
(1, '2B', 'Business', FALSE),
(1, '3A', 'Business', FALSE),
(1, '3B', 'Business', FALSE),
(1, '4A', 'Premium Economy', FALSE),
(1, '4B', 'Premium Economy', FALSE),
(1, '5A', 'Premium Economy', FALSE),
(1, '5B', 'Premium Economy', FALSE),
(1, '6A', 'Economy', TRUE),
(1, '6B', 'Economy', TRUE),
(1, '6C', 'Economy', TRUE),
(1, '6D', 'Economy', TRUE),
(1, '7A', 'Economy', FALSE),
(1, '7B', 'Economy', FALSE),
(1, '7C', 'Economy', FALSE),
(1, '7D', 'Economy', FALSE);
INSERT INTO Flights (flight_number, airline_id, aircraft_id, departure_airport_id, arrival_airport_id, departure_time, arrival_time, base_price, status) VALUES
('DL123', 1, 1, 1, 2, '2023-12-15 08:00:00', '2023-12-16 07:30:00', 850.00, 'Scheduled'),
('EK456', 2, 3, 5, 3, '2023-12-16 14:30:00', '2023-12-16 22:15:00', 750.00, 'Scheduled'),
('LH789', 3, 4, 6, 4, '2023-12-17 10:45:00', '2023-12-17 12:30:00', 450.00, 'Scheduled'),
('AI101', 4, 5, 2, 1, '2023-12-18 23:20:00', '2023-12-19 06:45:00', 900.00, 'Scheduled'),
('BA202', 5, 6, 4, 6, '2023-12-19 07:15:00', '2023-12-19 09:45:00', 380.00, 'Scheduled');
INSERT INTO Customers (first_name, last_name, email, phone, passport_number, date_of_birth) VALUES
('Aman', 'Sinha', 'aman.sinha@email.com', '+11234567890', 'P12345678', '1980-05-15'),
('Priya', 'Patel', 'priya.patel@email.com', '+919876543210', 'P87654321', '1992-08-22'),
('Riyan', 'Sinha', 'riyan.s@email.com', '+441234567890', 'P11223344', '1975-11-30'),
('Aisha', 'Khan', 'aisha.khan@email.com', '+971501234567', 'P55667788', '1988-03-10'),
('Priyanka', 'Sinha', 'priyanka.sinha@email.com', '+4915123456789', 'P99887766', '1995-07-18');
CREATE VIEW AvailableSeats AS
SELECT 
    f.flight_id,
    f.flight_number,
    a.airline_name,
    f.departure_time,
    f.arrival_time,
    dep.airport_name AS departure_airport,
    arr.airport_name AS arrival_airport,
    s.seat_id,
    s.seat_number,
    s.class,
    CASE 
        WHEN s.class = 'Economy' THEN f.base_price
        WHEN s.class = 'Premium Economy' THEN f.base_price * 1.5
        WHEN s.class = 'Business' THEN f.base_price * 2.5
        WHEN s.class = 'First' THEN f.base_price * 4
    END AS seat_price
FROM 
    Flights f
JOIN 
    Airlines a ON f.airline_id = a.airline_id
JOIN 
    Airports dep ON f.departure_airport_id = dep.airport_id
JOIN 
    Airports arr ON f.arrival_airport_id = arr.airport_id
JOIN 
    Seats s ON f.aircraft_id = s.aircraft_id
LEFT JOIN 
    Bookings b ON f.flight_id = b.flight_id AND s.seat_id = b.seat_id AND b.booking_status = 'Confirmed'
WHERE 
    b.booking_id IS NULL AND f.status = 'Scheduled';
CREATE VIEW FlightSearch AS
SELECT 
    f.flight_id,
    f.flight_number,
    a.airline_name,
    f.departure_time,
    f.arrival_time,
    dep.airport_name AS departure_airport,
    dep.city AS departure_city,
    dep.iata_code AS departure_iata,
    arr.airport_name AS arrival_airport,
    arr.city AS arrival_city,
    arr.iata_code AS arrival_iata,
    TIMESTAMPDIFF(MINUTE, f.departure_time, f.arrival_time) AS duration_minutes,
    f.base_price,
    ac.model AS aircraft_model,
    ac.capacity AS aircraft_capacity,
    COUNT(b.booking_id) AS booked_seats,
    (ac.capacity - COUNT(b.booking_id)) AS available_seats,
    f.status
FROM 
    Flights f
JOIN 
    Airlines a ON f.airline_id = a.airline_id
JOIN 
    Airports dep ON f.departure_airport_id = dep.airport_id
JOIN 
    Airports arr ON f.arrival_airport_id = arr.airport_id
JOIN 
    Aircrafts ac ON f.aircraft_id = ac.aircraft_id
LEFT JOIN 
    Bookings b ON f.flight_id = b.flight_id AND b.booking_status = 'Confirmed'
GROUP BY 
    f.flight_id;

DELIMITER //
CREATE PROCEDURE SearchFlights(
    IN p_departure_city VARCHAR(50),
    IN p_arrival_city VARCHAR(50),
    IN p_departure_date DATE
)
BEGIN
    SELECT * FROM FlightSearch
    WHERE departure_city = p_departure_city
    AND arrival_city = p_arrival_city
    AND DATE(departure_time) = p_departure_date
    ORDER BY departure_time;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE BookFlight(
    IN p_customer_id INT,
    IN p_flight_id INT,
    IN p_seat_id INT,
    OUT p_booking_id INT
)
BEGIN
    DECLARE seat_price DECIMAL(10, 2);
    DECLARE seat_available INT;

    SELECT COUNT(*) INTO seat_available
    FROM AvailableSeats
    WHERE flight_id = p_flight_id AND seat_id = p_seat_id;
    
    IF seat_available = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Selected seat is not available';
    ELSE

        SELECT seat_price INTO seat_price
        FROM AvailableSeats
        WHERE flight_id = p_flight_id AND seat_id = p_seat_id;
        INSERT INTO Bookings (customer_id, flight_id, seat_id, total_price)
        VALUES (p_customer_id, p_flight_id, p_seat_id, seat_price);
        
        SET p_booking_id = LAST_INSERT_ID();
    END IF;
END //
DELIMITER ;
DELIMITER //
CREATE PROCEDURE CancelBooking(
    IN p_booking_id INT
)
BEGIN
    DECLARE booking_status VARCHAR(20);
    
    -- Get current booking status
    SELECT booking_status INTO booking_status
    FROM Bookings
    WHERE booking_id = p_booking_id;
    
    IF booking_status IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Booking not found';
    ELSEIF booking_status = 'Cancelled' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Booking is already cancelled';
    ELSE
        -- Update booking status
        UPDATE Bookings
        SET booking_status = 'Cancelled',
            payment_status = 'Refunded'
        WHERE booking_id = p_booking_id;
        
        -- Insert refund record
        INSERT INTO Payments (booking_id, amount, payment_method, transaction_id, status)
        SELECT 
            p_booking_id,
            total_price,
            'Refund',
            CONCAT('REFUND-', UUID()),
            'Success'
        FROM Bookings
        WHERE booking_id = p_booking_id;
    END IF;
END //
DELIMITER ;   
-- Trigger to update flight status after departure
DELIMITER //
CREATE TRIGGER UpdateFlightStatusAfterDeparture
BEFORE UPDATE ON Flights
FOR EACH ROW
BEGIN
    IF NEW.departure_time < NOW() AND OLD.status = 'Scheduled' THEN
        SET NEW.status = 'Departed';
    END IF;
    
    IF NEW.arrival_time < NOW() AND OLD.status IN ('Scheduled', 'Departed') THEN
        SET NEW.status = 'Arrived';
    END IF;
END //
DELIMITER ;

-- Trigger to prevent double booking
DELIMITER //
CREATE TRIGGER PreventDoubleBooking
BEFORE INSERT ON Bookings
FOR EACH ROW
BEGIN
    DECLARE seat_taken INT;
    
    SELECT COUNT(*) INTO seat_taken
    FROM Bookings
    WHERE flight_id = NEW.flight_id 
    AND seat_id = NEW.seat_id
    AND booking_status = 'Confirmed';
    
    IF seat_taken > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Seat is already booked';
    END IF;
END //
DELIMITER ;

-- Trigger to update booking status when payment is made
DELIMITER //
CREATE TRIGGER UpdateBookingAfterPayment
AFTER INSERT ON Payments
FOR EACH ROW
BEGIN
    IF NEW.status = 'Success' THEN
        UPDATE Bookings
        SET payment_status = 'Paid'
        WHERE booking_id = NEW.booking_id;
    END IF;
END //
DELIMITER ;
-- Query to find all bookings for a customer
SELECT 
    b.booking_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    f.flight_number,
    a.airline_name,
    dep.airport_name AS departure_airport,
    arr.airport_name AS arrival_airport,
    f.departure_time,
    f.arrival_time,
    s.seat_number,
    s.class,
    b.total_price,
    b.booking_status,
    b.payment_status
FROM 
    Bookings b
JOIN 
    Customers c ON b.customer_id = c.customer_id
JOIN 
    Flights f ON b.flight_id = f.flight_id
JOIN 
    Airlines a ON f.airline_id = a.airline_id
JOIN 
    Airports dep ON f.departure_airport_id = dep.airport_id
JOIN 
    Airports arr ON f.arrival_airport_id = arr.airport_id
JOIN 
    Seats s ON b.seat_id = s.seat_id
WHERE 
    c.customer_id = 1; -- Replace with desired customer ID

-- Query to find most popular flights
SELECT 
    f.flight_number,
    a.airline_name,
    dep.airport_name AS departure_airport,
    arr.airport_name AS arrival_airport,
    COUNT(b.booking_id) AS total_bookings,
    SUM(b.total_price) AS total_revenue
FROM 
    Flights f
JOIN 
    Airlines a ON f.airline_id = a.airline_id
JOIN 
    Airports dep ON f.departure_airport_id = dep.airport_id
JOIN 
    Airports arr ON f.arrival_airport_id = arr.airport_id
LEFT JOIN 
    Bookings b ON f.flight_id = b.flight_id AND b.booking_status = 'Confirmed'
GROUP BY 
    f.flight_id
ORDER BY 
    total_bookings DESC
LIMIT 10;

-- Query to find revenue by airline
SELECT 
    a.airline_name,
    COUNT(b.booking_id) AS total_bookings,
    SUM(b.total_price) AS total_revenue,
    AVG(b.total_price) AS average_booking_value
FROM 
    Airlines a
LEFT JOIN 
    Flights f ON a.airline_id = f.airline_id
LEFT JOIN 
    Bookings b ON f.flight_id = b.flight_id AND b.booking_status = 'Confirmed'
GROUP BY 
    a.airline_id
ORDER BY 
    total_revenue DESC;
    -- Create a stored procedure for booking summary report
DELIMITER //
CREATE PROCEDURE GenerateBookingSummaryReport(
    IN p_start_date DATE,
    IN p_end_date DATE
)
BEGIN
    -- Summary by airline
    SELECT 
        a.airline_name,
        COUNT(b.booking_id) AS total_bookings,
        SUM(b.total_price) AS total_revenue,
        COUNT(DISTINCT b.customer_id) AS unique_customers
    FROM 
        Airlines a
    LEFT JOIN 
        Flights f ON a.airline_id = f.airline_id
    LEFT JOIN 
        Bookings b ON f.flight_id = b.flight_id
    WHERE 
        DATE(b.booking_date) BETWEEN p_start_date AND p_end_date
        AND b.booking_status = 'Confirmed'
    GROUP BY 
        a.airline_id
    ORDER BY 
        total_revenue DESC;
    
    -- Summary by flight route
    SELECT 
        CONCAT(dep.city, ' (', dep.iata_code, ') - ', arr.city, ' (', arr.iata_code, ')') AS route,
        COUNT(b.booking_id) AS total_bookings,
        SUM(b.total_price) AS total_revenue
    FROM 
        Flights f
    JOIN 
        Airports dep ON f.departure_airport_id = dep.airport_id
    JOIN 
        Airports arr ON f.arrival_airport_id = arr.airport_id
    LEFT JOIN 
        Bookings b ON f.flight_id = b.flight_id
    WHERE 
        DATE(b.booking_date) BETWEEN p_start_date AND p_end_date
        AND b.booking_status = 'Confirmed'
    GROUP BY 
        route
    ORDER BY 
        total_revenue DESC
    LIMIT 10;
    
    -- Summary by customer type (new vs returning)
    SELECT 
        CASE 
            WHEN MIN(b1.booking_date) = b.booking_date THEN 'New Customer'
            ELSE 'Returning Customer'
        END AS customer_type,
        COUNT(DISTINCT b.customer_id) AS customer_count,
        COUNT(b.booking_id) AS booking_count,
        SUM(b.total_price) AS total_revenue
    FROM 
        Bookings b
    JOIN 
        (SELECT customer_id, MIN(booking_date) AS booking_date FROM Bookings GROUP BY customer_id) b1
        ON b.customer_id = b1.customer_id
    WHERE 
        DATE(b.booking_date) BETWEEN p_start_date AND p_end_date
        AND b.booking_status = 'Confirmed'
    GROUP BY 
        customer_type;
END //
DELIMITER ;