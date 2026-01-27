package com.oceanview.servlet;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.*;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }
    
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
        
        // Hardcoded credentials for testing
        if ("admin".equals(username) && "admin123".equals(password)) {
            HttpSession session = request.getSession();
            session.setAttribute("user_id", 1);
            session.setAttribute("username", username);
            session.setAttribute("full_name", "Administrator");
            session.setMaxInactiveInterval(30 * 60);
            
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
        } else {
            request.setAttribute("error", "Invalid username or password.");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        }
    }
}
