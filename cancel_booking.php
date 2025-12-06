<?php
// ============================================================================
// BOOKING CANCELLATION
// ============================================================================
include 'config.php';

$message = '';
$error = '';

// Handle cancellation
if (isset($_GET['cancel'])) {
    $booking_id = intval($_GET['cancel']);
    
    // Call stored procedure
    $cancel_sql = "CALL cancel_booking($booking_id)";
    $result = mysqli_query($conn, $cancel_sql);
    
    if ($result) {
        $data = mysqli_fetch_assoc($result);
        $message = $data['message'];
    } else {
        $error = "Error: " . mysqli_error($conn);
    }
    
    // Reconnect after stored procedure
    mysqli_close($conn);
    $conn = mysqli_connect(DB_HOST, DB_USER, DB_PASS, DB_NAME);
}

// Fetch all bookings
$bookings_sql = "SELECT b.*, p.first_name, p.last_name, p.email, f.flight_number, 
                 dep.city AS dep_city, arr.city AS arr_city, f.departure_time, t.ticket_number, t.price
                 FROM bookings b
                 JOIN passengers p ON b.passenger_id = p.passenger_id
                 JOIN flights f ON b.flight_id = f.flight_id
                 JOIN airports dep ON f.departure_airport_id = dep.airport_id
                 JOIN airports arr ON f.arrival_airport_id = arr.airport_id
                 LEFT JOIN tickets t ON b.booking_id = t.booking_id
                 ORDER BY b.booking_date DESC";
$bookings_result = mysqli_query($conn, $bookings_sql);
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View & Cancel Bookings</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #f4f4f4; padding: 20px; }
        .container { max-width: 1200px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); }
        h2 { color: #333; margin-bottom: 20px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; font-size: 14px; }
        th { background: #667eea; color: white; }
        tr:hover { background: #f5f5f5; }
        .status-confirmed { color: #28a745; font-weight: bold; }
        .status-cancelled { color: #dc3545; font-weight: bold; }
        .cancel-btn { background: #dc3545; color: white; padding: 5px 10px; border: none; border-radius: 3px; cursor: pointer; text-decoration: none; display: inline-block; }
        .cancel-btn:hover { background: #c82333; }
        .message { padding: 10px; margin-bottom: 15px; border-radius: 5px; text-align: center; }
        .success { background: #d4edda; color: #155724; }
        .error { background: #f8d7da; color: #721c24; }
        .links { text-align: center; margin-top: 20px; }
        .links a { color: #667eea; text-decoration: none; margin: 0 10px; }
    </style>
</head>
<body>
    <div class="container">
        <h2>All Bookings</h2>
        
        <?php if ($message): ?>
            <div class="message success"><?php echo $message; ?></div>
        <?php endif; ?>
        
        <?php if ($error): ?>
            <div class="message error"><?php echo $error; ?></div>
        <?php endif; ?>
        
        <table>
            <thead>
                <tr>
                    <th>Booking ID</th>
                    <th>Passenger</th>
                    <th>Email</th>
                    <th>Flight</th>
                    <th>Route</th>
                    <th>Departure</th>
                    <th>Seat</th>
                    <th>Ticket No.</th>
                    <th>Price</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <?php while($booking = mysqli_fetch_assoc($bookings_result)): ?>
                <tr>
                    <td><?php echo $booking['booking_id']; ?></td>
                    <td><?php echo $booking['first_name'] . " " . $booking['last_name']; ?></td>
                    <td><?php echo $booking['email']; ?></td>
                    <td><?php echo $booking['flight_number']; ?></td>
                    <td><?php echo $booking['dep_city'] . " → " . $booking['arr_city']; ?></td>
                    <td><?php echo date('d-M-Y H:i', strtotime($booking['departure_time'])); ?></td>
                    <td><?php echo $booking['seat_number']; ?></td>
                    <td><?php echo $booking['ticket_number']; ?></td>
                    <td>₹<?php echo number_format($booking['price'], 2); ?></td>
                    <td class="<?php echo 'status-' . strtolower($booking['booking_status']); ?>">
                        <?php echo $booking['booking_status']; ?>
                    </td>
                    <td>
                        <?php if ($booking['booking_status'] == 'Confirmed'): ?>
                            <a href="?cancel=<?php echo $booking['booking_id']; ?>" 
                               class="cancel-btn"
                               onclick="return confirm('Are you sure you want to cancel this booking?')">Cancel</a>
                        <?php else: ?>
                            -
                        <?php endif; ?>
                    </td>
                </tr>
                <?php endwhile; ?>
            </tbody>
        </table>
        
        <div class="links">
            <a href="index.html">Home</a> | 
            <a href="book_ticket.php">Book New Ticket</a> | 
            <a href="register_passenger.php">Register Passenger</a>
        </div>
    </div>
</body>
</html>
