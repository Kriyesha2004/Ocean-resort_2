package com.oceanview.servlet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;
import com.oceanview.util.DBConnection;

/**
 * LoginServlet - Handles user authentication
 * Validates username and password against the users table
 */
public class LoginServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        response.setContentType("text/html;charset=UTF-8");
        
        if (username == null || username.isEmpty() || password == null || password.isEmpty()) {
            request.setAttribute("error", "Username and password are required.");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
            return;
        }
        
        try {
            Connection conn = DBConnection.getConnection();
            String query = "SELECT user_id, full_name FROM users WHERE username = ? AND password = ?";
            PreparedStatement pst = conn.prepareStatement(query);
            pst.setString(1, username);
            pst.setString(2, password);
            
            ResultSet rs = pst.executeQuery();
            
            if (rs.next()) {
                // Authentication successful
                HttpSession session = request.getSession();
                session.setAttribute("user_id", rs.getInt("user_id"));
                session.setAttribute("username", username);
                session.setAttribute("full_name", rs.getString("full_name"));
                session.setMaxInactiveInterval(30 * 60); // 30 minutes session timeout
                
                response.sendRedirect("dashboard.jsp");
            } else {
                // Authentication failed
                request.setAttribute("error", "Invalid username or password.");
                request.getRequestDispatcher("/index.jsp").forward(request, response);
            }
            
            rs.close();
            pst.close();
            
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        }
    }
}
