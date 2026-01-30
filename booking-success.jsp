<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Booking Confirmed - Ocean View Resort</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
        <style>
            .success-card {
                border-top: 5px solid #198754;
            }
        </style>
    </head>

    <body class="bg-light">

        <jsp:include page="public-navbar.jsp" />

        <div class="container py-5">
            <div class="row justify-content-center">
                <div class="col-md-8 col-lg-6">
                    <div class="card shadow-lg border-0 success-card">
                        <div class="card-body text-center p-5">
                            <div class="mb-4">
                                <i class="bi bi-check-circle-fill text-success" style="font-size: 5rem;"></i>
                            </div>
                            <h2 class="mb-3 fw-bold text-success">Booking Confirmed!</h2>
                            <p class="lead text-muted mb-4">Thank you for choosing Ocean View Resort. Your reservation
                                has been successfully created.</p>

                            <div class="alert alert-light border">
                                <div class="row text-start">
                                    <div class="col-6 mb-2 text-muted">Reservation ID:</div>
                                    <div class="col-6 mb-2 fw-bold text-end">#<%= request.getAttribute("reservationId")
                                            %>
                                    </div>

                                    <div class="col-6 mb-2 text-muted">Total Amount:</div>
                                    <div class="col-6 mb-2 fw-bold text-end">$<%= request.getAttribute("totalBill") %>
                                    </div>

                                    <div class="col-6 text-muted">Payment Status:</div>
                                    <div class="col-6 fw-bold text-end text-warning">Pending Payment</div>
                                </div>
                            </div>

                            <p class="small text-muted mb-4">A confirmation email has been sent to your address.</p>

                            <div class="d-grid gap-2">
                                <a href="home.jsp" class="btn btn-primary btn-lg">Return to Home</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>

    </html>