-- ============================================================================
-- SAMPLE DATA INSERTION
-- ============================================================================

USE airline_management;

-- ============================================================================
-- INSERT AIRCRAFT DATA
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

-- ============================================================================
-- INSERT AIRPORTS DATA
-- ============================================================================
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

-- ============================================================================
-- INSERT PASSENGERS DATA
-- ============================================================================
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

-- ============================================================================
-- INSERT FLIGHTS DATA
-- ============================================================================
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

-- ============================================================================
-- INSERT BOOKINGS DATA
-- ============================================================================
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

-- ============================================================================
-- INSERT TICKETS DATA
-- ============================================================================
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

-- ============================================================================
-- INSERT STAFF DATA
-- ============================================================================
INSERT INTO staff (first_name, last_name, role, email, phone, hire_date) VALUES
('Captain', 'Sharma', 'Pilot', 'captain.sharma@airline.com', '+91-9800000001', '2015-01-15'),
('First Officer', 'Gupta', 'Co-Pilot', 'fo.gupta@airline.com', '+91-9800000002', '2017-03-20'),
('Sarah', 'Johnson', 'Flight Attendant', 'sarah.j@airline.com', '+91-9800000003', '2019-06-10'),
('Ravi', 'Kumar', 'Flight Attendant', 'ravi.k@airline.com', '+91-9800000004', '2020-02-14'),
('Engineer', 'Patel', 'Engineer', 'eng.patel@airline.com', '+91-9800000005', '2016-08-22'),
('Captain', 'Singh', 'Pilot', 'captain.singh@airline.com', '+91-9800000006', '2014-11-30'),
('First Officer', 'Reddy', 'Co-Pilot', 'fo.reddy@airline.com', '+91-9800000007', '2018-05-18'),
('Meera', 'Nair', 'Flight Attendant', 'meera.n@airline.com', '+91-9800000008', '2021-01-25');

-- ============================================================================
-- INSERT STAFF ASSIGNMENTS DATA
-- ============================================================================
INSERT INTO staff_assignments (staff_id, flight_id) VALUES
(1, 1), (2, 1), (3, 1), (4, 1),
(6, 2), (7, 2), (8, 2),
(1, 3), (2, 3), (3, 3), (4, 3),
(6, 4), (7, 4), (8, 4),
(1, 5), (2, 5), (3, 5);

-- ============================================================================
-- INSERT ADMIN DATA (Password: admin123 - should be hashed in production)
-- ============================================================================
INSERT INTO admins (username, password, email) VALUES
('admin', MD5('admin123'), 'admin@airline.com'),
('manager', MD5('manager123'), 'manager@airline.com');
