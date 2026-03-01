package com.oceanview.controller;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import com.oceanview.dao.RoomTypeDAO;
import com.oceanview.model.RoomType;

/**
 * UpdateRoomTypeController - Handles room type update operations.
 * Manages room type details like pricing, capacity, and descriptions.
 * Refactored from servlet package to follow MVC architecture.
 */
@WebServlet("/update-room-type")
public class UpdateRoomTypeController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        try {
            int typeId = Integer.parseInt(request.getParameter("typeId"));
            double price = Double.parseDouble(request.getParameter("price"));
            String description = request.getParameter("description");
            String imageUrl = request.getParameter("imageUrl");
            int capacity = Integer.parseInt(request.getParameter("capacity"));

            RoomTypeDAO typeDAO = new RoomTypeDAO();
            RoomType targetType = typeDAO.getRoomTypeById(typeId);

            if (targetType != null) {
                targetType.setPrice(price);
                targetType.setDescription(description);
                targetType.setImageUrl(imageUrl);
                targetType.setCapacity(capacity);
                typeDAO.updateRoomType(targetType);
                session.setAttribute("successMsg", "Room category updated successfully.");
            } else {
                session.setAttribute("errorMsg", "Room category not found.");
            }
        } catch (Exception e) {
            session.setAttribute("errorMsg", "Error updating room category: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/view/admin-rooms");
    }
}
