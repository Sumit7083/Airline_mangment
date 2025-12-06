<?php
// ============================================================================
// FLIGHT MANAGEMENT (CRUD)
// ============================================================================
session_start();
include 'config.php';

// Check if admin is logged in
if (!isset($_SESSION['admin_id'])) {
    header("Location: admin_login.php");
    exit();
}

$message = '';
$error = '';

// Handle flight creation
if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['add_flight'])) {
    $flight_number = sanitize_input($_POST['flight_number']);
    $aircraft_id = sanitize_input($_POST['aircraft_id']);
    $departure_airport_id = sanitize_input($_POST['departure_airport_id']);
    $arrival_airport_id = sanitize_input($_POST['arrival_airport_id']);
    $departure_time = sanitize_input($_POST['departure_time']);
    $arrival_time = sanitize_input($_POST['arrival_time']);
    $price = sanitize_input($_POST['price']);
    
    // Get aircraft total seats
    $aircraft_query = "SELECT total_seats FROM aircraft WHERE aircraft_id = $aircraft_id";
    $aircraft_result = mysqli_query($conn, $aircraft_query);
    $aircraft_data = mysqli_fetch_assoc($aircraft_result);
    $available_seats = $aircraft_data['total_seats'];
    
    $sql = "INSERT INTO flights (flight_number, aircraft_id, departure_airport_id, arrival_airport_id, 
            departure_time, arrival_time, available_seats, price, status) 
            VALUES ('$flight_number', $aircraft_id, $departure_airport_id, $arrival_airport_id, 
            '$departure_time', '$arrival_time', $available_seats, $price, 'Scheduled')";
    
    if (mysqli_query($conn, $sql)) {
        $message = "Flight added successfully!";
    } else {
        $error = "Error: " . mysqli_error($conn);
    }
}

// Handle flight deletion
if (isset($_GET['delete'])) {
    $flight_id = intval($_GET['delete']);
    $delete_sql = "DELETE FROM flights WHERE flight_id = $flight_id";
    if (mysqli_query($conn, $delete_sql)) {
        $message = "Flight deleted successfully!";
    } else {
        $error = "Error deleting flight: " . mysqli_error($conn);
    }
}

// Fetch all flights
$flights_sql = "SELECT f.*, a.model, dep.airport_name AS dep_airport, arr.airport_name AS arr_airport 
                FROM flights f 
                JOIN aircraft a ON f.aircraft_id = a.aircraft_id 
                JOIN airports dep ON f.departure_airport_id = dep.airport_id 
                JOIN airports arr ON f.arrival_airport_id = arr.airport_id 
                ORDER BY f.departure_time DESC";
$flights_result = mysqli_query($conn, $flights_sql);

// Fetch aircraft for dropdown
$aircraft_sql = "SELECT * FROM aircraft WHERE status = 'Active'";
$aircraft_result = mysqli_query($conn, $aircraft_sql);

