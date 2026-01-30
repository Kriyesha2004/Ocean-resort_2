<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Book Your Stay - Ocean View Resort</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="css/style.css">
    </head>

    <body class="bg-light">

        <jsp:include page="public-navbar.jsp" />

        <div class="container py-5">
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <!-- Progress/Header -->
                    <div class="text-center mb-5">
                        <h2 class="display-5 fw-bold font-playfair">Complete Your Reservation</h2>
                        <p class="text-muted">You are just one step away from your perfect vacation</p>
                    </div>

                    <div class="card shadow border-0 rounded-3">
                        <div class="card-header bg-primary text-white p-4">
                            <h4 class="mb-0"><i class="bi bi-calendar-check me-2"></i> Booking Details</h4>
                        </div>

                        <div class="card-body p-4">
                            <% String error=(String) request.getAttribute("error"); if (error !=null &&
                                !error.isEmpty()) { %>
                                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    <i class="bi bi-exclamation-triangle-fill me-2"></i>
                                    <%= error %>
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                                <% } %>

                                    <form action="reservation" method="POST" name="reservationForm"
                                        onsubmit="return validateReservationForm()">
                                        <input type="hidden" name="action" value="public_booking">

                                        <!-- Guest Information -->
                                        <h5 class="text-primary mb-3 border-bottom pb-2">Guest Information</h5>
                                        <div class="row g-3 mb-4">
                                            <div class="col-md-6">
                                                <label for="guest_name" class="form-label">Full Name <span
                                                        class="text-danger">*</span></label>
                                                <input type="text" class="form-control" id="guest_name"
                                                    name="guest_name" required>
                                            </div>
                                            <div class="col-md-6">
                                                <label for="contact_no" class="form-label">Phone Number <span
                                                        class="text-danger">*</span></label>
                                                <input type="tel" class="form-control" id="contact_no" name="contact_no"
                                                    required>
                                            </div>
                                            <div class="col-12">
                                                <label for="email" class="form-label">Email Address <span
                                                        class="text-danger">*</span></label>
                                                <input type="email" class="form-control" id="email" name="email"
                                                    required>
                                                <div class="form-text">We'll send your booking confirmation to this
                                                    email.</div>
                                            </div>
                                            <div class="col-12">
                                                <label for="address" class="form-label">Address</label>
                                                <textarea class="form-control" id="address" name="address"
                                                    rows="2"></textarea>
                                            </div>
                                        </div>

                                        <!-- Stay Details -->
                                        <h5 class="text-primary mb-3 border-bottom pb-2 pt-2">Stay Details</h5>
                                        <div class="row g-3 mb-4">
                                            <div class="col-md-6">
                                                <label for="room_type" class="form-label">Room Type <span
                                                        class="text-danger">*</span></label>
                                                <select class="form-select" id="room_type" name="room_type" required
                                                    onchange="updateRateDisplay()">
                                                    <option value="">-- Select Room --</option>
                                                    <option value="Single" <%="Single"
                                                        .equals(request.getParameter("room_type")) ? "selected" : "" %>
                                                        >Single Room ($5,000/night)</option>
                                                    <option value="Double" <%="Double"
                                                        .equals(request.getParameter("room_type")) ? "selected" : "" %>
                                                        >Double Room ($8,500/night)</option>
                                                    <option value="Luxury" <%="Luxury"
                                                        .equals(request.getParameter("room_type")) ? "selected" : "" %>
                                                        >Luxury Suite ($15,000/night)</option>
                                                </select>
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label">Rate Per Night</label>
                                                <div class="form-control bg-light" id="rate_display">Select a room</div>
                                            </div>
                                            <div class="col-md-6">
                                                <label for="check_in" class="form-label">Check-In Date <span
                                                        class="text-danger">*</span></label>
                                                <input type="date" class="form-control" id="check_in" name="check_in"
                                                    required onchange="calculateBill()">
                                            </div>
                                            <div class="col-md-6">
                                                <label for="check_out" class="form-label">Check-Out Date <span
                                                        class="text-danger">*</span></label>
                                                <input type="date" class="form-control" id="check_out" name="check_out"
                                                    required onchange="calculateBill()">
                                            </div>
                                        </div>

                                        <!-- Summary -->
                                        <div class="card bg-light border-0 mb-4">
                                            <div class="card-body">
                                                <div class="d-flex justify-content-between align-items-center mb-2">
                                                    <span>Total Nights:</span>
                                                    <span id="nights_display" class="fw-bold">0</span>
                                                </div>
                                                <div
                                                    class="d-flex justify-content-between align-items-center border-top pt-2 mt-2">
                                                    <span class="h5 mb-0">Total Price:</span>
                                                    <span id="bill_display" class="h4 text-primary mb-0">$0.00</span>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="d-grid gap-2">
                                            <button type="submit" class="btn btn-primary btn-lg py-3 fw-bold shadow-sm">
                                                Confirm Booking
                                            </button>
                                            <a href="home.jsp" class="btn btn-outline-secondary">Cancel</a>
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