package com.oceanview.servlet;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;

import com.oceanview.util.DBConnection;
import javax.servlet.annotation.WebServlet;

@WebServlet("/api/reports")
public class ReportsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Ensure user is logged in
        HttpSession session = request.getSession();
        if (session.getAttribute("user_id") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Unauthorized");
            return;
        }

        String action = request.getParameter("action");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try (PrintWriter out = response.getWriter()) {
            if ("stats".equals(action)) {
                out.print(getStats());
            } else if ("chart".equals(action)) {
                String type = request.getParameter("type");
                String year = request.getParameter("year");
                out.print(getChartData(type, year));
            } else if ("bookings".equals(action)) {
                String year = request.getParameter("year");
                String month = request.getParameter("month"); // 1-12 or "all"
                out.print(getBookings(year, month));
            } else {
                out.print("{\"error\": \"Invalid action\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().print("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }

    private String getStats() throws SQLException, ClassNotFoundException {
        Connection conn = DBConnection.getConnection();
        int totalBookings = 0;
        double totalRevenue = 0.0;
        int checkedIn = 0;

        // Total Bookings
        PreparedStatement pst = conn.prepareStatement("SELECT COUNT(*) FROM reservations");
        ResultSet rs = pst.executeQuery();
        if (rs.next())
            totalBookings = rs.getInt(1);
        rs.close();
        pst.close();

        // Total Revenue
        pst = conn.prepareStatement("SELECT SUM(total_bill) FROM reservations");
        rs = pst.executeQuery();
        if (rs.next())
            totalRevenue = rs.getDouble(1);
        rs.close();
        pst.close();

        // Checked In
        pst = conn.prepareStatement("SELECT COUNT(*) FROM reservations WHERE status = 'Checked-In'");
        rs = pst.executeQuery();
        if (rs.next())
            checkedIn = rs.getInt(1);
        rs.close();
        pst.close();
        conn.close();

        return String.format("{\"totalBookings\": %d, \"totalRevenue\": %.2f, \"checkedIn\": %d}",
                totalBookings, totalRevenue, checkedIn);
    }

    private String getChartData(String type, String year) throws SQLException, ClassNotFoundException {
        Connection conn = DBConnection.getConnection();
        StringBuilder json = new StringBuilder();
        json.append("{");

        if ("monthly".equals(type)) {
            // Last 12 months or specific year? Let's do specific year (defaults to current
            // if null)
            if (year == null || year.isEmpty())
                year = "YEAR(CURDATE())";

            String sql = "SELECT MONTH(check_in) as m, SUM(total_bill) as rev FROM reservations " +
                    "WHERE YEAR(check_in) = " + year + " GROUP BY MONTH(check_in) ORDER BY m";
            PreparedStatement pst = conn.prepareStatement(sql);
            ResultSet rs = pst.executeQuery();

            // Initialize array for 12 months
            double[] months = new double[13];
            while (rs.next()) {
                months[rs.getInt("m")] = rs.getDouble("rev");
            }
            rs.close();
            pst.close();

            json.append(
                    "\"labels\": [\"Jan\", \"Feb\", \"Mar\", \"Apr\", \"May\", \"Jun\", \"Jul\", \"Aug\", \"Sep\", \"Oct\", \"Nov\", \"Dec\"],");
            json.append("\"data\": [");
            for (int i = 1; i <= 12; i++) {
                json.append(months[i]);
                if (i < 12)
                    json.append(",");
            }
            json.append("]");

        } else {
            // Yearly
            String sql = "SELECT YEAR(check_in) as y, SUM(total_bill) as rev FROM reservations " +
                    "GROUP BY YEAR(check_in) ORDER BY y";
            PreparedStatement pst = conn.prepareStatement(sql);
            ResultSet rs = pst.executeQuery();

            json.append("\"labels\": [");
            StringBuilder dataStr = new StringBuilder();
            boolean first = true;
            while (rs.next()) {
                if (!first) {
                    json.append(",");
                    dataStr.append(",");
                }
                json.append("\"").append(rs.getInt("y")).append("\"");
                dataStr.append(rs.getDouble("rev"));
                first = false;
            }
            json.append("],");
            json.append("\"data\": [").append(dataStr).append("]");
            rs.close();
            pst.close();
        }

        conn.close();
        json.append("}");
        return json.toString();
    }

    private String getBookings(String year, String month) throws SQLException, ClassNotFoundException {
        Connection conn = DBConnection.getConnection();
        StringBuilder json = new StringBuilder();
        json.append("[");

        String sql = "SELECT * FROM reservations WHERE 1=1";
        if (year != null && !year.isEmpty()) {
            sql += " AND YEAR(check_in) = " + year;
        }
        if (month != null && !month.isEmpty() && !month.equals("all")) {
            sql += " AND MONTH(check_in) = " + month;
        }
        sql += " ORDER BY check_in DESC";

        PreparedStatement pst = conn.prepareStatement(sql);
        ResultSet rs = pst.executeQuery();
        boolean first = true;
        while (rs.next()) {
            if (!first)
                json.append(",");
            json.append("{");
            json.append("\"id\": ").append(rs.getInt("res_id")).append(",");
            json.append("\"guestName\": \"").append(escape(rs.getString("guest_name"))).append("\",");
            json.append("\"roomType\": \"").append(rs.getString("room_type")).append("\",");
            json.append("\"checkIn\": \"").append(rs.getDate("check_in")).append("\",");
            json.append("\"checkOut\": \"").append(rs.getDate("check_out")).append("\",");
            json.append("\"totalBill\": ").append(rs.getDouble("total_bill")).append(",");
            json.append("\"status\": \"").append(rs.getString("status")).append("\"");
            json.append("}");
            first = false;
        }
        rs.close();
        pst.close();
        conn.close();

        json.append("]");
        return json.toString();
    }

    private String escape(String s) {
        if (s == null)
            return "";
        return s.replace("\"", "\\\"").replace("\n", " ");
    }
}
