/**
 * Reservation Form Script
 * Handles dynamic calculation and validation for reservation form
 */

const ROOM_RATES = {
    'Single': 5000.00,
    'Double': 8500.00,
    'Luxury': 15000.00
};

/**
 * Update the displayed rate when room type changes
 */
function updateRateDisplay() {
    const roomType = document.getElementById('room_type').value;
    const rateDisplay = document.getElementById('rate_display');
    
    if (roomType && ROOM_RATES[roomType]) {
        rateDisplay.textContent = '$' + ROOM_RATES[roomType].toLocaleString('en-US', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        }) + ' per night';
    } else {
        rateDisplay.textContent = 'Select a room type';
    }
    
    calculateBill();
}

/**
 * Calculate number of nights between check-in and check-out
 */
function calculateNights() {
    const checkInInput = document.getElementById('check_in').value;
    const checkOutInput = document.getElementById('check_out').value;
    
    if (!checkInInput || !checkOutInput) return 0;
    
    const checkInDate = new Date(checkInInput);
    const checkOutDate = new Date(checkOutInput);
    
    const timeDiff = checkOutDate - checkInDate;
    const nights = Math.ceil(timeDiff / (1000 * 60 * 60 * 24));
    
    return nights > 0 ? nights : 0;
}

/**
 * Calculate and display total bill
 */
function calculateBill() {
    const roomType = document.getElementById('room_type').value;
    const nights = calculateNights();
    const billDisplay = document.getElementById('bill_display');
    const nightsDisplay = document.getElementById('nights_display');
    
    // Update nights display
    nightsDisplay.textContent = nights + (nights === 1 ? ' night' : ' nights');
    
    if (roomType && nights > 0 && ROOM_RATES[roomType]) {
        const rate = ROOM_RATES[roomType];
        const totalBill = nights * rate;
        
        billDisplay.textContent = '$' + totalBill.toLocaleString('en-US', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        });
        
        // Change color based on amount
        if (totalBill > 50000) {
            billDisplay.style.color = '#d63031';
        } else if (totalBill > 30000) {
            billDisplay.style.color = '#f39c12';
        } else {
            billDisplay.style.color = '#27ae60';
        }
    } else {
        billDisplay.textContent = '$0.00';
        billDisplay.style.color = '#555';
    }
}

/**
 * Validate check-out date is after check-in
 */
function validateCheckInDate() {
    const checkInInput = document.getElementById('check_in');
    const checkOutInput = document.getElementById('check_out');
    
    if (checkInInput.value) {
        // Set minimum date for checkout to today or check-in date
        checkOutInput.setAttribute('min', checkInInput.value);
        
        // If checkout is already set and is earlier than check-in, clear it
        if (checkOutInput.value && new Date(checkOutInput.value) <= new Date(checkInInput.value)) {
            checkOutInput.value = '';
        }
    }
    
    calculateBill();
}

/**
 * Initialize form with default values
 */
document.addEventListener('DOMContentLoaded', function() {
    const checkInInput = document.getElementById('check_in');
    const checkOutInput = document.getElementById('check_out');
    
    if (checkInInput) {
        // Set minimum date to today
        const today = new Date().toISOString().split('T')[0];
        checkInInput.setAttribute('min', today);
        
        // Attach event listener
        checkInInput.addEventListener('change', validateCheckInDate);
    }
    
    if (checkOutInput) {
        checkOutInput.addEventListener('change', calculateBill);
    }
    
    // Attach event listener for room type
    const roomTypeSelect = document.getElementById('room_type');
    if (roomTypeSelect) {
        roomTypeSelect.addEventListener('change', updateRateDisplay);
    }
    
    // Set focus on guest name field
    const guestNameInput = document.getElementById('guest_name');
    if (guestNameInput) {
        guestNameInput.focus();
    }
});
