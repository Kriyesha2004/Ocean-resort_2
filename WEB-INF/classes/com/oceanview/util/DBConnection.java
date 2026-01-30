package com.oceanview.util;

import java.sql.*;

/**
 * DBConnection - Singleton Pattern for Database Connection Management
 * Ensures a single database connection is maintained across the application
 */
public class DBConnection {
    private static Connection connection = null;

    private DBConnection() {
        // Private constructor to prevent instantiation
    }

    /**
     * Get database connection using Singleton pattern
     * 
     * @return Connection object
     * @throws SQLException           if database connection fails
     * @throws ClassNotFoundException if MySQL driver is not found
     */
    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        if (connection == null || connection.isClosed()) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                connection = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/ocean_view_db?useSSL=false&allowPublicKeyRetrieval=true",
                        "root",
                        "");
                System.out.println("Database connection established successfully.");
            } catch (SQLException e) {
                System.err.println("Failed to establish database connection: " + e.getMessage());
                throw e;
            }
        }
        return connection;
    }

    /**
     * Close database connection
     */
    public static void closeConnection() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
                System.out.println("Database connection closed.");
            }
        } catch (SQLException e) {
            System.err.println("Error closing connection: " + e.getMessage());
        }
    }
}