// Fetch airports for dropdown
$airports_sql = "SELECT * FROM airports ORDER BY city";
$airports_result = mysqli_query($conn, $airports_sql);
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Flights</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #f4f4f4; padding: 20px; }
        .container { max-width: 1200px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); }
        h2 { color: #333; margin-bottom: 20px; }
        .form-section { background: #f9f9f9; padding: 20px; border-radius: 5px; margin-bottom: 30px; }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; margin-bottom: 15px; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; color: #555; font-weight: bold; }
        input, select { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 5px; }
        button { padding: 10px 20px; background: #667eea; color: white; border: none; border-radius: 5px; cursor: pointer; }
        button:hover { background: #5568d3; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #667eea; color: white; }
        tr:hover { background: #f5f5f5; }
        .actions a { color: #dc3545; text-decoration: none; margin-left: 10px; }
        .actions a:hover { text-decoration: underline; }
        .message { padding: 10px; margin-bottom: 15px; border-radius: 5px; }
        .success { background: #d4edda; color: #155724; }
        .error { background: #f8d7da; color: #721c24; }
        .logout { float: right; }
    </style>
</head>
<body>
    <div class="container">
        <h2>Flight Management <a href="logout.php" class="logout" style="font-size: 14px;">Logout</a></h2>
        
        <?php if ($message): ?>
            <div class="message success"><?php echo $message; ?></div>
        <?php endif; ?>
        
        <?php if ($error): ?>
            <div class="message error"><?php echo $error; ?></div>
        <?php endif; ?>
        
        <div class="form-section">
            <h3>Add New Flight</h3>
            <form method="POST" action="">
                <div class="form-row">
                    <div class="form-group">
                        <label>Flight Number:</label>
                        <input type="text" name="flight_number" required>
                    </div>
                    <div class="form-group">
                        <label>Aircraft:</label>
                        <select name="aircraft_id" required>
                            <option value="">Select Aircraft</option>
                            <?php while($aircraft = mysqli_fetch_assoc($aircraft_result)): ?>
                                <option value="<?php echo $aircraft['aircraft_id']; ?>">
                                    <?php echo $aircraft['model'] . " (" . $aircraft['total_seats'] . " seats)"; ?>
                                </option>
                            <?php endwhile; ?>
                        </select>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label>Departure Airport:</label>
                        <select name="departure_airport_id" required>
                            <option value="">Select Airport</option>
                            <?php 
                            mysqli_data_seek($airports_result, 0);
                            while($airport = mysqli_fetch_assoc($airports_result)): ?>
                                <option value="<?php echo $airport['airport_id']; ?>">
                                    <?php echo $airport['airport_code'] . " - " . $airport['city']; ?>
                                </option>
                            <?php endwhile; ?>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Arrival Airport:</label>
                        <select name="arrival_airport_id" required>
                            <option value="">Select Airport</option>
                            <?php 
                            mysqli_data_seek($airports_result, 0);
                            while($airport = mysqli_fetch_assoc($airports_result)): ?>
                                <option value="<?php echo $airport['airport_id']; ?>">
                                    <?php echo $airport['airport_code'] . " - " . $airport['city']; ?>
                                </option>
                            <?php endwhile; ?>
                        </select>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label>Departure Time:</label>
                        <input type="datetime-local" name="departure_time" required>
                    </div>
                    <div class="form-group">
                        <label>Arrival Time:</label>
                        <input type="datetime-local" name="arrival_time" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label>Price (₹):</label>
                    <input type="number" name="price" step="0.01" required>
                </div>
                
                <button type="submit" name="add_flight">Add Flight</button>
            </form>
        </div>
        
        <h3>All Flights</h3>
        <table>
            <thead>
                <tr>
                    <th>Flight No.</th>
                    <th>Aircraft</th>
                    <th>Route</th>
                    <th>Departure</th>
                    <th>Arrival</th>
                    <th>Available Seats</th>
                    <th>Price</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <?php while($flight = mysqli_fetch_assoc($flights_result)): ?>
                <tr>
                    <td><?php echo $flight['flight_number']; ?></td>
                    <td><?php echo $flight['model']; ?></td>
                    <td><?php echo $flight['dep_airport'] . " → " . $flight['arr_airport']; ?></td>
                    <td><?php echo date('d-M-Y H:i', strtotime($flight['departure_time'])); ?></td>
                    <td><?php echo date('d-M-Y H:i', strtotime($flight['arrival_time'])); ?></td>
                    <td><?php echo $flight['available_seats']; ?></td>
                    <td>₹<?php echo number_format($flight['price'], 2); ?></td>
                    <td><?php echo $flight['status']; ?></td>
                    <td class="actions">
                        <a href="?delete=<?php echo $flight['flight_id']; ?>" 
                           onclick="return confirm('Are you sure you want to delete this flight?')">Delete</a>
                    </td>
                </tr>
                <?php endwhile; ?>
            </tbody>
        </table>
    </div>
</body>
</html>
