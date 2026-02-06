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

@WebServlet("/api/notifications")
public class NotificationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            out.print("{\"error\": \"Unauthorized\"}");
            return;
        }

        // Check if user has notifications enabled
        Boolean isBrowserNotif = (Boolean) session.getAttribute("is_browser_notif");
        if (isBrowserNotif == null || !isBrowserNotif) {
            out.print("{\"count\": 0}");
            return;
        }

        // Get last seen reservation ID from session
        Integer lastSeenId = (Integer) session.getAttribute("last_seen_res_id");

        try (Connection conn = DBConnection.getConnection()) {
            if (lastSeenId == null) {
                // First check: just get the current max ID and don't notify
                String initSql = "SELECT MAX(res_id) FROM reservations";
                try (PreparedStatement pst = conn.prepareStatement(initSql); ResultSet rs = pst.executeQuery()) {
                    if (rs.next()) {
                        lastSeenId = rs.getInt(1);
                        if (rs.wasNull())
                            lastSeenId = 0; // Handle empty table
                    } else {
                        lastSeenId = 0;
                    }
                }
                session.setAttribute("last_seen_res_id", lastSeenId);
                out.print("{\"count\": 0}");
                return;
            }

            // Check for reservations with ID > lastSeenId
            String sql = "SELECT COUNT(*) as count, MAX(guest_name) as latest_guest, MAX(res_id) as max_id FROM reservations WHERE res_id > ?";

            try (PreparedStatement pst = conn.prepareStatement(sql)) {
                pst.setInt(1, lastSeenId);

                try (ResultSet rs = pst.executeQuery()) {
                    if (rs.next() && rs.getInt("count") > 0) {
                        int count = rs.getInt("count");
                        String latestGuest = rs.getString("latest_guest");
                        int newMaxId = rs.getInt("max_id");

                        if (latestGuest == null)
                            latestGuest = "";

                        // Update last seen ID
                        session.setAttribute("last_seen_res_id", newMaxId);

                        out.print(String.format("{\"count\": %d, \"latestGuest\": \"%s\"}", count, latestGuest));
                    } else {
                        out.print("{\"count\": 0}");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
}
