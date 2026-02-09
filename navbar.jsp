<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <% if (session.getAttribute("user_id")==null) { response.sendRedirect("index.jsp"); return; } %>
        <nav class="navbar navbar-expand-lg navbar-dark navbar-custom sticky-top">
            <div class="container-fluid">
                <a class="navbar-brand fw-bold fs-3" href="dashboard.jsp">
                    <i class="bi bi-tsunami"></i> Ocean View
                </a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav ms-auto align-items-center">
                        <li class="nav-item">
                            <a class="nav-link active" aria-current="page" href="dashboard.jsp">
                                <i class="bi bi-grid mb-1 d-block d-lg-none"></i> Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="reservation.jsp">
                                New Reservation
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="reservations-list.jsp">
                                Reservations
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="reports.jsp">
                                Reports
                            </a>
                        </li>
                        <li class="nav-item dropdown ms-lg-3">
                            <a class="nav-link dropdown-toggle btn btn-outline-primary px-3 py-1 border-0" href="#"
                                id="userDropdown" role="button" data-bs-toggle="dropdown">
                                <i class="bi bi-person-circle me-1"></i>
                                <%= session.getAttribute("full_name") %>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end shadow-lg border-0"
                                style="background: var(--bg-card); backdrop-filter: blur(10px);"
                                aria-labelledby="userDropdown">
                                <li><a class="dropdown-item" style="color: var(--text-main);" href="profile.jsp"><i
                                            class="bi bi-person me-2"></i>Profile</a></li>
                                <li><a class="dropdown-item" style="color: var(--text-main);" href="settings.jsp"><i
                                            class="bi bi-gear me-2"></i>Settings</a></li>
                                <li>
                                    <hr class="dropdown-divider" style="border-color: var(--border-color);">
                                </li>
                                <li><a class="dropdown-item text-danger" href="logout"><i
                                            class="bi bi-box-arrow-right me-2"></i>Logout</a></li>
                            </ul>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <script>
            // Check session for dark mode setting
            // 1. If 'is_dark_mode' is explicitly TRUE -> Enable Dark Mode
            // 2. If 'is_dark_mode' is NULL (first visit/default) -> Enable Dark Mode (Ocean Default)
            const sessionDarkMode = '<%= session.getAttribute("is_dark_mode") %>';
            const isDarkMode = sessionDarkMode === 'true' || sessionDarkMode === 'null';

            if (isDarkMode) {
                document.body.classList.add('dark-mode');
            }
        </script>