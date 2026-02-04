<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <% if (session.getAttribute("user_id")==null) { response.sendRedirect("index.jsp"); return; } %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>My Profile - Ocean View Resort</title>
            <!-- Bootstrap CSS -->
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <!-- Bootstrap Icons -->
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
            <!-- Custom CSS -->
            <link rel="stylesheet" href="css/style.css">
        </head>

        <body class="bg-light">

            <!-- Navigation -->
            <jsp:include page="navbar.jsp" />

            <div class="container mt-5">
                <div class="row justify-content-center">
                    <div class="col-md-8 col-lg-6">
                        <div class="card shadow-sm border-0 rounded-3">
                            <div class="card-body p-5 text-center">
                                <div class="mb-4">
                                    <div class="bg-primary bg-opacity-10 text-primary rounded-circle d-inline-flex align-items-center justify-content-center"
                                        style="width: 100px; height: 100px;">
                                        <i class="bi bi-person-fill display-4"></i>
                                    </div>
                                </div>

                                <h2 class="fw-bold mb-1">
                                    <%= session.getAttribute("full_name") %>
                                </h2>
                                <p class="text-muted mb-4">@<%= session.getAttribute("username") %>
                                </p>

                                <div class="text-start bg-white p-4 rounded border">
                                    <h5 class="mb-3 border-bottom pb-2">User Details</h5>

                                    <div class="row mb-3">
                                        <div class="col-sm-4 text-secondary">Full Name</div>
                                        <div class="col-sm-8 fw-bold">
                                            <%= session.getAttribute("full_name") %>
                                        </div>
                                    </div>

                                    <div class="row mb-3">
                                        <div class="col-sm-4 text-secondary">Username</div>
                                        <div class="col-sm-8 fw-bold">
                                            <%= session.getAttribute("username") %>
                                        </div>
                                    </div>

                                    <div class="row mb-3">
                                        <div class="col-sm-4 text-secondary">Role</div>
                                        <div class="col-sm-8 fw-bold"><span
                                                class="badge bg-success">Administrator</span></div>
                                    </div>

                                    <div class="row">
                                        <div class="col-sm-4 text-secondary">Email</div>
                                        <div class="col-sm-8 fw-bold">admin@oceanview.com <span
                                                class="text-muted fw-normal small">(derived)</span></div>
                                    </div>
                                </div>

                                <div class="mt-4">
                                    <a href="settings.jsp" class="btn btn-outline-primary px-4 me-2">Edit Settings</a>
                                    <a href="dashboard.jsp" class="btn btn-secondary px-4">Back to Dashboard</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Bootstrap JS -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>