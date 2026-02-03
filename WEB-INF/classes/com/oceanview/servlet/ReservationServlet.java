package com.oceanview.servlet;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.*;
import java.sql.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import com.oceanview.util.DBConnection;
import com.oceanview.service.BillingService;
import com.oceanview.service.ReservationService;

@WebServlet("/reservation")
public class ReservationServlet extends HttpServlet {

    private BillingService billingService = new BillingService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("create".equals(action)) {
            // Staff creating reservation - requires login
            HttpSession session = request.getSession();
            if (session.getAttribute("user_id") == null) {
                response.sendRedirect("index.jsp");
                return;
            }
            createReservation(request, response, (Integer) session.getAttribute("user_id"), false);
        } else if ("public_booking".equals(action)) {
            // Guest creating reservation - no login required
            createReservation(request, response, null, true);
        } else if ("update".equals(action)) {
            updateReservation(request, response);
        } else if ("delete".equals(action)) {
            deleteReservation(request, response);
        } else if ("update_status".equals(action)) {
            updateStatus(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }

    private void createReservation(HttpServletRequest request, HttpServletResponse response, Integer userId,
            boolean isPublic)
            throws ServletException, IOException {

        try {
            String guestName = request.getParameter("guest_name");
            String address = request.getParameter("address");
            String contactNo = request.getParameter("contact_no");
            String email = request.getParameter("email");
            String roomType = request.getParameter("room_type");
            String checkInStr = request.getParameter("check_in");
            String checkOutStr = request.getParameter("check_out");

            String errorPage = isPublic ? "/booking.jsp" : "/reservation.jsp";

            // Validate input
            if (guestName == null || guestName.isEmpty() || roomType == null ||
                    checkInStr == null || checkOutStr == null) {
                request.setAttribute("error", "All required fields must be filled.");
                request.getRequestDispatcher(errorPage).forward(request, response);
                return;
            }

            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            LocalDate checkInDate = LocalDate.parse(checkInStr, formatter);
            LocalDate checkOutDate = LocalDate.parse(checkOutStr, formatter);

            // Validate dates
            if (checkOutDate.isBefore(checkInDate)) {
                request.setAttribute("error", "Check-out date cannot be before check-in date.");
                request.getRequestDispatcher(errorPage).forward(request, response);
                return;
            }

            // NEW: Check Availability AND Allocation
            ReservationService resService = new ReservationService();
            com.oceanview.model.Room allocatedRoom = resService.findAvailableRoom(roomType, checkInDate, checkOutDate);

            if (allocatedRoom == null) {
                request.setAttribute("error", "Sorry, no " + roomType + " rooms are available for the selected dates.");
                request.getRequestDispatcher(errorPage).forward(request, response);
                return;
            }

            // Calculate bill
            double totalBill = billingService.calculateBill(checkInDate, checkOutDate, roomType);
            long nights = billingService.calculateNights(checkInDate, checkOutDate);

            // Insert reservation into database
            Connection conn = DBConnection.getConnection();
            String query = "INSERT INTO reservations (guest_name, address, contact_no, email, room_type, check_in, check_out, total_bill, status, created_by, room_id) "
                    +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'Pending', ?, ?)";

            PreparedStatement pst = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
            pst.setString(1, guestName);
            pst.setString(2, address);
            pst.setString(3, contactNo);
            pst.setString(4, email);
            pst.setString(5, roomType);
            pst.setDate(6, java.sql.Date.valueOf(checkInDate));
            pst.setDate(7, java.sql.Date.valueOf(checkOutDate));
            pst.setDouble(8, totalBill);

            if (userId != null) {
                pst.setInt(9, userId);
            } else {
                pst.setNull(9, java.sql.Types.INTEGER);
            }
            pst.setInt(10, allocatedRoom.getRoomId());

            int affectedRows = pst.executeUpdate();

            if (affectedRows > 0) {
                // Get the generated reservation ID
                ResultSet rs = pst.getGeneratedKeys();
                if (rs.next()) {
                    int resId = rs.getInt(1);

                    // Insert billing record
                    String billingQuery = "INSERT INTO billing (res_id, nights, room_type, rate_per_night, total_bill) "
                            +
                            "VALUES (?, ?, ?, ?, ?)";
                    PreparedStatement billingPst = conn.prepareStatement(billingQuery);
                    billingPst.setInt(1, resId);
                    billingPst.setLong(2, nights);
                    billingPst.setString(3, roomType);
                    billingPst.setDouble(4, billingService.getRatePerNight(roomType));
                    billingPst.setDouble(5, totalBill);
                    billingPst.executeUpdate();

                    request.setAttribute("success", "Reservation created successfully!");
                    request.setAttribute("reservationId", resId);
                    request.setAttribute("totalBill", String.format("%.2f", totalBill));
                    request.setAttribute("nights", nights);

                    if (isPublic) {
                        request.getRequestDispatcher("/booking-success.jsp").forward(request, response);
                    } else {
                        request.getRequestDispatcher("/reservations-list.jsp").forward(request, response);
                    }
                }
                rs.close();
            }

            pst.close();

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error creating reservation: " + e.getMessage());
            request.getRequestDispatcher(isPublic ? "/booking.jsp" : "/reservation.jsp").forward(request, response);
        }
    }

