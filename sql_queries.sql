-- ============================================================================
-- SQL QUERIES SECTION
-- ============================================================================

USE airline_management;

-- ============================================================================
-- GENERAL QUERIES
-- ============================================================================

-- Query 1: List all upcoming flights
SELECT 
    f.flight_number,
    f.departure_time,
    f.arrival_time,
    dep.airport_name AS departure_airport,
    arr.airport_name AS arrival_airport,
    f.available_seats,
    f.price,
    f.status
FROM flights f
JOIN airports dep ON f.departure_airport_id = dep.airport_id
JOIN airports arr ON f.arrival_airport_id = arr.airport_id
WHERE f.departure_time > NOW() AND f.status = 'Scheduled'
ORDER BY f.departure_time;

-- Query 2: Display fully booked flights
SELECT 
    f.flight_number,
    f.departure_time,
    dep.city AS departure_city,
    arr.city AS arrival_city,
    f.available_seats
FROM flights f
JOIN airports dep ON f.departure_airport_id = dep.airport_id
JOIN airports arr ON f.arrival_airport_id = arr.airport_id
WHERE f.available_seats = 0;

-- Query 3: Show ticket details for a specific passenger
SELECT 
    p.first_name,
    p.last_name,
    t.ticket_number,
    f.flight_number,
    b.seat_number,
    f.departure_time,
    t.price,
    b.booking_status
FROM passengers p
JOIN bookings b ON p.passenger_id = b.passenger_id
JOIN tickets t ON b.booking_id = t.booking_id
JOIN flights f ON b.flight_id = f.flight_id
WHERE p.passenger_id = 1;

-- Query 4: Check aircraft availability
SELECT 
    a.aircraft_id,
    a.model,
    a.manufacturer,
    a.status,
    COUNT(f.flight_id) AS scheduled_flights
FROM aircraft a
LEFT JOIN flights f ON a.aircraft_id = f.aircraft_id 
    AND f.departure_time > NOW() 
    AND f.status = 'Scheduled'
WHERE a.status = 'Active'
GROUP BY a.aircraft_id;

-- Query 5: Count passengers on each flight
SELECT 
    f.flight_number,
    f.departure_time,
    dep.city AS from_city,
    arr.city AS to_city,
    COUNT(b.booking_id) AS total_passengers,
    f.available_seats
FROM flights f
JOIN airports dep ON f.departure_airport_id = dep.airport_id
JOIN airports arr ON f.arrival_airport_id = arr.airport_id
LEFT JOIN bookings b ON f.flight_id = b.flight_id AND b.booking_status = 'Confirmed'
GROUP BY f.flight_id
ORDER BY f.departure_time;

-- ============================================================================
-- JOIN QUERIES
-- ============================================================================

-- Query 6: Passenger + Ticket + Flight JOIN
SELECT 
    p.passenger_id,
    CONCAT(p.first_name, ' ', p.last_name) AS passenger_name,
    p.email,
    t.ticket_number,
    f.flight_number,
    b.seat_number,
    dep.airport_code AS departure,
    arr.airport_code AS arrival,
    f.departure_time,
    t.price
FROM passengers p
INNER JOIN bookings b ON p.passenger_id = b.passenger_id
INNER JOIN tickets t ON b.booking_id = t.booking_id
INNER JOIN flights f ON b.flight_id = f.flight_id
INNER JOIN airports dep ON f.departure_airport_id = dep.airport_id
INNER JOIN airports arr ON f.arrival_airport_id = arr.airport_id
WHERE b.booking_status = 'Confirmed'
ORDER BY f.departure_time;

-- Query 7: Staff assigned to flights
SELECT 
    f.flight_number,
    f.departure_time,
    CONCAT(s.first_name, ' ', s.last_name) AS staff_name,
    s.role,
    dep.city AS departure_city,
    arr.city AS arrival_city
FROM flights f
INNER JOIN staff_assignments sa ON f.flight_id = sa.flight_id
INNER JOIN staff s ON sa.staff_id = s.staff_id
INNER JOIN airports dep ON f.departure_airport_id = dep.airport_id
INNER JOIN airports arr ON f.arrival_airport_id = arr.airport_id
ORDER BY f.departure_time, s.role;

