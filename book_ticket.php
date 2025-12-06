<?php
// ============================================================================
// TICKET BOOKING MODULE
// ============================================================================
include 'config.php';

$message = '';
$error = '';

// Handle booking
if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['book_ticket'])) {
    $passenger_id = sanitize_input($_POST['passenger_id']);
    $flight_id = sanitize_input($_POST['flight_id']);
    $seat_number = sanitize_input($_POST['seat_number']);
    
    // Check if seat is already booked
    $check_seat = "SELECT * FROM bookings WHERE flight_id = $flight_id AND seat_number = '$seat_number'";
    $seat_result = mysqli_query($conn, $check_seat);
    
    if (mysqli_num_rows($seat_result) > 0) {
        $error = "Seat already booked! Please choose another seat.";
    } else {
        // Call stored procedure to book ticket
        $book_sql = "CALL book_ticket($passenger_id, $flight_id, '$seat_number')";
        $result = mysqli_query($conn, $book_sql);
        
        if ($result) {
            $data = mysqli_fetch_assoc($result);
            if (isset($data['booking_id'])) {
                $message = "Booking successful! Booking ID: " . $data['booking_id'];
            } else {
                $error = $data['message'];
            }
        } else {
            $error = "Error: " . mysqli_error($conn);
        }
        
        // Close and reopen connection after stored procedure
        mysqli_close($conn);
        $conn = mysqli_connect(DB_HOST, DB_USER, DB_PASS, DB_NAME);
        
        // Re-fetch flights after connection reset
        $flights_sql = "SELECT f.*, dep.city AS dep_city, arr.city AS arr_city 
                        FROM flights f 
                        JOIN airports dep ON f.departure_airport_id = dep.airport_id 
                        JOIN airports arr ON f.arrival_airport_id = arr.airport_id 
                        WHERE f.available_seats > 0 AND f.status = 'Scheduled'
                        ORDER BY f.departure_time";
        $flights_result = mysqli_query($conn, $flights_sql);
        
        // Re-fetch passengers after connection reset
        $passengers_sql = "SELECT * FROM passengers ORDER BY first_name";
        $passengers_result = mysqli_query($conn, $passengers_sql);
    }
}

// Fetch available flights (if not already fetched after booking)
if (!isset($flights_result)) {
    $flights_sql = "SELECT f.*, dep.city AS dep_city, arr.city AS arr_city 
                    FROM flights f 
                    JOIN airports dep ON f.departure_airport_id = dep.airport_id 
                    JOIN airports arr ON f.arrival_airport_id = arr.airport_id 
                    WHERE f.available_seats > 0 AND f.status = 'Scheduled'
                    ORDER BY f.departure_time";
    $flights_result = mysqli_query($conn, $flights_sql);
}

// Fetch passengers (if not already fetched after booking)
if (!isset($passengers_result)) {
    $passengers_sql = "SELECT * FROM passengers ORDER BY first_name";
    $passengers_result = mysqli_query($conn, $passengers_sql);
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Ticket</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; padding: 20px; }
        .container { max-width: 800px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 10px 30px rgba(0,0,0,0.2); }
        h2 { color: #333; margin-bottom: 20px; text-align: center; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; color: #555; font-weight: bold; }
        input, select { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 5px; }
        button { width: 100%; padding: 12px; background: #667eea; color: white; border: none; border-radius: 5px; font-size: 16px; cursor: pointer; margin-top: 10px; }
        button:hover { background: #5568d3; }
        .message { padding: 10px; margin-bottom: 15px; border-radius: 5px; text-align: center; }
        .success { background: #d4edda; color: #155724; }
        .error { background: #f8d7da; color: #721c24; }
        .flight-info { background: #f9f9f9; padding: 15px; border-radius: 5px; margin-bottom: 15px; }
        .links { text-align: center; margin-top: 15px; }
        .links a { color: #667eea; text-decoration: none; margin: 0 10px; }
    </style>
</head>
<body>
    <div class="container">
        <h2>Book Your Ticket</h2>
        
        <?php if ($message): ?>
            <div class="message success"><?php echo $message; ?></div>
        <?php endif; ?>
        
        <?php if ($error): ?>
            <div class="message error"><?php echo $error; ?></div>
        <?php endif; ?>
        
        <form method="POST" action="">
            <div class="form-group">
                <label>Select Passenger:</label>
                <select name="passenger_id" required>
                    <option value="">Choose Passenger</option>
                    <?php while($passenger = mysqli_fetch_assoc($passengers_result)): ?>
                        <option value="<?php echo $passenger['passenger_id']; ?>">
                            <?php echo $passenger['first_name'] . " " . $passenger['last_name'] . " (" . $passenger['email'] . ")"; ?>
                        </option>
                    <?php endwhile; ?>
                </select>
            </div>
            
            <div class="form-group">
                <label>Select Flight:</label>
                <select name="flight_id" required>
                    <option value="">Choose Flight</option>
                    <?php while($flight = mysqli_fetch_assoc($flights_result)): ?>
                        <option value="<?php echo $flight['flight_id']; ?>">
                            <?php echo $flight['flight_number'] . " - " . $flight['dep_city'] . " to " . $flight['arr_city'] . 
                                 " | " . date('d-M-Y H:i', strtotime($flight['departure_time'])) . 
                                 " | ₹" . number_format($flight['price'], 2) . 
                                 " | " . $flight['available_seats'] . " seats"; ?>
                        </option>
                    <?php endwhile; ?>
                </select>
            </div>
            
            <div class="form-group">
                <label>Seat Number:</label>
                <input type="text" name="seat_number" placeholder="e.g., 12A" required>
            </div>
            
            <button type="submit" name="book_ticket">Book Ticket</button>
        </form>
        
        <div class="links">
            <a href="index.html">Home</a> | 
            <a href="register_passenger.php">Register New Passenger</a> | 
            <a href="view_bookings.php">View Bookings</a>
        </div>
    </div>
</body>
</html>
