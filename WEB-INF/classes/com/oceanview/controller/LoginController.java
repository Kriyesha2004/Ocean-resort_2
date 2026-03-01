package com.oceanview.controller;

import javax.servlet.*;
import javax.servlet.http.*;
import com.oceanview.dao.UserDAO;
import com.oceanview.model.User;
import javax.servlet.annotation.WebServlet;
import java.io.*;

/**
 * LoginController - Handles user authentication and session management.
 * Refactored from servlet package to follow MVC architecture.
 */
@WebServlet("/login")
public class LoginController extends HttpServlet {

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

        UserDAO userDAO = new UserDAO();
        User user = null;

        // First check hardcoded admin (legacy support or bootstrap)
        if ("admin".equalsIgnoreCase(username) && "admin123".equals(password)) {
            // Try to fetch admin from DB to get settings, if exists
            user = userDAO.getUserByUsername("admin");
            if (user == null) {
                // Fallback if admin not in DB yet (though SQL script adds it)
                user = new User();
                user.setUserId(1);
                user.setUsername("admin");
                user.setFullName("Administrator");
                user.setDarkMode(false); // defaults
                user.setEmailNotif(true);
                user.setBrowserNotif(true);
            }
            // Admin specific redirect flag
            request.getSession().setAttribute("is_admin", true);
        } else {
            // Try to authenticate against DB
            User dbUser = userDAO.getUserByUsername(username);
            if (dbUser != null && dbUser.getPassword().equals(password)) {
                user = dbUser;
            }
        }

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user_id", user.getUserId());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("full_name", user.getFullName());

            // Set settings in session
            session.setAttribute("is_dark_mode", user.isDarkMode());
            session.setAttribute("is_email_notif", user.isEmailNotif());
            session.setAttribute("is_browser_notif", user.isBrowserNotif());

            session.setMaxInactiveInterval(30 * 60);

            if (session.getAttribute("is_admin") != null && (Boolean) session.getAttribute("is_admin")) {
                request.getRequestDispatcher("/WEB-INF/views/admin/admin_dashboard.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/WEB-INF/views/user/dashboard.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("error", "Invalid username or password.");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        }
    }
}