    private void updateReservation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int resId = Integer.parseInt(request.getParameter("id"));
            String guestName = request.getParameter("guest_name");
            String address = request.getParameter("address");
            String contactNo = request.getParameter("contact_no");
            String email = request.getParameter("email");
            String roomType = request.getParameter("room_type");
            LocalDate checkInDate = LocalDate.parse(request.getParameter("check_in"));
            LocalDate checkOutDate = LocalDate.parse(request.getParameter("check_out"));

            // Re-calculate bill if room or dates changed
            double totalBill = billingService.calculateBill(checkInDate, checkOutDate, roomType);

            Connection conn = DBConnection.getConnection();
            String query = "UPDATE reservations SET guest_name=?, address=?, contact_no=?, email=?, room_type=?, check_in=?, check_out=?, total_bill=? WHERE res_id=?";

            PreparedStatement pst = conn.prepareStatement(query);
            pst.setString(1, guestName);
            pst.setString(2, address);
            pst.setString(3, contactNo);
            pst.setString(4, email);
            pst.setString(5, roomType);
            pst.setDate(6, java.sql.Date.valueOf(checkInDate));
            pst.setDate(7, java.sql.Date.valueOf(checkOutDate));
            pst.setDouble(8, totalBill);
            pst.setInt(9, resId);

            pst.executeUpdate();
            pst.close();
            conn.close();

            request.setAttribute("success", "Reservation updated successfully!");
            request.getRequestDispatcher("/reservations-list.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error updating reservation: " + e.getMessage());
            request.getRequestDispatcher("/reservations-list.jsp").forward(request, response);
        }
    }

    private void deleteReservation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int resId = Integer.parseInt(request.getParameter("id"));

            Connection conn = DBConnection.getConnection();

            // Delete billing first due to foreign key
            String deleteBilling = "DELETE FROM billing WHERE res_id=?";
            PreparedStatement pstBill = conn.prepareStatement(deleteBilling);
            pstBill.setInt(1, resId);
            pstBill.executeUpdate();
            pstBill.close();

            // Delete reservation
            String query = "DELETE FROM reservations WHERE res_id=?";
            PreparedStatement pst = conn.prepareStatement(query);
            pst.setInt(1, resId);
            pst.executeUpdate();
            pst.close();
            conn.close();

            request.setAttribute("success", "Reservation deleted successfully!");
            request.getRequestDispatcher("/reservations-list.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error deleting reservation: " + e.getMessage());
            request.getRequestDispatcher("/reservations-list.jsp").forward(request, response);
        }
    }

    private void updateStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int resId = Integer.parseInt(request.getParameter("id"));
            String newStatus = request.getParameter("new_status");

            Connection conn = DBConnection.getConnection();
            String query = "UPDATE reservations SET status=? WHERE res_id=?";
            PreparedStatement pst = conn.prepareStatement(query);
            pst.setString(1, newStatus);
            pst.setInt(2, resId);
            pst.executeUpdate();
            pst.close();
            conn.close();

            response.sendRedirect("reservation-details.jsp?id=" + resId);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("reservations-list.jsp?error=Error updating status");
        }
    }
}
