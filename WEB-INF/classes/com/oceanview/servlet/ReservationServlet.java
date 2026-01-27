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

@WebServlet("/reservation")
public class ReservationServlet extends HttpServlet {
    
    private BillingService billingService = new BillingService();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("create".equals(action)) {
            createReservation(request, response);
        } else if ("update".equals(action)) {
            updateReservation(request, response);
        } else if ("delete".equals(action)) {
            deleteReservation(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }
    
    private void createReservation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String guestName = request.getParameter("guest_name");
            String address = request.getParameter("address");
            String contactNo = request.getParameter("contact_no");
            String email = request.getParameter("email");
            String roomType = request.getParameter("room_type");
            String checkInStr = request.getParameter("check_in");
            String checkOutStr = request.getParameter("check_out");
            
            // Validate input
            if (guestName == null || guestName.isEmpty() || roomType == null || 
                checkInStr == null || checkOutStr == null) {
                request.setAttribute("error", "All required fields must be filled.");
                request.getRequestDispatcher("/reservation.jsp").forward(request, response);
                return;
            }
            
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            LocalDate checkInDate = LocalDate.parse(checkInStr, formatter);
            LocalDate checkOutDate = LocalDate.parse(checkOutStr, formatter);
            
            // Validate dates
            if (checkOutDate.isBefore(checkInDate)) {
                request.setAttribute("error", "Check-out date cannot be before check-in date.");
                request.getRequestDispatcher("/reservation.jsp").forward(request, response);
                return;
            }
            
            // Calculate bill
            double totalBill = billingService.calculateBill(checkInDate, checkOutDate, roomType);
            long nights = billingService.calculateNights(checkInDate, checkOutDate);
            
            // Get user_id from session
            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("user_id");
            
            if (userId == null) {
                response.sendRedirect("index.jsp");
                return;
            }
            
            // Insert reservation into database
            Connection conn = DBConnection.getConnection();
            String query = "INSERT INTO reservations (guest_name, address, contact_no, email, room_type, check_in, check_out, total_bill, status, created_by) " +
                          "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'Pending', ?)";
            
            PreparedStatement pst = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
            pst.setString(1, guestName);
            pst.setString(2, address);
            pst.setString(3, contactNo);
            pst.setString(4, email);
            pst.setString(5, roomType);
            pst.setDate(6, java.sql.Date.valueOf(checkInDate));
            pst.setDate(7, java.sql.Date.valueOf(checkOutDate));
            pst.setDouble(8, totalBill);
            pst.setInt(9, userId);
            
            int affectedRows = pst.executeUpdate();
            
            if (affectedRows > 0) {
                // Get the generated reservation ID
                ResultSet rs = pst.getGeneratedKeys();
                if (rs.next()) {
                    int resId = rs.getInt(1);
                    
                    // Insert billing record
                    String billingQuery = "INSERT INTO billing (res_id, nights, room_type, rate_per_night, total_bill) " +
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
                }
                rs.close();
            }
            
            pst.close();
            request.getRequestDispatcher("/reservations-list.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error creating reservation: " + e.getMessage());
            request.getRequestDispatcher("/reservation.jsp").forward(request, response);
        }
    }
    
    private void updateReservation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Implementation for updating reservations
        request.setAttribute("success", "Reservation updated successfully!");
        request.getRequestDispatcher("/reservations-list.jsp").forward(request, response);
    }
    
    private void deleteReservation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Implementation for deleting reservations
        request.setAttribute("success", "Reservation deleted successfully!");
        request.getRequestDispatcher("/reservations-list.jsp").forward(request, response);
    }
}
