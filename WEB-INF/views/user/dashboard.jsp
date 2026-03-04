<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.sql.*" %>
        <%@ page import="com.oceanview.util.DBConnection" %>
            <% if (session.getAttribute("user_id")==null) { response.sendRedirect(request.getContextPath()
                + "/index.jsp" ); return; } %>
                <!DOCTYPE html>
                <html>

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Dashboard - Ocean View Resort</title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                    <link href='https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.css' rel='stylesheet' />
                    <script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.js'></script>


                </head>

                <body>
                    <%@ include file="/WEB-INF/views/shared/navbar.jsp" %>

                        <div class="container-fluid py-4">
                            <div class="row mb-4">
                                <div class="col-md-12">
                                    <h1 class="display-6 text-primary">
                                        <i class="bi bi-speedometer2"></i> Dashboard
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
                                                            sql="SELECT SUM(total_bill) as revenue FROM reservations WHERE status = 'Checked-Out' AND MONTH(created_at) = MONTH(NOW()) AND YEAR(created_at) = YEAR(NOW())"
                                                            ; PreparedStatement pst=conn.prepareStatement(sql);
                                                            ResultSet rs=pst.executeQuery(); if (rs.next()) { Double
                                                            revenue=rs.getDouble("revenue");
                                                            out.print(String.format("%.2f", revenue !=null ? revenue :
                                                            0.0)); } rs.close(); pst.close(); } catch (Exception e) {
                                                            out.print("0.00"); } %>
                                                    </h2>
                                                </div>
                                                <div class="text-info" style="font-size: 2rem;">💰</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Available Rooms Detail Card -->
                                <div class="col-md-6 col-lg-3">
                                    <div class="card border-0 shadow-sm h-100">
                                        <div class="card-body">
                                            <h6 class="card-title text-muted mb-3">Available Rooms By Type</h6>
                                            <% try { Connection conn=DBConnection.getConnection(); String
                                                sql="SELECT room_type, GROUP_CONCAT(room_number SEPARATOR ', ') as numbers, COUNT(*) as count FROM rooms WHERE status != 'Maintenance' AND room_id NOT IN (SELECT room_id FROM reservations WHERE check_in <= CURDATE() AND check_out > CURDATE() AND status IN ('Pending', 'Confirmed', 'Checked-In')) GROUP BY room_type"
                                                ; PreparedStatement pst=conn.prepareStatement(sql); ResultSet
                                                rs=pst.executeQuery(); boolean hasAvailable=false; while (rs.next()) {
                                                hasAvailable=true; String type=rs.getString("room_type"); String
                                                numbers=rs.getString("numbers"); int count=rs.getInt("count"); %>
                                                <div class="mb-2">
                                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                                        <span class="badge bg-light text-dark border">
                                                            <%= type %>
                                                        </span>
                                                        <span class="badge bg-success">
                                                            <%= count %>
                                                        </span>
                                                    </div>
                                                    <p class="small text-muted mb-0" style="font-size: 0.8rem;">
                                                        Rooms: <%= numbers %>
                                                    </p>
                                                </div>
                                                <% } if (!hasAvailable) { %>
                                                    <p class="text-muted small">No rooms available.</p>
                                                    <% } rs.close(); pst.close(); } catch (Exception e) {
                                                        out.print("<span class='text-danger'>Error loading</span>"); }
                                                        %>
                                        </div>
                                    </div>
                                </div>

                                <!-- Overdue Checkouts Card -->
                                <div class="col-md-6 col-lg-3">
                                    <div class="card border-0 shadow-sm h-100">
                                        <div class="card-body">
                                            <div class="d-flex justify-content-between align-items-start">
                                                <div>
                                                    <h6 class="card-title text-muted mb-1">Overdue Checkouts</h6>
                                                    <h2 class="text-danger mb-0">
                                                        <% try { Connection conn=DBConnection.getConnection(); String
                                                            sql="SELECT COUNT(*) as count FROM reservations WHERE status = 'Checked-In' AND check_out < CURDATE()"
                                                            ; PreparedStatement pst=conn.prepareStatement(sql);
                                                            ResultSet rs=pst.executeQuery(); if (rs.next()) {
                                                            out.print(rs.getInt("count")); } rs.close(); pst.close(); }
                                                            catch (Exception e) { out.print("0"); } %>
                                                    </h2>
                                                </div>
                                                <div class="text-danger" style="font-size: 2rem;">⚠️</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="row g-4 mt-3">
                                <!-- Room Search Section -->
                                <div class="col-md-12">
                                    <div class="card border-0 shadow-sm">
                                        <div class="card-header bg-light border-bottom">
                                            <h5 class="card-title mb-0">Quick Room Search & Availability</h5>
                                        </div>
                                        <div class="card-body">
                                            <form id="availabilityForm" class="row g-3"
                                                onsubmit="event.preventDefault(); performSearch();">
                                                <div class="col-md-3">
                                                    <label for="search_check_in" class="form-label">Check-In</label>
                                                    <input type="date" class="form-control" id="search_check_in"
                                                        name="check_in" required>
                                                </div>
                                                <div class="col-md-3">
                                                    <label for="search_check_out" class="form-label">Check-Out</label>
                                                    <input type="date" class="form-control" id="search_check_out"
                                                        name="check_out" required>
                                                </div>
                                                <div class="col-md-3">
                                                    <label for="search_room_type" class="form-label">Room Type</label>
                                                    <select class="form-select" id="search_room_type" name="room_type">
                                                        <option value="Single">Single</option>
                                                        <option value="Double">Double</option>
                                                        <option value="Suite">Suite</option>
                                                        <option value="Deluxe">Deluxe</option>
                                                    </select>
                                                </div>
                                                <div class="col-md-3 d-flex align-items-end">
                                                    <button type="submit" class="btn btn-primary w-100">
                                                        <i class="bi bi-search"></i> Search Availability
                                                    </button>
                                                </div>
                                                <div id="search_error" class="text-danger small mt-2"
                                                    style="display:none;">
                                                    Check-out date must be after check-in date.
                                                </div>
                                            </form>

                                            <!-- Search Results Container -->
                                            <div id="search_results" class="mt-4" style="display:none;">
                                                <div
                                                    class="alert alert-info d-flex justify-content-between align-items-center">
                                                    <div id="search_message"></div>
                                                    <a id="book_link" href="#" class="btn btn-success btn-sm">
                                                        Go to Reservation
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="row g-4 mt-3">
                                <div class="col-md-12">
                                    <div
                                        class="card-header bg-light border-bottom d-flex justify-content-between align-items-center">
                                        <h5 class="card-title mb-0">Reservation Calendar</h5>
                                        <div class="small">
                                            <span class="badge"
                                                style="background-color: #198754;">Booked/Confirmed</span>
                                            <span class="badge"
                                                style="background-color: #ffc107; color: #000;">Pending</span>
                                            <span class="badge" style="background-color: #0dcaf0;">Checked-In</span>
                                            <span class="badge" style="background-color: #dc3545;">Cancelled</span>
                                        </div>
                                    </div>
                                    <div class="card-body">
                                        <div id='calendar'></div>
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
                                        <a href="${pageContext.request.contextPath}/view/reservation"
                                            class="btn btn-primary me-2 mb-2">
                                            <i class="bi bi-plus-circle"></i> New Reservation
                                        </a>
                                        <a href="${pageContext.request.contextPath}/view/reservations-list"
                                            class="btn btn-secondary me-2 mb-2">
                                            <i class="bi bi-list-ul"></i> View Reservations
                                        </a>
                                        <a href="${pageContext.request.contextPath}/view/reports"
                                            class="btn btn-info me-2 mb-2">
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
                                var calendarEl = document.getElementById('calendar');
                                if (calendarEl) {
                                    var calendar = new FullCalendar.Calendar(calendarEl, {
                                        initialView: 'dayGridMonth',
                                        headerToolbar: {
                                            left: 'prev,next today',
                                            center: 'title',
                                            right: 'dayGridMonth,timeGridWeek,listMonth'
                                        },
                                        themeSystem: 'bootstrap5',
                                        events: '<%= request.getContextPath() %>/api/calendar',
                                        eventSourceFailure: function (error) {
                                            console.error("FullCalendar error:", error);
                                            alert("Failed to load calendar events. Please check the server logs.");
                                        },
                                        loading: function (isLoading) {
                                            if (isLoading) {
                                                console.log("Loading calendar events...");
                                            }
                                        }
                                    });
                                    calendar.render();
                                }
                            });

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

                            function validateSearchDates() {
                                var checkIn = document.getElementById('search_check_in').value;
                                var checkOut = document.getElementById('search_check_out').value;
                                var errorDiv = document.getElementById('search_error');

                                if (checkIn && checkOut) {
                                    if (new Date(checkOut) <= new Date(checkIn)) {
                                        errorDiv.style.display = 'block';
                                        return false;
                                    }
                                }
                                errorDiv.style.display = 'none';
                                return true;
                            }

                            function performSearch() {
                                if (!validateSearchDates()) return;

                                const checkIn = document.getElementById('search_check_in').value;
                                const checkOut = document.getElementById('search_check_out').value;
                                const roomType = document.getElementById('search_room_type').value;

                                fetch('<%= request.getContextPath() %>/api/search?check_in=' + checkIn + '&check_out=' + checkOut + '&room_type=' + roomType)
                                    .then(response => response.json())
                                    .then(data => {
                                        const resultsDiv = document.getElementById('search_results');
                                        const messageDiv = document.getElementById('search_message');
                                        const bookLink = document.getElementById('book_link');
                                        const alertDiv = resultsDiv.querySelector('.alert');

                                        resultsDiv.style.display = 'block';
                                        messageDiv.innerHTML = data.message;

                                        if (data.available) {
                                            alertDiv.className = 'alert alert-success d-flex justify-content-between align-items-center';
                                            bookLink.style.display = 'inline-block';
                                            bookLink.href = '<%= request.getContextPath() %>/view/reservation?check_in=' + checkIn + '&check_out=' + checkOut + '&room_type=' + roomType;
                                        } else {
                                            alertDiv.className = 'alert alert-danger d-flex justify-content-between align-items-center';
                                            bookLink.style.display = 'none';
                                        }
                                    })
                                    .catch(error => {
                                        console.error('Search error:', error);
                                        alert("An error occurred while searching: " + error.message);
                                    });
                            }
                        </script>
                </body>

                </html>