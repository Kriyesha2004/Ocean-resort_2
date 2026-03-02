<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.sql.*" %>
        <%@ page import="com.oceanview.util.DBConnection" %>
            <% if (session.getAttribute("user_id")==null) { response.sendRedirect(request.getContextPath()
                + "/index.jsp" ); return; } String resIdParam=request.getParameter("id"); if (resIdParam==null ||
                resIdParam.isEmpty()) { response.sendRedirect(request.getContextPath() + "/view/reservations-list" );
                return; } int resId=0; try { resId=Integer.parseInt(resIdParam); } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/view/reservations-list?error=Invalid ID" ); return; }
                Connection conn=null; PreparedStatement pstRes=null; PreparedStatement pstBill=null; ResultSet
                rsRes=null; ResultSet rsBill=null; /* Reservation Details */ String guestName="" ; String roomType="" ;
                String checkIn="" ; String checkOut="" ; String address="" ; String contactNo="" ; String email="" ; /*
                Billing Details */ int nights=0; double ratePerNight=0.0; double totalBill=0.0; String resQuery="" ;
                String billQuery="" ; try { conn=DBConnection.getConnection(); /* Fetch Reservation */
                resQuery="SELECT * FROM reservations WHERE res_id = ?" ; pstRes=conn.prepareStatement(resQuery);
                pstRes.setInt(1, resId); rsRes=pstRes.executeQuery(); if (rsRes.next()) {
                guestName=rsRes.getString("guest_name"); roomType=rsRes.getString("room_type");
                checkIn=rsRes.getString("check_in"); checkOut=rsRes.getString("check_out");
                address=rsRes.getString("address"); contactNo=rsRes.getString("contact_no");
                email=rsRes.getString("email"); } else { response.sendRedirect(request.getContextPath()
                + "/view/reservations-list?error=Reservation not found" ); return; } /* Fetch Billing */
                billQuery="SELECT * FROM billing WHERE res_id = ?" ; pstBill=conn.prepareStatement(billQuery);
                pstBill.setInt(1, resId); rsBill=pstBill.executeQuery(); if (rsBill.next()) {
                nights=rsBill.getInt("nights"); ratePerNight=rsBill.getDouble("rate_per_night");
                totalBill=rsBill.getDouble("total_bill"); } } catch (Exception e) { e.printStackTrace(); } finally { if
                (rsRes !=null) rsRes.close(); if (pstRes !=null) pstRes.close(); if (rsBill !=null) rsBill.close(); if
                (pstBill !=null) pstBill.close(); if (conn !=null) conn.close(); } %>
                <!DOCTYPE html>
                <html>

                <head>
                    <meta charset="UTF-8">
                    <title>Bill - <%= guestName %>
                    </title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <style>
                        body {
                            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                            background-color: #f8f9fa;
                        }

                        .bill-container {
                            background: white;
                            padding: 40px;
                            margin-top: 30px;
                            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
                            border-radius: 8px;
                        }

                        .resort-header {
                            border-bottom: 2px solid #007bff;
                            padding-bottom: 20px;
                            margin-bottom: 20px;
                        }

                        .bill-title {
                            text-transform: uppercase;
                            letter-spacing: 2px;
                            color: #007bff;
                        }

                        .details-table th {
                            background-color: #f1f1f1;
                            width: 30%;
                        }

                        .total-row {
                            font-size: 1.25rem;
                            font-weight: bold;
                            background-color: #e9ecef;
                        }

                        @media print {
                            .no-print {
                                display: none;
                            }

                            .bill-container {
                                box-shadow: none;
                                margin-top: 0;
                                padding: 20px;
                            }

                            body {
                                background: white;
                            }
                        }
                    </style>
                </head>

                <body>
                    <div class="container d-flex justify-content-center">
                        <div class="bill-container col-md-8">
                            <div class="resort-header d-flex justify-content-between align-items-center">
                                <div>
                                    <h2 class="bill-title mb-0">Ocean View Resort</h2>
                                    <p class="text-muted mb-0">123 Coastal Road, Paradise Beach</p>
                                    <p class="text-muted mb-0">Contact: +1 234 567 890</p>
                                </div>
                                <div class="text-end text-muted">
                                    <h5>INVOICE</h5>
                                    <p class="mb-0">Date: <%= java.time.LocalDate.now() %>
                                    </p>
                                    <p class="mb-0">Res ID: #<%= resId %>
                                    </p>
                                </div>
                            </div>

                            <div class="row mb-4">
                                <div class="col-6">
                                    <h6 class="text-primary">BILL TO:</h6>
                                    <p class="mb-1"><strong>
                                            <%= guestName %>
                                        </strong></p>
                                    <p class="mb-1 text-muted">
                                        <%= address %>
                                    </p>
                                    <p class="mb-1 text-muted">Email: <%= email %>
                                    </p>
                                    <p class="mb-0 text-muted">Phone: <%= contactNo %>
                                    </p>
                                </div>
                                <div class="col-6 text-end">
                                    <h6 class="text-primary">STAY DETAILS:</h6>
                                    <p class="mb-1">Room Type: <strong>
                                            <%= roomType %>
                                        </strong></p>
                                    <p class="mb-1">Check-In: <strong>
                                            <%= checkIn %>
                                        </strong></p>
                                    <p class="mb-0">Check-Out: <strong>
                                            <%= checkOut %>
                                        </strong></p>
                                </div>
                            </div>

                            <table class="table table-bordered mb-4">
                                <thead class="table-light">
                                    <tr>
                                        <th>Description</th>
                                        <th class="text-center">Rate</th>
                                        <th class="text-center">Nights</th>
                                        <th class="text-end">Total</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>
                                            <%= roomType %> Room Accommodation
                                        </td>
                                        <td class="text-center">$<%= String.format("%.2f", ratePerNight) %>
                                        </td>
                                        <td class="text-center">x <%= nights %>
                                        </td>
                                        <td class="text-end">$<%= String.format("%.2f", totalBill) %>
                                        </td>
                                    </tr>
                                </tbody>
                                <tfoot>
                                    <tr class="total-row">
                                        <td colspan="3" class="text-end">GRAND TOTAL:</td>
                                        <td class="text-end text-primary">$<%= String.format("%.2f", totalBill) %>
                                        </td>
                                    </tr>
                                </tfoot>
                            </table>

                            <div class="text-center mt-5 mb-4">
                                <p>Thank you for choosing Ocean View Resort!</p>
                                <div class="no-print mt-3">
                                    <button onclick="window.print()" class="btn btn-success me-2">Print Bill</button>
                                    <a href="${pageContext.request.contextPath}/view/reservation-details?id=<%= resId %>"
                                        class="btn btn-secondary">Back</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </body>

                </html>