-- Query 8: Aircraft + Flights schedule
SELECT 
    a.model AS aircraft_model,
    a.manufacturer,
    a.total_seats,
    f.flight_number,
    f.departure_time,
    f.arrival_time,
    dep.airport_name AS departure_airport,
    arr.airport_name AS arrival_airport,
    f.status
FROM aircraft a
INNER JOIN flights f ON a.aircraft_id = f.aircraft_id
INNER JOIN airports dep ON f.departure_airport_id = dep.airport_id
INNER JOIN airports arr ON f.arrival_airport_id = arr.airport_id
WHERE f.departure_time > NOW()
ORDER BY a.model, f.departure_time;

-- ============================================================================
-- SUBQUERIES
-- ============================================================================

-- Query 9: Find the most booked route
SELECT 
    dep.city AS departure_city,
    arr.city AS arrival_city,
    COUNT(b.booking_id) AS total_bookings
FROM flights f
JOIN airports dep ON f.departure_airport_id = dep.airport_id
JOIN airports arr ON f.arrival_airport_id = arr.airport_id
JOIN bookings b ON f.flight_id = b.flight_id
WHERE b.booking_status = 'Confirmed'
GROUP BY f.departure_airport_id, f.arrival_airport_id
HAVING COUNT(b.booking_id) = (
    SELECT MAX(booking_count)
    FROM (
        SELECT COUNT(booking_id) AS booking_count
        FROM bookings
        WHERE booking_status = 'Confirmed'
        GROUP BY flight_id
    ) AS subquery
);

-- Query 10: Top 5 frequent passengers
SELECT 
    p.passenger_id,
    CONCAT(p.first_name, ' ', p.last_name) AS passenger_name,
    p.email,
    COUNT(b.booking_id) AS total_bookings,
    SUM(t.price) AS total_spent
FROM passengers p
JOIN bookings b ON p.passenger_id = b.passenger_id
JOIN tickets t ON b.booking_id = t.booking_id
WHERE b.booking_status = 'Confirmed'
GROUP BY p.passenger_id
ORDER BY total_bookings DESC
LIMIT 5;

-- ============================================================================
-- VIEWS
-- ============================================================================

-- View 1: Daily flight schedule
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

-- View 2: Airport-wise operations
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

-- Query to use views
SELECT * FROM daily_flight_schedule WHERE flight_date = CURDATE();
SELECT * FROM airport_operations ORDER BY total_flights DESC;

-- ============================================================================
-- STORED PROCEDURES
-- ============================================================================

-- Procedure 1: Book a ticket
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
DELIMITER ;

-- Procedure 2: Cancel a booking
DELIMITER //
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
-- TRIGGERS
-- ============================================================================

-- Trigger 1: Reduce available seats after booking
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
DELIMITER ;

-- Trigger 2: Update flight status automatically
DELIMITER //
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
DELIMITER ;

-- Trigger 3: Restore seats on booking cancellation
DELIMITER //
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
-- ADDITIONAL USEFUL QUERIES
-- ============================================================================

-- Query: Revenue by flight
SELECT 
    f.flight_number,
    dep.city AS from_city,
    arr.city AS to_city,
    COUNT(b.booking_id) AS tickets_sold,
    SUM(t.price) AS total_revenue
FROM flights f
LEFT JOIN bookings b ON f.flight_id = b.flight_id AND b.booking_status = 'Confirmed'
LEFT JOIN tickets t ON b.booking_id = t.booking_id
JOIN airports dep ON f.departure_airport_id = dep.airport_id
JOIN airports arr ON f.arrival_airport_id = arr.airport_id
GROUP BY f.flight_id
ORDER BY total_revenue DESC;

-- Query: Passengers without bookings
SELECT 
    p.passenger_id,
    CONCAT(p.first_name, ' ', p.last_name) AS passenger_name,
    p.email
FROM passengers p
LEFT JOIN bookings b ON p.passenger_id = b.passenger_id
WHERE b.booking_id IS NULL;

-- Query: Flights by status
SELECT 
    status,
    COUNT(*) AS flight_count
FROM flights
GROUP BY status;
