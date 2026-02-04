package com.oceanview.dao;

import com.oceanview.model.User;
import com.oceanview.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {

    public User getUserByUsername(String username) {
        User user = null;
        String sql = "SELECT * FROM users WHERE username = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, username);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    user = mapResultSetToUser(rs);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return user;
    }

    public boolean updateSettings(int userId, boolean isDarkMode, boolean isEmailNotif, boolean isBrowserNotif) {
        String sql = "UPDATE users SET is_dark_mode = ?, is_email_notif = ?, is_browser_notif = ? WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setBoolean(1, isDarkMode);
            pstmt.setBoolean(2, isEmailNotif);
            pstmt.setBoolean(3, isBrowserNotif);
            pstmt.setInt(4, userId);

            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }

    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setCreatedAt(rs.getTimestamp("created_at"));

        // Settings
        // Handle potential nulls or missing columns gracefully if DB update failed
        // (though we ensure it)
        try {
            user.setDarkMode(rs.getBoolean("is_dark_mode"));
            user.setEmailNotif(rs.getBoolean("is_email_notif"));
            user.setBrowserNotif(rs.getBoolean("is_browser_notif"));
        } catch (SQLException e) {
            // If columns don't exist yet, defaults are fine (false/false/false)
        }

        return user;
    }
}
