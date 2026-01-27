<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("user_id") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow-sm">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold" href="dashboard.jsp">
            🏨 Ocean View Resort
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="nav-link active" aria-current="page" href="dashboard.jsp">
                        <i class="bi bi-speedometer2"></i> Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="reservation.jsp">
                        <i class="bi bi-plus-circle"></i> New Reservation
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="reservations-list.jsp">
                        <i class="bi bi-list-ul"></i> Reservations
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="reports.jsp">
                        <i class="bi bi-file-earmark-pdf"></i> Reports
                    </a>
                </li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown">
                        <i class="bi bi-person-circle"></i> <%= session.getAttribute("full_name") %>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                        <li><a class="dropdown-item" href="#">Profile</a></li>
                        <li><a class="dropdown-item" href="#">Settings</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="logout">Logout</a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</nav>
