package com.oceanview.servlet;

import com.oceanview.dao.UserDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/settings")
public class SettingsServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        int userId = (int) session.getAttribute("user_id");

        // Parse checkboxes (checkboxes are null if unchecked)
        boolean isDarkMode = request.getParameter("darkMode") != null;
        boolean isEmailNotif = request.getParameter("emailNotif") != null;
        boolean isBrowserNotif = request.getParameter("browserNotif") != null;

        boolean success = userDAO.updateSettings(userId, isDarkMode, isEmailNotif, isBrowserNotif);

        if (success) {
            // Update session attributes so changes are reflected immediately
            session.setAttribute("is_dark_mode", isDarkMode);
            session.setAttribute("is_email_notif", isEmailNotif);
            session.setAttribute("is_browser_notif", isBrowserNotif);

            // Add a temporary success message
            session.setAttribute("message", "Settings updated successfully!");
        } else {
            session.setAttribute("error", "Failed to update settings.");
        }

        response.sendRedirect("settings.jsp");
    }
}
