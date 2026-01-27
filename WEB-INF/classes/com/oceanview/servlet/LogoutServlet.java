package com.oceanview.servlet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;

/**
 * LogoutServlet - Handles user logout
 * Invalidates session and redirects to login page
 */
public class LogoutServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        session.invalidate();
        response.sendRedirect("index.jsp");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
