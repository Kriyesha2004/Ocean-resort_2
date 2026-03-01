package com.oceanview.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;

import static org.mockito.Mockito.*;

/**
 * Unit tests for LogoutController
 * Tests session termination
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("Logout Controller Tests")
class LogoutControllerTest {

    private LogoutController logoutController;

    @Mock
    private HttpServletRequest mockRequest;

    @Mock
    private HttpServletResponse mockResponse;

    @Mock
    private HttpSession mockSession;

    @BeforeEach
    void setUp() {
        logoutController = new LogoutController();
    }

    @Test
    @DisplayName("GET should invalidate session and redirect to index")
    void testLogoutGetRequest() throws ServletException, IOException {
        when(mockRequest.getSession()).thenReturn(mockSession);

        logoutController.doGet(mockRequest, mockResponse);

        verify(mockSession).invalidate();
        verify(mockResponse).sendRedirect("index.jsp");
    }

    @Test
    @DisplayName("POST should call doGet method")
    void testLogoutPostRequest() throws ServletException, IOException {
        when(mockRequest.getSession()).thenReturn(mockSession);

        logoutController.doPost(mockRequest, mockResponse);

        verify(mockSession).invalidate();
        verify(mockResponse).sendRedirect("index.jsp");
    }
}
