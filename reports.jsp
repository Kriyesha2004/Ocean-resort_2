<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.sql.*" %>
        <% if (session.getAttribute("user_id")==null) { response.sendRedirect("index.jsp"); return; } %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Reports - Ocean View Resort</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet" href="css/style.css">
            </head>

            <body>
                <%@ include file="navbar.jsp" %>

                    <div class="container-fluid py-4">
                        <div class="row mb-4">
                            <div class="col-md-12">
                                <h1 class="display-6 text-primary">Reports & Analytics</h1>
                            </div>
                        </div>

                        <div class="row g-4">
                            <!-- Daily Occupancy Report -->
                            <div class="col-md-12">
                                <div class="card shadow-sm border-0">
                                    <div class="card-header bg-light border-bottom">
                                        <h5 class="card-title mb-0">Daily Occupancy Report</h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="table-responsive">
                                            <table class="table table-hover">
                                                <thead class="table-light">
                                                    <tr>
                                                        <th>Date</th>
                                                        <th>Single Rooms</th>
                                                        <th>Double Rooms</th>
                                                        <th>Luxury Suites</th>
                                                        <th>Total Occupied</th>
                                                        <th>Occupancy %</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <% try { Connection conn=getDBConnection(); String
                                                        query="SELECT DATE(check_in) as date, "
                                                        + "SUM(CASE WHEN room_type='Single' AND status='Checked-In' THEN 1 ELSE 0 END) as single_rooms, "
                                                        + "SUM(CASE WHEN room_type='Double' AND status='Checked-In' THEN 1 ELSE 0 END) as double_rooms, "
                                                        + "SUM(CASE WHEN room_type='Luxury' AND status='Checked-In' THEN 1 ELSE 0 END) as luxury_rooms "
                                                        + "FROM reservations "
                                                        + "WHERE status IN ('Checked-In', 'Confirmed') "
                                                        + "GROUP BY DATE(check_in) "
                                                        + "ORDER BY DATE(check_in) DESC LIMIT 30" ; PreparedStatement
                                                        pst=conn.prepareStatement(query); ResultSet
                                                        rs=pst.executeQuery(); while (rs.next()) { int
                                                        single=rs.getInt("single_rooms"); int
                                                        double_r=rs.getInt("double_rooms"); int
                                                        luxury=rs.getInt("luxury_rooms"); int total=single + double_r +
                                                        luxury; %>
                                                        <tr>
                                                            <td><strong>
                                                                    <%= rs.getString("date") %>
                                                                </strong></td>
                                                            <td>
                                                                <%= single %>
                                                            </td>
                                                            <td>
                                                                <%= double_r %>
                                                            </td>
                                                            <td>
                                                                <%= luxury %>
                                                            </td>
                                                            <td>
                                                                <%= total %>
                                                            </td>
                                                            <td>
                                                                <div class="progress" style="height: 20px;">
                                                                    <div class="progress-bar" role="progressbar"
                                                                        style="<%= " width: " + (total * 100 / 30) + "
                                                                        %" %>">
                                                                        <%= (total * 100 / 30) %>%
                                                                    </div>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <% } rs.close(); pst.close(); conn.close(); } catch (Exception
                                                            e) { out.println("<tr>" +
                                                            "<td colspan='6' class='text-danger text-center'>Error
                                                                loading report: " + e.getMessage() + "</td>" +
                                                            "</tr>");
                                                            }
                                                            %>
                                                </tbody>
                                            </table>
                                        </div>
                                        <div class="mt-3">
                                            <button onclick="window.print()" class="btn btn-primary">
                                                <i class="bi bi-printer"></i> Print Report
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Revenue Summary -->
                            <div class="col-md-12">
                                <div class="card shadow-sm border-0">
                                    <div class="card-header bg-light border-bottom">
                                        <h5 class="card-title mb-0">Monthly Revenue Summary</h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="table-responsive">
                                            <table class="table table-hover">
                                                <thead class="table-light">
                                                    <tr>
                                                        <th>Month</th>
                                                        <th>Total Reservations</th>
                                                        <th>Total Revenue</th>
                                                        <th>Average Bill</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <% try { Connection conn=getDBConnection(); String
                                                        query="SELECT DATE_FORMAT(created_at, '%Y-%m') as month, "
                                                        + "COUNT(*) as total_reservations, "
                                                        + "SUM(total_bill) as total_revenue, "
                                                        + "AVG(total_bill) as avg_bill " + "FROM reservations "
                                                        + "GROUP BY DATE_FORMAT(created_at, '%Y-%m') "
                                                        + "ORDER BY month DESC LIMIT 12" ; PreparedStatement
                                                        pst=conn.prepareStatement(query); ResultSet
                                                        rs=pst.executeQuery(); while (rs.next()) { double
                                                        revenue=rs.getDouble("total_revenue"); double
                                                        avg=rs.getDouble("avg_bill"); %>
                                                        <tr>
                                                            <td><strong>
                                                                    <%= rs.getString("month") %>
                                                                </strong></td>
                                                            <td>
                                                                <%= rs.getInt("total_reservations") %>
                                                            </td>
                                                            <td><strong>$<%= String.format("%.2f", revenue) %></strong>
                                                            </td>
                                                            <td>$<%= String.format("%.2f", avg) %>
                                                            </td>
                                                        </tr>
                                                        <% } rs.close(); pst.close(); conn.close(); } catch (Exception
                                                            e) { out.println("<tr>" +
                                                            "<td colspan='4' class='text-danger text-center'>Error
                                                                loading revenue data: " + e.getMessage() + "</td>" +
                                                            "</tr>");
                                                            }
                                                            %>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>

            <%! // Helper method to get database connection // This removes duplication of connection logic private
                Connection getDBConnection() throws Exception { Class.forName("com.mysql.cj.jdbc.Driver"); return
                DriverManager.getConnection("jdbc:mysql://localhost:3306/ocean_view_db", "root" , "" ); } %>