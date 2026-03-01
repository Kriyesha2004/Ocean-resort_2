package com.oceanview.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import com.oceanview.dao.UserDAO;
import com.oceanview.model.User;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;

import static org.mockito.Mockito.*;

/**
 * Unit tests for LoginController
 * Tests authentication and session management
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("Login Controller Tests")
class LoginControllerTest {

    private LoginController loginController;

    @Mock
    private HttpServletRequest mockRequest;

    @Mock
    private HttpServletResponse mockResponse;

    @Mock
    private HttpSession mockSession;

    @Mock
    private RequestDispatcher mockDispatcher;

    @Mock
    private UserDAO mockUserDAO;

    @BeforeEach
    void setUp() {
        loginController = new LoginController();
        when(mockRequest.getSession()).thenReturn(mockSession);
        when(mockRequest.getRequestDispatcher(anyString())).thenReturn(mockDispatcher);
    }

    @Test
    @DisplayName("GET request should redirect to index.jsp")
    void testDoGetRedirect() throws ServletException, IOException {
        loginController.doGet(mockRequest, mockResponse);
        verify(mockResponse).sendRedirect(contains("index.jsp"));
    }

    @Test
    @DisplayName("POST with empty username should show error")
    void testPostEmptyUsername() throws ServletException, IOException {
        when(mockRequest.getParameter("username")).thenReturn("");
        when(mockRequest.getParameter("password")).thenReturn("test123");

        loginController.doPost(mockRequest, mockResponse);

        verify(mockRequest).setAttribute(eq("error"), anyString());
        verify(mockDispatcher).forward(mockRequest, mockResponse);
    }

    @Test
    @DisplayName("POST with empty password should show error")
    void testPostEmptyPassword() throws ServletException, IOException {
        when(mockRequest.getParameter("username")).thenReturn("admin");
        when(mockRequest.getParameter("password")).thenReturn("");

        loginController.doPost(mockRequest, mockResponse);

        verify(mockRequest).setAttribute(eq("error"), anyString());
    }

    @Test
    @DisplayName("Valid admin credentials should set session attributes")
    void testValidAdminLogin() throws ServletException, IOException {
        when(mockRequest.getParameter("username")).thenReturn("admin");
        when(mockRequest.getParameter("password")).thenReturn("admin123");

        loginController.doPost(mockRequest, mockResponse);

        verify(mockSession).setAttribute(eq("user_id"), anyInt());
        verify(mockSession).setAttribute(eq("username"), eq("admin"));
        verify(mockResponse).sendRedirect(contains("admin_dashboard.jsp"));
    }

    @Test
    @DisplayName("Invalid credentials should show error message")
    void testInvalidCredentials() throws ServletException, IOException {
        when(mockRequest.getParameter("username")).thenReturn("invalid");
        when(mockRequest.getParameter("password")).thenReturn("wrong");

        loginController.doPost(mockRequest, mockResponse);

        verify(mockRequest).setAttribute(eq("error"), contains("Invalid"));
        verify(mockDispatcher).forward(mockRequest, mockResponse);
    }
}
