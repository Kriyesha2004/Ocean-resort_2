package com.oceanview.controller;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import com.oceanview.dao.RoomDAO;
import com.oceanview.model.Room;

/**
 * UpdateRoomController - Handles room update operations.
 * Manages room details, status, and room type modifications.
 * Refactored from servlet package to follow MVC architecture.
 */
@WebServlet("/update-room")
public class UpdateRoomController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("user_id") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        try {
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            String roomNumber = request.getParameter("roomNumber");
            String roomType = request.getParameter("roomType");
            String status = request.getParameter("status");

            RoomDAO roomDAO = new RoomDAO();
            Room room = roomDAO.getRoomById(roomId);
            if (room != null) {
                room.setRoomNumber(roomNumber);
                room.setRoomType(roomType);
                room.setStatus(status);
                roomDAO.updateRoom(room);
                session.setAttribute("successMsg", "Room " + roomNumber + " updated successfully.");
            } else {
                session.setAttribute("errorMsg", "Room not found.");
            }
        } catch (Exception e) {
            session.setAttribute("errorMsg", "Error updating room: " + e.getMessage());
        }
        response.sendRedirect("admin-rooms.jsp");
    }
}
