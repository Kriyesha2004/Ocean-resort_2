<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("user_id") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>New Reservation - Ocean View Resort</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%@ include file="navbar.jsp" %>
    
    <div class="container py-4">
        <div class="row">
            <div class="col-md-8 offset-md-2">
                <div class="card shadow-sm border-0">
                    <div class="card-header bg-primary text-white">
                        <h5 class="card-title mb-0">Create New Reservation</h5>
                    </div>
                    
                    <div class="card-body">
                        <% 
                            String error = (String) request.getAttribute("error");
                            if (error != null && !error.isEmpty()) {
                        %>
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <%= error %>
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <% } %>
                        
                        <form action="reservation" method="POST" name="reservationForm" onsubmit="return validateReservationForm()">
                            <input type="hidden" name="action" value="create">
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="guest_name" class="form-label">Guest Name <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="guest_name" name="guest_name" 
                                           placeholder="Full name" required>
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label for="contact_no" class="form-label">Contact Number <span class="text-danger">*</span></label>
                                    <input type="tel" class="form-control" id="contact_no" name="contact_no" 
                                           placeholder="Phone number" pattern="[0-9\-\+\s\(\)]+" required>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="email" class="form-label">Email Address</label>
                                <input type="email" class="form-control" id="email" name="email" 
                                       placeholder="Email address">
                            </div>
                            
                            <div class="mb-3">
                                <label for="address" class="form-label">Address</label>
                                <textarea class="form-control" id="address" name="address" rows="3" 
                                         placeholder="Guest address"></textarea>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="room_type" class="form-label">Room Type <span class="text-danger">*</span></label>
                                    <select class="form-select" id="room_type" name="room_type" required onchange="updateRateDisplay()">
                                        <option value="">-- Select Room Type --</option>
                                        <option value="Single">Single Room ($5,000/night)</option>
                                        <option value="Double">Double Room ($8,500/night)</option>
                                        <option value="Luxury">Luxury Suite ($15,000/night)</option>
                                    </select>
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Rate Per Night</label>
                                    <div class="form-control bg-light" id="rate_display">
                                        Select a room type
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="check_in" class="form-label">Check-In Date <span class="text-danger">*</span></label>
                                    <input type="date" class="form-control" id="check_in" name="check_in" 
                                           required onchange="calculateBill()">
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label for="check_out" class="form-label">Check-Out Date <span class="text-danger">*</span></label>
                                    <input type="date" class="form-control" id="check_out" name="check_out" 
                                           required onchange="calculateBill()">
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Number of Nights</label>
                                    <div class="form-control bg-light" id="nights_display">
                                        0 nights
                                    </div>
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Total Bill</label>
                                    <div class="form-control bg-light border-primary" id="bill_display" style="font-weight: bold; font-size: 1.2rem;">
                                        $0.00
                                    </div>
                                </div>
                            </div>
                            
                            <div class="mt-4 d-flex gap-2">
                                <button type="submit" class="btn btn-primary btn-lg">
                                    <i class="bi bi-check-circle"></i> Create Reservation
                                </button>
                                <a href="dashboard.jsp" class="btn btn-secondary btn-lg">
                                    <i class="bi bi-x-circle"></i> Cancel
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/reservation.js"></script>
</body>
</html>
