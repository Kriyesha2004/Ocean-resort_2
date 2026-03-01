package com.oceanview.controller;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import com.oceanview.dao.RoomDAO;

/**
 * DeleteRoomController - Handles room deletion operations.
 */
@WebServlet("/delete-room")
public class DeleteRoomController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        try {
            int roomId = Integer.parseInt(request.getParameter("roomId"));

            RoomDAO roomDAO = new RoomDAO();
            roomDAO.deleteRoom(roomId);

            session.setAttribute("successMsg", "Room deleted successfully.");
        } catch (Exception e) {
            session.setAttribute("errorMsg", "Error deleting room: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/view/admin-rooms");
    }
}
