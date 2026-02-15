<%@ page import="java.sql.*" %>
    <%@ page import="com.oceanview.util.DBConnection" %>
        <% try { Connection conn=DBConnection.getConnection(); Statement stmt=conn.createStatement(); String
            sql="CREATE TABLE IF NOT EXISTS messages (" + "id INT AUTO_INCREMENT PRIMARY KEY,"
            + "sender_id INT NOT NULL," + "receiver_id INT DEFAULT NULL," + "content TEXT NOT NULL,"
            + "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,"
            + "FOREIGN KEY (sender_id) REFERENCES users(user_id) ON DELETE CASCADE,"
            + "FOREIGN KEY (receiver_id) REFERENCES users(user_id) ON DELETE SET NULL" + ")" ; stmt.executeUpdate(sql);
            out.println("Table 'messages' created successfully."); conn.close(); } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        e.printStackTrace(new java.io.PrintWriter(out));
    }
%>