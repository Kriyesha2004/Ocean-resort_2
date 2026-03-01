package com.oceanview.dao;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import com.oceanview.model.User;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Unit tests for UserDAO
 * Tests database operations for users
 */
@DisplayName("User DAO Tests")
class UserDAOTest {

    private UserDAO userDAO;

    @BeforeEach
    void setUp() {
        userDAO = new UserDAO();
    }

    @Test
    @DisplayName("Should retrieve admin user by username")
    void testGetUserByUsernameAdmin() {
        User user = userDAO.getUserByUsername("admin");
        
        assertNotNull(user, "Admin user should exist");
        assertEquals("admin", user.getUsername());
        assertEquals(1, user.getUserId());
    }

    @Test
    @DisplayName("Should return null for non-existent username")
    void testGetUserByUsernameNotFound() {
        User user = userDAO.getUserByUsername("nonexistent_user_xyz");
        
        assertNull(user, "Non-existent user should return null");
    }

    @Test
    @DisplayName("Should retrieve all users")
    void testGetAllUsers() {
        var users = userDAO.getAllUsers();
        
        assertNotNull(users, "Users list should not be null");
        assertTrue(users.size() > 0, "Should have at least one user (admin)");
    }

    @Test
    @DisplayName("Should update user settings")
    void testUpdateSettings() {
        int adminId = 1;
        boolean success = userDAO.updateSettings(adminId, true, true, false);
        
        assertTrue(success, "Settings update should succeed");
        
        User updatedUser = userDAO.getUserByUsername("admin");
        assertNotNull(updatedUser);
        assertTrue(updatedUser.isDarkMode());
    }

    @Test
    @DisplayName("Should add new user")
    void testAddUser() {
        User newUser = new User();
        newUser.setUsername("testuser");
        newUser.setPassword("test123");
        newUser.setFullName("Test User");
        newUser.setEmail("test@example.com");

        boolean success = userDAO.addUser(newUser);
        
        assertTrue(success, "User addition should succeed");
        
        // Verify the user was added
        User retrievedUser = userDAO.getUserByUsername("testuser");
        assertNotNull(retrievedUser, "Added user should be retrievable");
        assertEquals("Test User", retrievedUser.getFullName());
    }
}
