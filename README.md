# ✈️ Airline Management System

A comprehensive Database Systems mini-project for managing airline operations including flights, passengers, bookings, and staff.

## 📋 Project Overview

This system provides complete airline management functionality with:
- Flight scheduling and management
- Passenger registration and booking
- Ticket generation and cancellation
- Staff assignment tracking
- Admin control panel
- Real-time seat availability

## 🚀 Quick Start Guide

### Prerequisites
- XAMPP (Apache + MySQL + PHP)
- Web browser
- Text editor (optional)

### Installation Steps

1. **Install XAMPP**
   - Download from: https://www.apachefriends.org/
   - Install and start Apache & MySQL services

2. **Create Database**
   - Open phpMyAdmin: http://localhost/phpmyadmin
   - Click "Import" tab
   - Select `COMPLETE_DATABASE.sql`
   - Click "Go" to execute

3. **Setup Files**
   - Copy all project files to: `C:\xampp\htdocs\airline\`
   - Ensure config.php has correct database credentials

4. **Access Application**
   - Open browser: http://localhost/airline/
   - Admin login: username=`admin`, password=`admin123`

## 📁 Project Structure

```
airline/
├── index.html                  # Homepage
├── config.php                  # Database connection
├── register_passenger.php      # Passenger registration
├── book_ticket.php            # Ticket booking
├── cancel_booking.php         # View & cancel bookings
├── admin_login.php            # Admin authentication
├── manage_flights.php         # Flight management (admin)
├── logout.php                 # Session logout
├── COMPLETE_DATABASE.sql      # Full database script
├── database_schema.sql        # Schema only
├── sample_data.sql            # Sample data only
├── sql_queries.sql            # All queries
├── PROJECT_DOCUMENTATION.txt  # Complete documentation
├── XAMPP_IMPLEMENTATION_GUIDE.txt  # Setup guide
└── README.md                  # This file
```

## 🗄️ Database Schema

### Tables (9)
- `aircraft` - Aircraft fleet information
- `airports` - Airport details
- `flights` - Flight schedules
- `passengers` - Passenger records
- `bookings` - Booking information
- `tickets` - Ticket details
- `staff` - Staff members
- `staff_assignments` - Staff-flight assignments
- `admins` - Admin users

### Views (2)
- `daily_flight_schedule` - Daily flight information
- `airport_operations` - Airport statistics

### Stored Procedures (2)
- `book_ticket()` - Complete booking process
- `cancel_booking()` - Booking cancellation

### Triggers (3)
- `after_booking_insert` - Auto-reduce seats
- `update_flight_status` - Auto-update status
- `after_booking_cancel` - Restore seats

## 🎯 Features

### User Features
- ✅ Passenger registration with validation
- ✅ Search and book available flights
- ✅ View booking history
- ✅ Cancel bookings
- ✅ Real-time seat availability
- ✅ Automatic ticket generation

### Admin Features
- ✅ Secure login system
- ✅ Add/delete flights
- ✅ View all bookings
- ✅ Manage aircraft and airports
- ✅ Staff assignment tracking

## 📊 Sample Data

The database includes:
- 8 Aircraft (Boeing, Airbus, Embraer)
- 10 Airports (Indian & International)
- 10 Passengers
- 10 Flights
- 13 Bookings
- 8 Staff members
- 2 Admin accounts

## 🔐 Default Credentials

**Admin Account:**
- Username: `admin`
- Password: `admin123`

**Manager Account:**
- Username: `manager`
- Password: `manager123`

## 📝 SQL Queries Included

### General Queries
1. List all upcoming flights
2. Display fully booked flights
3. Show ticket details for passenger
4. Check aircraft availability
5. Count passengers on each flight

### JOIN Queries
6. Passenger + Ticket + Flight details
7. Staff assigned to flights
8. Aircraft + Flight schedule

### Subqueries
9. Find most booked route
10. Top 5 frequent passengers

## 🛠️ Technologies Used

- **Backend:** PHP 7.4+
- **Database:** MySQL 8.0+
- **Frontend:** HTML5, CSS3
- **Server:** Apache (XAMPP)
- **Tools:** phpMyAdmin

## 📖 Documentation

Detailed documentation available in:
- `PROJECT_DOCUMENTATION.txt` - Complete project details
- `XAMPP_IMPLEMENTATION_GUIDE.txt` - Step-by-step setup
- `sql_queries.sql` - All SQL queries with explanations

## 🎓 Viva Preparation

Key topics to study:
- Database normalization (3NF)
- ACID properties
- Triggers vs Stored Procedures
- JOIN operations
- Transaction management
- Constraint types
- Indexing strategies

## 🔧 Troubleshooting

**Port 80 in use:**
- Change Apache port to 8080 in httpd.conf
- Access via: http://localhost:8080/airline/

**MySQL connection error:**
- Check XAMPP MySQL is running
- Verify credentials in config.php

**Stored procedures not working:**
- Execute procedures individually
- Check DELIMITER syntax

## 🚀 Future Enhancements

- Payment gateway integration
- Email/SMS notifications
- Mobile app development
- Real-time flight tracking
- Seat map visualization
- Multi-language support
- Analytics dashboard
- API development

## 📄 License

This is an educational project for Database Systems course.

## 👥 Contributors

Database Systems Mini Project - Airline Management System

## 📞 Support

For issues or questions:
1. Check XAMPP_IMPLEMENTATION_GUIDE.txt
2. Review PROJECT_DOCUMENTATION.txt
3. Verify database connection in config.php

---

**Note:** This is a demonstration project. For production use, implement:
- Password hashing (bcrypt)
- Prepared statements
- HTTPS/SSL
- Input validation
- CSRF protection
- Session security
