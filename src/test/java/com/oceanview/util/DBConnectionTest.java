package com.oceanview.util;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.sql.Connection;
import java.sql.SQLException;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Unit tests for DBConnection
 * Tests database connection
 */
@DisplayName("Database Connection Tests")
class DBConnectionTest {

    @BeforeEach
    void setUp() {
        // Database should be running for these tests
    }

    @Test
    @DisplayName("Should establish database connection")
    void testGetConnection() throws ClassNotFoundException, SQLException {
        Connection conn = DBConnection.getConnection();
        
        assertNotNull(conn, "Database connection should not be null");
    }

    @Test
    @DisplayName("Should return active connection")
    void testConnectionIsValid() throws ClassNotFoundException, SQLException {
        Connection conn = DBConnection.getConnection();
        
        assertNotNull(conn, "Connection should be established");
        assertFalse(conn.isClosed(), "Connection should be open");
    }

    @Test
    @DisplayName("Should handle multiple connection requests")
    void testMultipleConnections() throws ClassNotFoundException, SQLException {
        Connection conn1 = DBConnection.getConnection();
        Connection conn2 = DBConnection.getConnection();
        
        assertNotNull(conn1, "First connection should be valid");
        assertNotNull(conn2, "Second connection should be valid");
    }
}
