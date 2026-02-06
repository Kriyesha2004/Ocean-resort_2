<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <% if (session.getAttribute("user_id")==null) { response.sendRedirect("index.jsp"); return; } %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Settings - Ocean View Resort</title>
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
                            <div class="card-header bg-white border-bottom-0 pt-4 px-4 pb-0">
                                <h4 class="fw-bold"><i class="bi bi-gear-fill me-2 text-primary"></i> Application
                                    Settings</h4>
                            </div>
                            <div class="card-body p-4">

                                <div class="card-body p-4">

                                    <% String message=(String) session.getAttribute("message"); String error=(String)
                                        session.getAttribute("error"); if (message !=null) { %>
                                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                                            <%= message %>
                                                <button type="button" class="btn-close" data-bs-dismiss="alert"
                                                    aria-label="Close"></button>
                                        </div>
                                        <% session.removeAttribute("message"); } if (error !=null) { %>
                                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                                <%= error %>
                                                    <button type="button" class="btn-close" data-bs-dismiss="alert"
                                                        aria-label="Close"></button>
                                            </div>
                                            <% session.removeAttribute("error"); } %>

                                                <form action="settings" method="post" id="settingsForm">

                                                    <!-- Appearance Section -->
                                                    <div class="mb-4">
                                                        <h6 class="text-uppercase text-muted small fw-bold mb-3">
                                                            Appearance
                                                        </h6>

                                                        <div
                                                            class="d-flex align-items-center justify-content-between p-3 bg-white border rounded mb-2">
                                                            <div>
                                                                <div class="fw-bold">Dark Mode</div>
                                                                <div class="text-muted small">Reduce eye strain with a
                                                                    dark
                                                                    color theme</div>
                                                            </div>
                                                            <div class="form-check form-switch">
                                                                <input class="form-check-input" type="checkbox"
                                                                    name="darkMode" id="darkModeSwitch"
                                                                    ${sessionScope.is_dark_mode ? 'checked' : '' }>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <!-- Notifications Section -->
                                                    <div class="mb-4">
                                                        <h6 class="text-uppercase text-muted small fw-bold mb-3">
                                                            Notifications</h6>

                                                        <div
                                                            class="d-flex align-items-center justify-content-between p-3 bg-white border rounded mb-2">
                                                            <div>
                                                                <div class="fw-bold">Email Notifications</div>
                                                                <div class="text-muted small">Receive daily summary
                                                                    reports
                                                                    via email</div>
                                                            </div>
                                                            <div class="form-check form-switch">
                                                                <input class="form-check-input" type="checkbox"
                                                                    name="emailNotif" id="emailNotifSwitch"
                                                                    ${sessionScope.is_email_notif ? 'checked' : '' }>
                                                            </div>
                                                        </div>

                                                        <div
                                                            class="d-flex align-items-center justify-content-between p-3 bg-white border rounded">
                                                            <div>
                                                                <div class="fw-bold">Browser Alerts</div>
                                                                <div class="text-muted small">Show desktop notifications
                                                                    for
                                                                    new bookings</div>
                                                            </div>
                                                            <div class="form-check form-switch">
                                                                <input class="form-check-input" type="checkbox"
                                                                    name="browserNotif" id="browserNotifSwitch"
                                                                    ${sessionScope.is_browser_notif ? 'checked' : '' }>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="d-grid gap-2">
                                                        <button type="submit" class="btn btn-primary">
                                                            Save Changes
                                                        </button>
                                                        <a href="dashboard.jsp"
                                                            class="btn btn-outline-secondary">Cancel</a>
                                                    </div>

                                                </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Bootstrap JS -->
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <script>
                    function saveSettings() {
                        // In a real app, this would submit to a servlet
                        // For now, just show a visual confirmation
                        const btn = document.querySelector('button[onclick="saveSettings()"]');
                        const originalText = btn.innerHTML;

                        btn.innerHTML = '<i class="bi bi-check-circle"></i> Saved!';
                        btn.classList.replace('btn-primary', 'btn-success');

                        setTimeout(() => {
                            btn.innerHTML = originalText;
                            btn.classList.replace('btn-success', 'btn-primary');
                        }, 2000);
                    }
                </script>
        </body>

        </html>