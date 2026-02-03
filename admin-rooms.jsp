<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.util.List" %>
        <%@ page import="com.oceanview.model.Room" %>
            <%@ page import="com.oceanview.dao.RoomDAO" %>
                <% // Ensure user is logged in (and preferably admin, but we'll stick to basic login check for now) if
                    (session.getAttribute("user_id")==null) { response.sendRedirect("index.jsp"); return; } RoomDAO
                    roomDAO=new RoomDAO(); List<Room> rooms = roomDAO.getAllRooms();
                    %>
                    <!DOCTYPE html>
                    <html>

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Room Management - Ocean View Resort</title>
                        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                            rel="stylesheet">
                        <link rel="stylesheet" href="css/style.css">
                    </head>

                    <body>
                        <%@ include file="navbar.jsp" %>

                            <div class="container py-5">
                                <div class="d-flex justify-content-between align-items-center mb-4">
                                    <h1>Room Inventory</h1>
                                    <!-- Add Room Modal Trigger would go here, omitting for brevity/mvp -->
                                    <button class="btn btn-primary" disabled>+ Add Room (Coming Soon)</button>
                                </div>

                                <div class="card shadow-sm">
                                    <div class="card-body">
                                        <div class="table-responsive">
                                            <table class="table table-hover">
                                                <thead class="table-light">
                                                    <tr>
                                                        <th>Room Number</th>
                                                        <th>Type</th>
                                                        <th>Status</th>
                                                        <th>Action</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <% for(Room room : rooms) { %>
                                                        <tr>
                                                            <td><strong>
                                                                    <%= room.getRoomNumber() %>
                                                                </strong></td>
                                                            <td><span class="badge bg-info text-dark">
                                                                    <%= room.getRoomType() %>
                                                                </span></td>
                                                            <td>
                                                                <% if("Available".equals(room.getStatus())) { %>
                                                                    <span class="badge bg-success">Available</span>
                                                                    <% } else if("Booked".equals(room.getStatus())) { %>
                                                                        <span class="badge bg-danger">Booked</span>
                                                                        <% } else { %>
                                                                            <span class="badge bg-warning text-dark">
                                                                                <%= room.getStatus() %>
                                                                            </span>
                                                                            <% } %>
                                                            </td>
                                                            <td>
                                                                <button class="btn btn-sm btn-outline-secondary"
                                                                    disabled>Edit</button>
                                                            </td>
                                                        </tr>
                                                        <% } %>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <script
                                src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                    </body>

                    </html>