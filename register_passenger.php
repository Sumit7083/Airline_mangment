<?php
// ============================================================================
// PASSENGER REGISTRATION
// ============================================================================
include 'config.php';

$message = '';
$error = '';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Sanitize inputs
    $first_name = sanitize_input($_POST['first_name']);
    $last_name = sanitize_input($_POST['last_name']);
    $email = sanitize_input($_POST['email']);
    $phone = sanitize_input($_POST['phone']);
    $passport_number = sanitize_input($_POST['passport_number']);
    $date_of_birth = sanitize_input($_POST['date_of_birth']);
    $nationality = sanitize_input($_POST['nationality']);
    
    // Validate inputs
    if (empty($first_name) || empty($last_name) || empty($email) || empty($phone) || 
        empty($passport_number) || empty($date_of_birth) || empty($nationality)) {
        $error = "All fields are required!";
    } elseif (!validate_email($email)) {
        $error = "Invalid email format!";
    } elseif (!validate_phone($phone)) {
        $error = "Invalid phone number!";
    } else {
        // Check if email or passport already exists
        $check_sql = "SELECT * FROM passengers WHERE email = '$email' OR passport_number = '$passport_number'";
        $check_result = mysqli_query($conn, $check_sql);
        
        if (mysqli_num_rows($check_result) > 0) {
            $error = "Email or Passport number already registered!";
        } else {
            // Insert passenger
            $sql = "INSERT INTO passengers (first_name, last_name, email, phone, passport_number, date_of_birth, nationality) 
                    VALUES ('$first_name', '$last_name', '$email', '$phone', '$passport_number', '$date_of_birth', '$nationality')";
            
            if (mysqli_query($conn, $sql)) {
                $message = "Registration successful! Passenger ID: " . mysqli_insert_id($conn);
            } else {
                $error = "Error: " . mysqli_error($conn);
            }
        }
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Passenger Registration</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; padding: 20px; }
        .container { max-width: 600px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 10px 30px rgba(0,0,0,0.2); }
        h2 { color: #333; margin-bottom: 20px; text-align: center; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; color: #555; font-weight: bold; }
        input, select { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 5px; font-size: 14px; }
        input:focus, select:focus { outline: none; border-color: #667eea; }
        button { width: 100%; padding: 12px; background: #667eea; color: white; border: none; border-radius: 5px; font-size: 16px; cursor: pointer; margin-top: 10px; }
        button:hover { background: #5568d3; }
        .message { padding: 10px; margin-bottom: 15px; border-radius: 5px; text-align: center; }
        .success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .links { text-align: center; margin-top: 15px; }
        .links a { color: #667eea; text-decoration: none; }
        .links a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="container">
        <h2>Passenger Registration</h2>
        
        <?php if ($message): ?>
            <div class="message success"><?php echo $message; ?></div>
        <?php endif; ?>
        
        <?php if ($error): ?>
            <div class="message error"><?php echo $error; ?></div>
        <?php endif; ?>
        
        <form method="POST" action="">
            <div class="form-group">
                <label>First Name:</label>
                <input type="text" name="first_name" required>
            </div>
            
            <div class="form-group">
                <label>Last Name:</label>
                <input type="text" name="last_name" required>
            </div>
            
            <div class="form-group">
                <label>Email:</label>
                <input type="email" name="email" required>
            </div>
            
            <div class="form-group">
                <label>Phone:</label>
                <input type="text" name="phone" placeholder="+91-9876543210" required>
            </div>
            
            <div class="form-group">
                <label>Passport Number:</label>
                <input type="text" name="passport_number" required>
            </div>
            
            <div class="form-group">
                <label>Date of Birth:</label>
                <input type="date" name="date_of_birth" required>
            </div>
            
            <div class="form-group">
                <label>Nationality:</label>
                <input type="text" name="nationality" required>
            </div>
            
            <button type="submit">Register</button>
        </form>
        
        <div class="links">
            <a href="index.html">Back to Home</a> | 
            <a href="book_ticket.php">Book Ticket</a>
        </div>
    </div>
</body>
</html>
