package com.oceanview.dao;

import com.oceanview.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class MessageDAO {

    public boolean createMessage(int senderId, Integer receiverId, String content) {
        String sql = "INSERT INTO messages (sender_id, receiver_id, content) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, senderId);
            if (receiverId == null) {
                pstmt.setNull(2, java.sql.Types.INTEGER);
            } else {
                pstmt.setInt(2, receiverId);
            }
            pstmt.setString(3, content);

            return pstmt.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Map<String, Object>> getMessagesForUser(int userId) {
        List<Map<String, Object>> messages = new ArrayList<>();
        // Get generic broadcasts (receiver_id IS NULL) OR personal messages
        String sql = "SELECT m.*, u.full_name as sender_name FROM messages m " +
                "JOIN users u ON m.sender_id = u.user_id " +
                "WHERE m.receiver_id IS NULL OR m.receiver_id = ? " +
                "ORDER BY m.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> msg = new HashMap<>();
                    msg.put("id", rs.getInt("id"));
                    msg.put("content", rs.getString("content"));
                    msg.put("sender_name", rs.getString("sender_name"));
                    msg.put("created_at", rs.getTimestamp("created_at"));
                    msg.put("is_broadcast", rs.getObject("receiver_id") == null);
                    messages.add(msg);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return messages;
    }

    public List<Map<String, Object>> getAllSentMessages() {
        List<Map<String, Object>> messages = new ArrayList<>();
        String sql = "SELECT m.*, u.full_name as receiver_name FROM messages m " +
                "LEFT JOIN users u ON m.receiver_id = u.user_id " +
                "ORDER BY m.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql);
                ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> msg = new HashMap<>();
                msg.put("id", rs.getInt("id"));
                msg.put("content", rs.getString("content"));
                msg.put("receiver_name", rs.getString("receiver_name")); // Null if broadcast
                msg.put("created_at", rs.getTimestamp("created_at"));
                messages.add(msg);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return messages;
    }
}
