<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.sql.*" %>
        <%@ page import="com.oceanview.util.DBConnection" %>
            <% if (session.getAttribute("user_id")==null) { response.sendRedirect("index.jsp"); return; } %>
                <!DOCTYPE html>
                <html>

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Admin Dashboard - Ocean View Resort</title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link rel="stylesheet" href="css/style.css">
                    <script>
                        setTimeout(function () {
                            window.location.reload();
                        }, 30000);
                    </script>
                </head>

                <body>
                    <%@ include file="navbar.jsp" %>

                        <div class="container-fluid py-4">
                            <div class="row mb-4">
                                <div class="col-md-12">
                                    <h1 class="display-6 text-primary">
                                        <i class="bi bi-speedometer2"></i> Admin Dashboard
                                    </h1>
                                    <p class="text-muted">Welcome, <%= session.getAttribute("full_name") %>!
                                            <span id="notifStatus" class="badge bg-secondary" style="cursor:pointer;"
                                                onclick="requestNotifPermission()">
                                                <i class="bi bi-bell"></i> Checking...
                                            </span>
                                    </p>
                                </div>
                            </div>

                            <div class="row g-4">
                                <!-- Total Reservations Card -->
                                <div class="col-md-6 col-lg-3">
                                    <div class="card border-0 shadow-sm h-100">
                                        <div class="card-body">
                                            <div class="d-flex justify-content-between align-items-start">
                                                <div>
                                                    <h6 class="card-title text-muted mb-1">Total Reservations</h6>
                                                    <h2 class="text-primary mb-0">
                                                        <% try { Connection conn=DBConnection.getConnection(); String
                                                            sql="SELECT COUNT(*) as count FROM reservations" ;
                                                            PreparedStatement pst=conn.prepareStatement(sql); ResultSet
                                                            rs=pst.executeQuery(); if (rs.next()) {
                                                            out.print(rs.getInt("count")); } rs.close(); pst.close(); }
                                                            catch (Exception e) { out.print("0"); e.printStackTrace(); }
                                                            %>
                                                    </h2>
                                                </div>
                                                <div class="text-primary" style="font-size: 2rem;">📅</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Checked-In Guests Card -->
                                <div class="col-md-6 col-lg-3">
                                    <div class="card border-0 shadow-sm h-100">
                                        <div class="card-body">
                                            <div class="d-flex justify-content-between align-items-start">
                                                <div>
                                                    <h6 class="card-title text-muted mb-1">Checked-In</h6>
                                                    <h2 class="text-success mb-0">
                                                        <% try { Connection conn=DBConnection.getConnection(); String
                                                            sql="SELECT COUNT(*) as count FROM reservations WHERE status = 'Checked-In'"
                                                            ; PreparedStatement pst=conn.prepareStatement(sql);
                                                            ResultSet rs=pst.executeQuery(); if (rs.next()) {
                                                            out.print(rs.getInt("count")); } rs.close(); pst.close(); }
                                                            catch (Exception e) { out.print("0"); } %>
                                                    </h2>
                                                </div>
                                                <div class="text-success" style="font-size: 2rem;">✓</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Pending Reservations Card -->
                                <div class="col-md-6 col-lg-3">
                                    <div class="card border-0 shadow-sm h-100">
                                        <div class="card-body">
                                            <div class="d-flex justify-content-between align-items-start">
                                                <div>
                                                    <h6 class="card-title text-muted mb-1">Pending</h6>
                                                    <h2 class="text-warning mb-0">
                                                        <% try { Connection conn=DBConnection.getConnection(); String
                                                            sql="SELECT COUNT(*) as count FROM reservations WHERE status = 'Pending'"
                                                            ; PreparedStatement pst=conn.prepareStatement(sql);
                                                            ResultSet rs=pst.executeQuery(); if (rs.next()) {
                                                            out.print(rs.getInt("count")); } rs.close(); pst.close(); }
                                                            catch (Exception e) { out.print("0"); } %>
                                                    </h2>
                                                </div>
                                                <div class="text-warning" style="font-size: 2rem;">⏳</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Revenue This Month Card -->
                                <div class="col-md-6 col-lg-3">
                                    <div class="card border-0 shadow-sm h-100">
                                        <div class="card-body">
                                            <div class="d-flex justify-content-between align-items-start">
                                                <div>
                                                    <h6 class="card-title text-muted mb-1">Revenue (Month)</h6>
                                                    <h2 class="text-info mb-0">
                                                        $
                                                        <% try { Connection conn=DBConnection.getConnection(); String
                                                            sql="SELECT SUM(total_bill) as revenue FROM reservations WHERE MONTH(created_at) = MONTH(NOW()) AND YEAR(created_at) = YEAR(NOW())"
                                                            ; PreparedStatement pst=conn.prepareStatement(sql);
                                                            ResultSet rs=pst.executeQuery(); if (rs.next()) { Double
                                                            revenue=rs.getDouble("revenue");
                                                            out.print(String.format("%.2f", revenue !=null ? revenue :
                                                            0)); } rs.close(); pst.close(); } catch (Exception e) {
                                                            out.print("0.00"); } %>
                                                    </h2>
                                                </div>
                                                <div class="text-info" style="font-size: 2rem;">💰</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="row g-4 mt-3">
                                <!-- Quick Actions -->
                                <div class="col-md-12">
                                    <div class="card border-0 shadow-sm">
                                        <div class="card-header bg-light border-bottom">
                                            <h5 class="card-title mb-0">Quick Actions</h5>
                                        </div>
                                        <div class="card-body">
                                            <a href="reservation.jsp" class="btn btn-primary me-2 mb-2">
                                                <i class="bi bi-plus-circle"></i> New Reservation
                                            </a>
                                            <a href="reservations-list.jsp" class="btn btn-secondary me-2 mb-2">
                                                <i class="bi bi-list-ul"></i> View Reservations
                                            </a>
                                            <a href="reports.jsp" class="btn btn-info me-2 mb-2">
                                                <i class="bi bi-file-earmark-pdf"></i> Reports
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <script
                            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

                        <script>
                            document.addEventListener('DOMContentLoaded', function () {
                                // Check if browser notifications are enabled in session settings
                                // Note: This relies on the JSP rendering 'true' or 'false' directly into the JS code.
                                var isBrowserNotif = '<%= session.getAttribute("is_browser_notif") %>' === 'true';

                                if (isBrowserNotif) {
                                    // Request permission immediately if we want notifications
                                    if (Notification.permission !== "granted" && Notification.permission !== "denied") {
                                        Notification.requestPermission();
                                    }

                                    // Poll every 10 seconds
                                    setInterval(function () {
                                        fetch('api/notifications')
                                            .then(response => {
                                                if (!response.ok) throw new Error("Network response was not ok");
                                                return response.json();
                                            })
                                            .then(data => {
                                                if (data.count > 0) {
                                                    if (Notification.permission === "granted") {
                                                        new Notification("New Reservation!", {
                                                            body: data.count + " new reservation(s). Latest: " + data.latestGuest,
                                                            icon: "https://cdn-icons-png.flaticon.com/512/2936/2936956.png" // Generic hotel icon
                                                        });

                                                        // Optional: Play a sound
                                                        // var audio = new Audio('notification.mp3');
                                                        // audio.play().catch(e => console.log('Audio play failed', e));
                                                    }
                                                }
                                            })
                                            .catch(error => console.error('Error polling notifications:', error));
                                    }, 10000); // Poll every 10 seconds
                                }
                            });
                        </script>
                </body>

                </html>