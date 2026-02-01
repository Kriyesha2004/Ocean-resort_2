<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.sql.*" %>
        <%@ page import="com.oceanview.util.DBConnection" %>
            <% if (session.getAttribute("user_id")==null) { response.sendRedirect("index.jsp"); return; } String
                resIdParam=request.getParameter("id"); if (resIdParam==null || resIdParam.isEmpty()) {
                response.sendRedirect("reservations-list.jsp"); return; } int resId=Integer.parseInt(resIdParam);
                Connection conn=null; PreparedStatement pst=null; ResultSet rs=null; String guestName="" ; String
                roomType="" ; String checkIn="" ; String checkOut="" ; String address="" ; String contactNo="" ; String
                email="" ; try { conn=DBConnection.getConnection(); String
                query="SELECT * FROM reservations WHERE res_id = ?" ; pst=conn.prepareStatement(query); pst.setInt(1,
                resId); rs=pst.executeQuery(); if (rs.next()) { guestName=rs.getString("guest_name");
                roomType=rs.getString("room_type"); checkIn=rs.getString("check_in");
                checkOut=rs.getString("check_out"); address=rs.getString("address");
                contactNo=rs.getString("contact_no"); email=rs.getString("email"); } else {
                response.sendRedirect("reservations-list.jsp?error=Reservation not found"); return; } } catch (Exception
                e) { e.printStackTrace(); } finally { if (rs !=null) try { rs.close(); } catch (SQLException e) {} if
                (pst !=null) try { pst.close(); } catch (SQLException e) {} if (conn !=null) try { conn.close(); } catch
                (SQLException e) {} } %>
                <!DOCTYPE html>
                <html>

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Edit Reservation - Ocean View Resort</title>
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
                                        <div class="card-header bg-warning text-dark">
                                            <h4 class="mb-0">Edit Reservation #<%= resId %>
                                            </h4>
                                        </div>
                                        <div class="card-body">
                                            <form action="reservation" method="POST">
                                                <input type="hidden" name="action" value="update">
                                                <input type="hidden" name="id" value="<%= resId %>">

                                                <div class="mb-3">
                                                    <label class="form-label">Guest Name</label>
                                                    <input type="text" name="guest_name" class="form-control"
                                                        value="<%= guestName %>" required>
                                                </div>

                                                <div class="row">
                                                    <div class="col-md-6 mb-3">
                                                        <label class="form-label">Email</label>
                                                        <input type="email" name="email" class="form-control"
                                                            value="<%= email %>" required>
                                                    </div>
                                                    <div class="col-md-6 mb-3">
                                                        <label class="form-label">Contact No</label>
                                                        <input type="text" name="contact_no" class="form-control"
                                                            value="<%= contactNo %>" required>
                                                    </div>
                                                </div>

                                                <div class="mb-3">
                                                    <label class="form-label">Address</label>
                                                    <textarea name="address" class="form-control" rows="2"
                                                        required><%= address %></textarea>
                                                </div>

                                                <h5 class="mt-4 mb-3 border-bottom pb-2">Room & Dates</h5>

                                                <div class="mb-3">
                                                    <label class="form-label">Room Type</label>
                                                    <select name="room_type" class="form-select" required>
                                                        <option value="Single" <%="Single" .equals(roomType)
                                                            ? "selected" : "" %>>Single</option>
                                                        <option value="Double" <%="Double" .equals(roomType)
                                                            ? "selected" : "" %>>Double</option>
                                                        <option value="Luxury" <%="Luxury" .equals(roomType)
                                                            ? "selected" : "" %>>Luxury</option>
                                                    </select>
                                                </div>

                                                <div class="row">
                                                    <div class="col-md-6 mb-3">
                                                        <label class="form-label">Check-In Date</label>
                                                        <input type="date" name="check_in" class="form-control"
                                                            value="<%= checkIn %>" required>
                                                    </div>
                                                    <div class="col-md-6 mb-3">
                                                        <label class="form-label">Check-Out Date</label>
                                                        <input type="date" name="check_out" class="form-control"
                                                            value="<%= checkOut %>" required>
                                                    </div>
                                                </div>

                                                <div class="d-flex justify-content-between mt-4">
                                                    <a href="reservations-list.jsp" class="btn btn-secondary">Cancel</a>
                                                    <button type="submit" class="btn btn-primary">Update
                                                        Reservation</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <script
                            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                </body>

                </html>