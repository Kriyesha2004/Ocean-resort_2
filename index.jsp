<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Ocean View Resort - Login</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="css/style.css">
    </head>

    <body class="login-page">
        <div class="container d-flex justify-content-center align-items-center min-vh-100 py-5">
            <div class="col-12 col-md-8 col-lg-5">
                <div class="card shadow-lg border-0 login-card">
                    <div class="card-body p-5">
                        <div class="text-center mb-4">
                            <h1 class="text-primary display-5">🏨</h1>
                            <h2 class="text-primary">Ocean View Resort</h2>
                            <p class="text-muted">Management System</p>
                        </div>

                        <% String error=(String) request.getAttribute("error"); if (error !=null && !error.isEmpty()) {
                            %>
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <%= error %>
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"
                                        aria-label="Close"></button>
                            </div>
                            <% } %>

                                <form action="login" method="POST" name="loginForm"
                                    onsubmit="return validateLoginForm()">
                                    <div class="mb-3">
                                        <label for="username" class="form-label">Username</label>
                                        <input type="text" class="form-control form-control-lg" id="username"
                                            name="username" placeholder="Enter your username" required>
                                        <small class="form-text text-muted">Default: admin</small>
                                    </div>

                                    <div class="mb-4">
                                        <label for="password" class="form-label">Password</label>
                                        <input type="password" class="form-control form-control-lg" id="password"
                                            name="password" placeholder="Enter your password" required>
                                        <small class="form-text text-muted">Default: admin123</small>
                                    </div>

                                    <button type="submit" class="btn btn-primary btn-lg w-100 mb-3">
                                        <i class="bi bi-box-arrow-in-right"></i> Login
                                    </button>
                                </form>

                                <hr>
                                <div class="alert alert-info alert-sm" role="alert">
                                    <strong>Demo Credentials:</strong>
                                    <br>Username: <code>admin</code>
                                    <br>Password: <code>admin123</code>
                                </div>
                    </div>
                </div>

                <p class="text-center text-muted mt-4">
                    © 2026 Ocean View Resort. All rights reserved.
                </p>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="js/validation.js"></script>
    </body>

    </html>