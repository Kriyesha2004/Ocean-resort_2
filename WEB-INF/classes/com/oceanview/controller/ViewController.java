package com.oceanview.controller;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * ViewController - Routes view requests to JSP files inside WEB-INF/views/.
 * This controller ensures JSPs are not directly accessible by URL (MVC
 * security),
 * while still allowing navigation links to work via clean URLs.
 */
@WebServlet(urlPatterns = {
        "/view/dashboard",
        "/view/reservation",
        "/view/reservations-list",
        "/view/reservation-details",
        "/view/reservation-edit",
        "/view/reports",
        "/view/settings",
        "/view/profile",
        "/view/admin-dashboard",
        "/view/admin-rooms",
        "/view/admin-staff",
        "/view/admin-notices",
        "/view/home",
        "/view/booking",
        "/view/booking-success"
})
public class ViewController extends HttpServlet {

    private static final Map<String, String> VIEW_MAP = new HashMap<>();

    static {
        // User views
        VIEW_MAP.put("/view/dashboard", "/WEB-INF/views/user/dashboard.jsp");
        VIEW_MAP.put("/view/reservation", "/WEB-INF/views/user/reservation.jsp");
        VIEW_MAP.put("/view/reservations-list", "/WEB-INF/views/user/reservations-list.jsp");
        VIEW_MAP.put("/view/reservation-details", "/WEB-INF/views/user/reservation-details.jsp");
        VIEW_MAP.put("/view/reservation-edit", "/WEB-INF/views/user/reservation-edit.jsp");
        VIEW_MAP.put("/view/reports", "/WEB-INF/views/user/reports.jsp");
        VIEW_MAP.put("/view/settings", "/WEB-INF/views/user/settings.jsp");
        VIEW_MAP.put("/view/profile", "/WEB-INF/views/user/profile.jsp");

        // Admin views
        VIEW_MAP.put("/view/admin-dashboard", "/WEB-INF/views/admin/admin_dashboard.jsp");
        VIEW_MAP.put("/view/admin-rooms", "/WEB-INF/views/admin/admin-rooms.jsp");
        VIEW_MAP.put("/view/admin-staff", "/WEB-INF/views/admin/admin-staff.jsp");
        VIEW_MAP.put("/view/admin-notices", "/WEB-INF/views/admin/admin-notices.jsp");

        // Public views
        VIEW_MAP.put("/view/home", "/WEB-INF/views/public/home.jsp");
        VIEW_MAP.put("/view/booking", "/WEB-INF/views/public/booking.jsp");
        VIEW_MAP.put("/view/booking-success", "/WEB-INF/views/public/booking-success.jsp");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        String jspPath = VIEW_MAP.get(path);

        if (jspPath != null) {
            // Forward any query parameters along with the request
            request.getRequestDispatcher(jspPath).forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "View not found");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
