package com.oceanview.controller;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import com.oceanview.dao.RoomDAO;
import com.oceanview.model.Room;

/**
 * AddRoomController - Handles addition of new rooms.
 */
@WebServlet("/add-room")
public class AddRoomController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        try {
            String roomNumber = request.getParameter("roomNumber");
            String roomType = request.getParameter("roomType");
            String status = request.getParameter("status");

            Room room = new Room();
            room.setRoomNumber(roomNumber);
            room.setRoomType(roomType);
            room.setStatus(status);

            RoomDAO roomDAO = new RoomDAO();
            roomDAO.addRoom(room);

            session.setAttribute("successMsg", "Room " + roomNumber + " added successfully.");
        } catch (Exception e) {
            session.setAttribute("errorMsg", "Error adding room: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/view/admin-rooms");
    }
}
