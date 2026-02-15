package com.oceanview.servlet;

import com.oceanview.dao.MessageDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/send-message")
public class MessageServlet extends HttpServlet {

    private MessageDAO messageDAO = new MessageDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        int senderId = (int) session.getAttribute("user_id");
        String content = request.getParameter("content");
        String receiverIdStr = request.getParameter("receiver_id");

        if (content == null || content.trim().isEmpty()) {
            response.sendRedirect("admin-notices.jsp?error=Message content cannot be empty");
            return;
        }

        Integer receiverId = null;
        if (receiverIdStr != null && !receiverIdStr.equals("all") && !receiverIdStr.isEmpty()) {
            try {
                receiverId = Integer.parseInt(receiverIdStr);
            } catch (NumberFormatException e) {
                // broadcast
            }
        }

        if (messageDAO.createMessage(senderId, receiverId, content)) {
            response.sendRedirect("admin-notices.jsp?success=Message sent successfully");
        } else {
            response.sendRedirect("admin-notices.jsp?error=Failed to send message");
        }
    }
}
