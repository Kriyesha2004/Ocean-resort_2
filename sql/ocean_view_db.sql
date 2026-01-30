-- Ocean View Resort Database Schema
-- Create the database
CREATE DATABASE IF NOT EXISTS ocean_view_db;
USE ocean_view_db;

-- Table for Staff Login
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100),
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- Table for Guest Reservations
CREATE TABLE reservations (
    res_id INT PRIMARY KEY AUTO_INCREMENT,
    guest_name VARCHAR(100) NOT NULL,
    address TEXT,
    contact_no VARCHAR(15),
    email VARCHAR(100),
    room_type ENUM('Single', 'Double', 'Luxury') NOT NULL,
    check_in DATE NOT NULL,
    check_out DATE NOT NULL,
    total_bill DECIMAL(10, 2),
    status ENUM('Pending', 'Confirmed', 'Checked-In', 'Checked-Out', 'Cancelled') DEFAULT 'Pending',
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(user_id) ON DELETE SET NULL
);

-- Table for Billing History
CREATE TABLE billing (
    bill_id INT PRIMARY KEY AUTO_INCREMENT,
    res_id INT NOT NULL,
    nights INT,
    room_type VARCHAR(50),
    rate_per_night DECIMAL(10, 2),
    total_bill DECIMAL(10, 2),
    payment_status ENUM('Pending', 'Paid', 'Cancelled') DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (res_id) REFERENCES reservations(res_id) ON DELETE CASCADE
);

-- Insert sample staff users
INSERT INTO users (username, password, full_name, email) VALUES 
('admin', 'admin123', 'Administrator', 'admin@oceanview.com'),
('staff1', 'staff123', 'John Smith', 'john@oceanview.com'),
('staff2', 'staff123', 'Sarah Johnson', 'sarah@oceanview.com');

-- Create indexes for better query performance
CREATE INDEX idx_username ON users(username);
CREATE INDEX idx_guest_name ON reservations(guest_name);
CREATE INDEX idx_check_in ON reservations(check_in);
CREATE INDEX idx_check_out ON reservations(check_out);
CREATE INDEX idx_status ON reservations(status);
