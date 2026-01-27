/**
 * Validation Script for Ocean View Resort
 * Handles client-side form validation
 */

/**
 * Validate Login Form
 */
function validateLoginForm() {
    const username = document.getElementById('username').value.trim();
    const password = document.getElementById('password').value.trim();
    
    if (!username) {
        alert('Please enter your username.');
        document.getElementById('username').focus();
        return false;
    }
    
    if (!password) {
        alert('Please enter your password.');
        document.getElementById('password').focus();
        return false;
    }
    
    if (password.length < 3) {
        alert('Password must be at least 3 characters long.');
        document.getElementById('password').focus();
        return false;
    }
    
    return true;
}

/**
 * Validate Reservation Form
 */
function validateReservationForm() {
    const guestName = document.getElementById('guest_name').value.trim();
    const roomType = document.getElementById('room_type').value.trim();
    const checkIn = document.getElementById('check_in').value.trim();
    const checkOut = document.getElementById('check_out').value.trim();
    const contactNo = document.getElementById('contact_no').value.trim();
    
    if (!guestName) {
        alert('Please enter guest name.');
        document.getElementById('guest_name').focus();
        return false;
    }
    
    if (!roomType) {
        alert('Please select a room type.');
        document.getElementById('room_type').focus();
        return false;
    }
    
    if (!checkIn) {
        alert('Please select check-in date.');
        document.getElementById('check_in').focus();
        return false;
    }
    
    if (!checkOut) {
        alert('Please select check-out date.');
        document.getElementById('check_out').focus();
        return false;
    }
    
    if (!contactNo) {
        alert('Please enter contact number.');
        document.getElementById('contact_no').focus();
        return false;
    }
    
    // Validate date format and logic
    const checkInDate = new Date(checkIn);
    const checkOutDate = new Date(checkOut);
    
    if (checkOutDate <= checkInDate) {
        alert('Check-out date must be after check-in date.');
        document.getElementById('check_out').focus();
        return false;
    }
    
    // Validate contact number format
    const phoneRegex = /^[0-9\-\+\s\(\)]+$/;
    if (!phoneRegex.test(contactNo)) {
        alert('Please enter a valid contact number.');
        document.getElementById('contact_no').focus();
        return false;
    }
    
    return true;
}

/**
 * Prevent users from picking past dates
 */
document.addEventListener('DOMContentLoaded', function() {
    const checkInInput = document.getElementById('check_in');
    const checkOutInput = document.getElementById('check_out');
    
    if (checkInInput) {
        // Set minimum date to today
        const today = new Date().toISOString().split('T')[0];
        checkInInput.setAttribute('min', today);
    }
});

/**
 * Validate that check-out is not before check-in
 */
function validateCheckOutDate() {
    const checkInInput = document.getElementById('check_in');
    const checkOutInput = document.getElementById('check_out');
    
    if (checkInInput && checkInInput.value) {
        checkOutInput.setAttribute('min', checkInInput.value);
        
        if (checkOutInput.value && new Date(checkOutInput.value) <= new Date(checkInInput.value)) {
            checkOutInput.value = '';
            alert('Check-out date must be after check-in date.');
        }
    }
}
