-- ============================================================================
-- AIRLINE MANAGEMENT SYSTEM - 
-- Execute this file in phpMyAdmin to create the entire database
-- ============================================================================

-- Create and use database
CREATE DATABASE IF NOT EXISTS airline_management;
USE airline_management;

-- ============================================================================
-- DROP EXISTING TABLES (if any)
-- ============================================================================
DROP TABLE IF EXISTS staff_assignments;
DROP TABLE IF EXISTS tickets;
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS flights;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS admins;
DROP TABLE IF EXISTS passengers;
DROP TABLE IF EXISTS airports;
DROP TABLE IF EXISTS aircraft;

-- ============================================================================
-- CREATE TABLES
-- ============================================================================

CREATE TABLE aircraft (
    aircraft_id INT AUTO_INCREMENT PRIMARY KEY,
    model VARCHAR(100) NOT NULL,
    manufacturer VARCHAR(100) NOT NULL,
    total_seats INT NOT NULL CHECK (total_seats > 0),
    status ENUM('Active', 'Maintenance', 'Retired') DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE airports (
    airport_id INT AUTO_INCREMENT PRIMARY KEY,
    airport_code VARCHAR(10) UNIQUE NOT NULL,
    airport_name VARCHAR(200) NOT NULL,
    city VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE passengers (
    passenger_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    phone VARCHAR(20) NOT NULL,
    passport_number VARCHAR(50) UNIQUE NOT NULL,
    date_of_birth DATE NOT NULL,
    nationality VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE flights (
    flight_id INT AUTO_INCREMENT PRIMARY KEY,
    flight_number VARCHAR(20) UNIQUE NOT NULL,
    aircraft_id INT NOT NULL,
    departure_airport_id INT NOT NULL,
    arrival_airport_id INT NOT NULL,
    departure_time DATETIME NOT NULL,
    arrival_time DATETIME NOT NULL,
    available_seats INT NOT NULL CHECK (available_seats >= 0),
    price DECIMAL(10, 2) NOT NULL CHECK (price > 0),
    status ENUM('Scheduled', 'Boarding', 'Departed', 'Arrived', 'Cancelled', 'Delayed') DEFAULT 'Scheduled',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (aircraft_id) REFERENCES aircraft(aircraft_id) ON DELETE RESTRICT,
    FOREIGN KEY (departure_airport_id) REFERENCES airports(airport_id) ON DELETE RESTRICT,
    FOREIGN KEY (arrival_airport_id) REFERENCES airports(airport_id) ON DELETE RESTRICT,
    CHECK (departure_airport_id != arrival_airport_id),
    CHECK (arrival_time > departure_time)
);

CREATE TABLE bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    passenger_id INT NOT NULL,
    flight_id INT NOT NULL,
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    seat_number VARCHAR(10) NOT NULL,
    booking_status ENUM('Confirmed', 'Cancelled', 'Pending') DEFAULT 'Confirmed',
    FOREIGN KEY (passenger_id) REFERENCES passengers(passenger_id) ON DELETE CASCADE,
    FOREIGN KEY (flight_id) REFERENCES flights(flight_id) ON DELETE CASCADE,
    UNIQUE KEY unique_seat_per_flight (flight_id, seat_number)
);

CREATE TABLE tickets (
    ticket_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT UNIQUE NOT NULL,
    ticket_number VARCHAR(50) UNIQUE NOT NULL,
    issue_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    price DECIMAL(10, 2) NOT NULL CHECK (price > 0),
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE
);

CREATE TABLE staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    role ENUM('Pilot', 'Co-Pilot', 'Flight Attendant', 'Ground Staff', 'Engineer') NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    phone VARCHAR(20) NOT NULL,
    hire_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE staff_assignments (
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    staff_id INT NOT NULL,
    flight_id INT NOT NULL,
    assignment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON DELETE CASCADE,
    FOREIGN KEY (flight_id) REFERENCES flights(flight_id) ON DELETE CASCADE,
    UNIQUE KEY unique_staff_flight (staff_id, flight_id)
);

CREATE TABLE admins (
    admin_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================================
-- INSERT SAMPLE DATA
-- ============================================================================

INSERT INTO aircraft (model, manufacturer, total_seats, status) VALUES
('Boeing 737-800', 'Boeing', 189, 'Active'),
('Airbus A320', 'Airbus', 180, 'Active'),
('Boeing 777-300ER', 'Boeing', 396, 'Active'),
('Airbus A350-900', 'Airbus', 325, 'Active'),
('Boeing 787-9 Dreamliner', 'Boeing', 290, 'Active'),
('Airbus A380', 'Airbus', 525, 'Maintenance'),
('Boeing 747-8', 'Boeing', 467, 'Active'),
('Embraer E190', 'Embraer', 114, 'Active');

INSERT INTO airports (airport_code, airport_name, city, country) VALUES
('DEL', 'Indira Gandhi International Airport', 'New Delhi', 'India'),
('BOM', 'Chhatrapati Shivaji Maharaj International Airport', 'Mumbai', 'India'),
('BLR', 'Kempegowda International Airport', 'Bangalore', 'India'),
('MAA', 'Chennai International Airport', 'Chennai', 'India'),
('CCU', 'Netaji Subhas Chandra Bose International Airport', 'Kolkata', 'India'),
('HYD', 'Rajiv Gandhi International Airport', 'Hyderabad', 'India'),
('DXB', 'Dubai International Airport', 'Dubai', 'UAE'),
('SIN', 'Singapore Changi Airport', 'Singapore', 'Singapore'),
('LHR', 'London Heathrow Airport', 'London', 'United Kingdom'),
('JFK', 'John F. Kennedy International Airport', 'New York', 'USA');

INSERT INTO passengers (first_name, last_name, email, phone, passport_number, date_of_birth, nationality) VALUES
('Rajesh', 'Kumar', 'rajesh.kumar@email.com', '+91-9876543210', 'P1234567', '1985-03-15', 'Indian'),
('Priya', 'Sharma', 'priya.sharma@email.com', '+91-9876543211', 'P1234568', '1990-07-22', 'Indian'),
('Amit', 'Patel', 'amit.patel@email.com', '+91-9876543212', 'P1234569', '1988-11-10', 'Indian'),
('Sneha', 'Reddy', 'sneha.reddy@email.com', '+91-9876543213', 'P1234570', '1992-05-18', 'Indian'),
('Vikram', 'Singh', 'vikram.singh@email.com', '+91-9876543214', 'P1234571', '1987-09-25', 'Indian'),
('Anita', 'Desai', 'anita.desai@email.com', '+91-9876543215', 'P1234572', '1995-01-30', 'Indian'),
('Rahul', 'Verma', 'rahul.verma@email.com', '+91-9876543216', 'P1234573', '1983-12-05', 'Indian'),
('Kavita', 'Nair', 'kavita.nair@email.com', '+91-9876543217', 'P1234574', '1991-08-14', 'Indian'),
('Suresh', 'Iyer', 'suresh.iyer@email.com', '+91-9876543218', 'P1234575', '1986-04-20', 'Indian'),
('Deepa', 'Menon', 'deepa.menon@email.com', '+91-9876543219', 'P1234576', '1994-06-12', 'Indian');

INSERT INTO flights (flight_number, aircraft_id, departure_airport_id, arrival_airport_id, departure_time, arrival_time, available_seats, price, status) VALUES
('AI101', 1, 1, 2, '2024-12-15 06:00:00', '2024-12-15 08:30:00', 150, 4500.00, 'Scheduled'),
('AI102', 2, 2, 3, '2024-12-15 09:00:00', '2024-12-15 11:00:00', 160, 3800.00, 'Scheduled'),
('AI103', 3, 1, 7, '2024-12-15 14:00:00', '2024-12-15 18:30:00', 350, 25000.00, 'Scheduled'),
('AI104', 4, 3, 8, '2024-12-16 10:00:00', '2024-12-16 16:00:00', 300, 32000.00, 'Scheduled'),
('AI105', 5, 2, 9, '2024-12-16 22:00:00', '2024-12-17 06:30:00', 250, 45000.00, 'Scheduled'),
('AI106', 1, 4, 1, '2024-12-17 07:00:00', '2024-12-17 09:30:00', 180, 4200.00, 'Scheduled'),
('AI107', 2, 5, 6, '2024-12-17 12:00:00', '2024-12-17 14:00:00', 170, 3500.00, 'Scheduled'),
('AI108', 7, 1, 10, '2024-12-18 01:00:00', '2024-12-18 14:00:00', 400, 55000.00, 'Scheduled'),
('AI109', 8, 6, 4, '2024-12-18 15:00:00', '2024-12-18 17:00:00', 100, 3200.00, 'Scheduled'),
('AI110', 1, 2, 1, '2024-12-18 18:00:00', '2024-12-18 20:30:00', 0, 4500.00, 'Scheduled');

INSERT INTO bookings (passenger_id, flight_id, seat_number, booking_status) VALUES
(1, 1, '12A', 'Confirmed'),
(2, 1, '12B', 'Confirmed'),
(3, 2, '15C', 'Confirmed'),
(4, 3, '22D', 'Confirmed'),
(5, 4, '18A', 'Confirmed'),
(6, 5, '25B', 'Confirmed'),
(7, 6, '10C', 'Confirmed'),
(8, 7, '14D', 'Confirmed'),
(9, 8, '30A', 'Confirmed'),
(10, 9, '8B', 'Confirmed'),
(1, 3, '22E', 'Confirmed'),
(2, 4, '18B', 'Cancelled'),
(3, 5, '25C', 'Confirmed');

INSERT INTO tickets (booking_id, ticket_number, price) VALUES
(1, 'TKT-AI101-001', 4500.00),
(2, 'TKT-AI101-002', 4500.00),
(3, 'TKT-AI102-001', 3800.00),
(4, 'TKT-AI103-001', 25000.00),
(5, 'TKT-AI104-001', 32000.00),
(6, 'TKT-AI105-001', 45000.00),
(7, 'TKT-AI106-001', 4200.00),
(8, 'TKT-AI107-001', 3500.00),
(9, 'TKT-AI108-001', 55000.00),
(10, 'TKT-AI109-001', 3200.00),
(11, 'TKT-AI103-002', 25000.00),
(12, 'TKT-AI104-002', 32000.00),
(13, 'TKT-AI105-002', 45000.00);

INSERT INTO staff (first_name, last_name, role, email, phone, hire_date) VALUES
('Captain', 'Sharma', 'Pilot', 'captain.sharma@airline.com', '+91-9800000001', '2015-01-15'),
('First Officer', 'Gupta', 'Co-Pilot', 'fo.gupta@airline.com', '+91-9800000002', '2017-03-20'),
('Sarah', 'Johnson', 'Flight Attendant', 'sarah.j@airline.com', '+91-9800000003', '2019-06-10'),
('Ravi', 'Kumar', 'Flight Attendant', 'ravi.k@airline.com', '+91-9800000004', '2020-02-14'),
('Engineer', 'Patel', 'Engineer', 'eng.patel@airline.com', '+91-9800000005', '2016-08-22'),
('Captain', 'Singh', 'Pilot', 'captain.singh@airline.com', '+91-9800000006', '2014-11-30'),
('First Officer', 'Reddy', 'Co-Pilot', 'fo.reddy@airline.com', '+91-9800000007', '2018-05-18'),
('Meera', 'Nair', 'Flight Attendant', 'meera.n@airline.com', '+91-9800000008', '2021-01-25');

INSERT INTO staff_assignments (staff_id, flight_id) VALUES
(1, 1), (2, 1), (3, 1), (4, 1),
(6, 2), (7, 2), (8, 2),
(1, 3), (2, 3), (3, 3), (4, 3),
(6, 4), (7, 4), (8, 4),
(1, 5), (2, 5), (3, 5);

INSERT INTO admins (username, password, email) VALUES
('admin', MD5('admin123'), 'admin@airline.com'),
('manager', MD5('manager123'), 'manager@airline.com');


-- ============================================================================
-- CREATE VIEWS
-- ============================================================================

CREATE OR REPLACE VIEW daily_flight_schedule AS
SELECT 
    f.flight_number,
    DATE(f.departure_time) AS flight_date,
    TIME(f.departure_time) AS departure_time,
    TIME(f.arrival_time) AS arrival_time,
    dep.airport_code AS from_airport,
    arr.airport_code AS to_airport,
    dep.city AS from_city,
    arr.city AS to_city,
    a.model AS aircraft,
    f.available_seats,
    f.price,
    f.status
FROM flights f
JOIN airports dep ON f.departure_airport_id = dep.airport_id
JOIN airports arr ON f.arrival_airport_id = arr.airport_id
JOIN aircraft a ON f.aircraft_id = a.aircraft_id
ORDER BY f.departure_time;

CREATE OR REPLACE VIEW airport_operations AS
SELECT 
    ap.airport_code,
    ap.airport_name,
    ap.city,
    COUNT(DISTINCT CASE WHEN f.departure_airport_id = ap.airport_id THEN f.flight_id END) AS departures,
    COUNT(DISTINCT CASE WHEN f.arrival_airport_id = ap.airport_id THEN f.flight_id END) AS arrivals,
    COUNT(DISTINCT CASE WHEN f.departure_airport_id = ap.airport_id OR f.arrival_airport_id = ap.airport_id THEN f.flight_id END) AS total_flights
FROM airports ap
LEFT JOIN flights f ON ap.airport_id = f.departure_airport_id OR ap.airport_id = f.arrival_airport_id
GROUP BY ap.airport_id;

-- ============================================================================
-- CREATE STORED PROCEDURES
-- ============================================================================

DELIMITER //

CREATE PROCEDURE book_ticket(
    IN p_passenger_id INT,
    IN p_flight_id INT,
    IN p_seat_number VARCHAR(10)
)
BEGIN
    DECLARE v_available_seats INT;
    DECLARE v_price DECIMAL(10,2);
    DECLARE v_booking_id INT;
    
    -- Check available seats
    SELECT available_seats, price INTO v_available_seats, v_price
    FROM flights
    WHERE flight_id = p_flight_id;
    
    IF v_available_seats > 0 THEN
        -- Create booking
        INSERT INTO bookings (passenger_id, flight_id, seat_number, booking_status)
        VALUES (p_passenger_id, p_flight_id, p_seat_number, 'Confirmed');
        
        SET v_booking_id = LAST_INSERT_ID();
        
        -- Generate ticket
        INSERT INTO tickets (booking_id, ticket_number, price)
        VALUES (v_booking_id, CONCAT('TKT-', p_flight_id, '-', v_booking_id), v_price);
        
        -- Update available seats
        UPDATE flights
        SET available_seats = available_seats - 1
        WHERE flight_id = p_flight_id;
        
        SELECT 'Booking successful!' AS message, v_booking_id AS booking_id;
    ELSE
        SELECT 'No seats available!' AS message;
    END IF;
END //

CREATE PROCEDURE cancel_booking(
    IN p_booking_id INT
)
BEGIN
    DECLARE v_flight_id INT;
    DECLARE v_booking_status VARCHAR(20);
    
    -- Get booking details
    SELECT flight_id, booking_status INTO v_flight_id, v_booking_status
    FROM bookings
    WHERE booking_id = p_booking_id;
    
    IF v_booking_status = 'Confirmed' THEN
        -- Update booking status
        UPDATE bookings
        SET booking_status = 'Cancelled'
        WHERE booking_id = p_booking_id;
        
        -- Restore available seats
        UPDATE flights
        SET available_seats = available_seats + 1
        WHERE flight_id = v_flight_id;
        
        SELECT 'Booking cancelled successfully!' AS message;
    ELSE
        SELECT 'Booking already cancelled or invalid!' AS message;
    END IF;
END //

DELIMITER ;

-- ============================================================================
-- CREATE TRIGGERS
-- ============================================================================

DELIMITER //

CREATE TRIGGER after_booking_insert
AFTER INSERT ON bookings
FOR EACH ROW
BEGIN
    IF NEW.booking_status = 'Confirmed' THEN
        UPDATE flights
        SET available_seats = available_seats - 1
        WHERE flight_id = NEW.flight_id;
    END IF;
END //

CREATE TRIGGER update_flight_status
BEFORE UPDATE ON flights
FOR EACH ROW
BEGIN
    IF NEW.departure_time <= NOW() AND OLD.status = 'Scheduled' THEN
        SET NEW.status = 'Departed';
    END IF;
    
    IF NEW.arrival_time <= NOW() AND OLD.status = 'Departed' THEN
        SET NEW.status = 'Arrived';
    END IF;
END //

CREATE TRIGGER after_booking_cancel
AFTER UPDATE ON bookings
FOR EACH ROW
BEGIN
    IF OLD.booking_status = 'Confirmed' AND NEW.booking_status = 'Cancelled' THEN
        UPDATE flights
        SET available_seats = available_seats + 1
        WHERE flight_id = NEW.flight_id;
    END IF;
END //

DELIMITER ;

-- ============================================================================
-- VERIFICATION QUERIES
-- ============================================================================

-- Check all tables
SHOW TABLES;

-- Count records in each table
SELECT 'aircraft' AS table_name, COUNT(*) AS record_count FROM aircraft
UNION ALL
SELECT 'airports', COUNT(*) FROM airports
UNION ALL
SELECT 'passengers', COUNT(*) FROM passengers
UNION ALL
SELECT 'flights', COUNT(*) FROM flights
UNION ALL
SELECT 'bookings', COUNT(*) FROM bookings
UNION ALL
SELECT 'tickets', COUNT(*) FROM tickets
UNION ALL
SELECT 'staff', COUNT(*) FROM staff
UNION ALL
SELECT 'staff_assignments', COUNT(*) FROM staff_assignments
UNION ALL
SELECT 'admins', COUNT(*) FROM admins;

-- View sample data
SELECT * FROM daily_flight_schedule LIMIT 5;
SELECT * FROM airport_operations;

-- ============================================================================
-- DATABASE SETUP COMPLETE
-- ============================================================================
-- You can now access the application at: http://localhost/airline/
-- Admin credentials: username=admin, password=admin123
-- ============================================================================
