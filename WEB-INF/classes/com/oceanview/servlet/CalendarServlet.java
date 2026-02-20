package com.oceanview.servlet;

import com.oceanview.util.DBConnection;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/api/calendar")
public class CalendarServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"error\": \"Unauthorized\"}");
            return;
        }

        StringBuilder json = new StringBuilder("[");

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT r.guest_name, r.check_in, r.check_out, r.status, rm.room_number " +
                    "FROM reservations r " +
                    "LEFT JOIN rooms rm ON r.room_id = rm.room_id";

            try (PreparedStatement pst = conn.prepareStatement(sql); ResultSet rs = pst.executeQuery()) {
                boolean first = true;
                while (rs.next()) {
                    java.sql.Date checkInDate = rs.getDate("check_in");
                    java.sql.Date checkOutDate = rs.getDate("check_out");

                    if (checkInDate == null || checkOutDate == null)
                        continue;

                    if (!first)
                        json.append(",");

                    String guestName = rs.getString("guest_name");
                    String roomNumber = rs.getString("room_number");
                    String status = rs.getString("status");
                    String checkIn = checkInDate.toString();
                    // FullCalendar end date is exclusive, so we add 1 day to show it until the
                    // checkout day
                    java.time.LocalDate endLocal = checkOutDate.toLocalDate().plusDays(1);
                    String checkOut = endLocal.toString();

                    String title = "Room " + (roomNumber != null ? roomNumber : "N/A") + " - " + guestName;

                    // Color coding
                    String color = "#3788d8"; // Default blue
                    if ("Confirmed".equalsIgnoreCase(status) || "Booked".equalsIgnoreCase(status)) {
                        color = "#198754"; // Green
                    } else if ("Checked-In".equalsIgnoreCase(status)) {
                        color = "#0dcaf0"; // Cyan
                    } else if ("Pending".equalsIgnoreCase(status)) {
                        color = "#ffc107"; // Yellow
                    } else if ("Cancelled".equalsIgnoreCase(status)) {
                        color = "#dc3545"; // Red
                    }

                    json.append("{");
                    json.append("\"title\": \"").append(escapeJson(title)).append("\",");
                    json.append("\"start\": \"").append(checkIn).append("\",");
                    json.append("\"end\": \"").append(checkOut).append("\",");
                    json.append("\"color\": \"").append(color).append("\",");
                    json.append("\"allDay\": true");
                    json.append("}");

                    first = false;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"" + escapeJson(e.getMessage()) + "\"}");
            return;
        }

        json.append("]");
        out.print(json.toString());
    }

    private String escapeJson(String str) {
        if (str == null)
            return "";
        return str.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\b", "\\b")
                .replace("\f", "\\f")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}
