<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.sql.*" %>
        <%@ page import="com.oceanview.util.DBConnection" %>
            <% if (session.getAttribute("user_id")==null) { response.sendRedirect("index.jsp"); return; } %>
                <!DOCTYPE html>
                <html>

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Reservations - Ocean View Resort</title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css"
                        rel="stylesheet">
                    <link rel="stylesheet" href="css/style.css">
                </head>

                <body>
                    <%@ include file="navbar.jsp" %>
                        <div class="container-fluid py-4">
                            <div class="row mb-4">
                                <div class="col-md-12">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <h1 class="display-6 text-primary">All Reservations</h1>
                                        <a href="reservation.jsp" class="btn btn-primary">
                                            <i class="bi bi-plus-circle"></i> New Reservation
                                        </a>
                                    </div>
                                </div>
                            </div>
                            <div class="card shadow-sm border-0">
                                <div class="card-body p-0">
                                    <div class="table-responsive">
                                        <table class="table table-hover mb-0">
                                            <thead class="table-light">
                                                <tr>
                                                    <th>Res. ID</th>
                                                    <th>Guest Name</th>
                                                    <th>Room Type</th>
                                                    <th>Room No</th>
                                                    <th>Check-In</th>
                                                    <th>Check-Out</th>
                                                    <th>Total Bill</th>
                                                    <th>Status</th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <% try { Connection conn=DBConnection.getConnection(); String
                                                    query="SELECT r.res_id, r.guest_name, r.room_type, r.check_in, r.check_out, r.total_bill, r.status, rm.room_number "
                                                    + "FROM reservations r LEFT JOIN rooms rm ON r.room_id = rm.room_id ORDER BY r.created_at DESC"
                                                    ; PreparedStatement pst=conn.prepareStatement(query); ResultSet
                                                    rs=pst.executeQuery(); while (rs.next()) { int
                                                    resId=rs.getInt("res_id"); String
                                                    guestName=rs.getString("guest_name"); String
                                                    roomType=rs.getString("room_type"); String
                                                    checkIn=rs.getString("check_in"); String
                                                    checkOut=rs.getString("check_out"); double
                                                    bill=rs.getDouble("total_bill"); String
                                                    roomNumber=rs.getString("room_number"); if(roomNumber==null)
                                                    roomNumber="-" ; String status=rs.getString("status"); String
                                                    statusBadge="secondary" ; if ("Confirmed".equals(status))
                                                    statusBadge="success" ; else if ("Checked-In".equals(status))
                                                    statusBadge="info" ; else if ("Cancelled".equals(status))
                                                    statusBadge="danger" ; %>
                                                    <tr>
                                                        <td><strong>#<%= resId %></strong></td>
                                                        <td>
                                                            <%= guestName %>
                                                        </td>
                                                        <td>
                                                            <%= roomType %>
                                                        </td>
                                                        <td>
                                                            <span class="badge bg-dark">
                                                                <%= roomNumber %>
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <%= checkIn %>
                                                        </td>
                                                        <td>
                                                            <%= checkOut %>
                                                        </td>
                                                        <td><strong>$<%= String.format("%.2f", bill) %></strong></td>
                                                        <td><span class="badge bg-<%= statusBadge %>">
                                                                <%= status %>
                                                            </span></td>
                                                        <td>
                                                            <a href="reservation-details.jsp?id=<%= resId %>"
                                                                class="btn btn-sm btn-info" title="View Details">
                                                                <i class="bi bi-eye"></i>
                                                            </a>
                                                            <a href="reservation-edit.jsp?id=<%= resId %>"
                                                                class="btn btn-sm btn-warning" title="Edit">
                                                                <i class="bi bi-pencil"></i>
                                                            </a>
                                                            <form action="reservation" method="POST"
                                                                style="display:inline;"
                                                                onsubmit="return confirm('Are you sure you want to delete this reservation?');">
                                                                <input type="hidden" name="action" value="delete">
                                                                <input type="hidden" name="id" value="<%= resId %>">
                                                                <button type="submit" class="btn btn-sm btn-danger"
                                                                    title="Delete">
                                                                    <i class="bi bi-trash"></i>
                                                                </button>
                                                            </form>
                                                        </td>
                                                    </tr>
                                                    <% } rs.close(); pst.close(); conn.close(); } catch (Exception e) {
                                                        out.println("<tr>");
                                                        out.print("<td colspan='8' class='text-center text-danger'>");
                                                            out.print("Error loading reservations: ");
                                                            out.print(e.getMessage());
                                                            out.println("</td>");
                                                        out.println("</tr>");
                                                        }
                                                        %>
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