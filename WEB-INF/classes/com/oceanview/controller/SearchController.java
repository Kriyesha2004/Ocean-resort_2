package com.oceanview.controller;

import javax.servlet.*;
import javax.servlet.http.*;
import com.oceanview.util.DBConnection;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.annotation.WebServlet;
import java.sql.Date;

@WebServlet("/api/search")
public class SearchController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String checkIn = request.getParameter("check_in");
        String checkOut = request.getParameter("check_out");
        String roomType = request.getParameter("room_type");

        if (checkIn == null || checkOut == null || roomType == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\": \"Missing parameters\"}");
            return;
        }

        try {
            Connection conn = DBConnection.getConnection();

            // Simple overlap logic: check_in < requestedCheckOut AND check_out >
            // requestedCheckIn
            String sql = "SELECT room_number FROM rooms " +
                    "WHERE room_type = ? " +
                    "AND status != 'Maintenance' " +
                    "AND room_id NOT IN (" +
                    "  SELECT room_id FROM reservations " +
                    "  WHERE status IN ('Pending', 'Confirmed', 'Checked-In') " +
                    "  AND check_in < ? AND check_out > ?" +
                    ")";

            PreparedStatement pst = conn.prepareStatement(sql);
            pst.setString(1, roomType);
            pst.setDate(2, Date.valueOf(checkOut));
            pst.setDate(3, Date.valueOf(checkIn));

            ResultSet rs = pst.executeQuery();

            StringBuilder roomNumbers = new StringBuilder();
            int count = 0;
            while (rs.next()) {
                if (count > 0)
                    roomNumbers.append(", ");
                roomNumbers.append(rs.getString("room_number"));
                count++;
            }

            out.print("{");
            out.print("\"available\": " + (count > 0) + ",");
            out.print("\"count\": " + count + ",");
            out.print("\"roomNumbers\": \"" + roomNumbers.toString() + "\",");
            out.print("\"message\": \""
                    + (count > 0 ? "Rooms available: " + roomNumbers : "No rooms available for selected dates") + "\"");
            out.print("}");

            rs.close();
            pst.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }
}
