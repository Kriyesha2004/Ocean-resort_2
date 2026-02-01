<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.sql.*" %>
        <%@ page import="com.oceanview.util.DBConnection" %>
            <% if (session.getAttribute("user_id")==null) { response.sendRedirect("index.jsp"); return; } String
                resIdParam=request.getParameter("id"); if (resIdParam==null || resIdParam.isEmpty()) {
                response.sendRedirect("reservations-list.jsp"); return; } int resId=Integer.parseInt(resIdParam);
                Connection conn=null; PreparedStatement pst=null; ResultSet rs=null; String guestName="" ; String
                roomType="" ; String checkIn="" ; String checkOut="" ; double totalBill=0.0; String status="" ; String
                address="" ; String contactNo="" ; String email="" ; Date createdAt=null; try {
                conn=DBConnection.getConnection(); String query="SELECT * FROM reservations WHERE res_id = ?" ;
                pst=conn.prepareStatement(query); pst.setInt(1, resId); rs=pst.executeQuery(); if (rs.next()) {
                guestName=rs.getString("guest_name"); roomType=rs.getString("room_type");
                checkIn=rs.getString("check_in"); checkOut=rs.getString("check_out");
                totalBill=rs.getDouble("total_bill"); status=rs.getString("status"); address=rs.getString("address");
                contactNo=rs.getString("contact_no"); email=rs.getString("email"); createdAt=rs.getDate("created_at"); }
                else { response.sendRedirect("reservations-list.jsp?error=Reservation not found"); return; } } catch
                (Exception e) { e.printStackTrace(); } finally { if (rs !=null) try { rs.close(); } catch (SQLException
                e) {} if (pst !=null) try { pst.close(); } catch (SQLException e) {} if (conn !=null) try {
                conn.close(); } catch (SQLException e) {} } %>
                <!DOCTYPE html>
                <html>

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Reservation Details - Ocean View Resort</title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link rel="stylesheet" href="css/style.css">
                </head>

                <body>
                    <%@ include file="navbar.jsp" %>

                        <div class="container py-5">
                            <div class="row justify-content-center">
                                <div class="col-md-8">
                                    <div class="card shadow">
                                        <div
                                            class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                                            <h4 class="mb-0">Reservation Details #<%= resId %>
                                            </h4>
                                            <span class="badge bg-light text-primary">
                                                <%= status %>
                                            </span>
                                        </div>
                                        <div class="card-body">
                                            <div class="row mb-4">
                                                <div class="col-md-6">
                                                    <h5 class="text-secondary border-bottom pb-2">Guest Information</h5>
                                                    <p><strong>Name:</strong>
                                                        <%= guestName %>
                                                    </p>
                                                    <p><strong>Email:</strong>
                                                        <%= email %>
                                                    </p>
                                                    <p><strong>Contact:</strong>
                                                        <%= contactNo %>
                                                    </p>
                                                    <p><strong>Address:</strong>
                                                        <%= address %>
                                                    </p>
                                                </div>
                                                <div class="col-md-6">
                                                    <h5 class="text-secondary border-bottom pb-2">Booking Details</h5>
                                                    <p><strong>Room Type:</strong>
                                                        <%= roomType %>
                                                    </p>
                                                    <p><strong>Check-In:</strong>
                                                        <%= checkIn %>
                                                    </p>
                                                    <p><strong>Check-Out:</strong>
                                                        <%= checkOut %>
                                                    </p>
                                                    <p><strong>Total Bill:</strong> $<%= String.format("%.2f",
                                                            totalBill) %>
                                                    </p>
                                                    <p><small class="text-muted">Booked on: <%= createdAt %></small></p>
                                                </div>
                                            </div>

                                            <div class="d-flex justify-content-end gap-2">
                                                <a href="reservations-list.jsp" class="btn btn-secondary">Back to
                                                    List</a>

                                                <% if ("Confirmed".equals(status) || "Pending" .equals(status)) { %>
                                                    <form action="reservation" method="POST" style="display:inline;">
                                                        <input type="hidden" name="action" value="update_status">
                                                        <input type="hidden" name="id" value="<%= resId %>">
                                                        <input type="hidden" name="new_status" value="Checked-In">
                                                        <button type="submit" class="btn btn-success">Check In
                                                            Guest</button>
                                                    </form>
                                                    <% } else if ("Checked-In".equals(status)) { %>
                                                        <form action="reservation" method="POST"
                                                            style="display:inline;">
                                                            <input type="hidden" name="action" value="update_status">
                                                            <input type="hidden" name="id" value="<%= resId %>">
                                                            <input type="hidden" name="new_status" value="Checked-Out">
                                                            <button type="submit" class="btn btn-dark">Check Out
                                                                Guest</button>
                                                        </form>
                                                        <% } %>

                                                            <a href="reservation-edit.jsp?id=<%= resId %>"
                                                                class="btn btn-warning">Edit</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <script
                            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                </body>

                </html>