package com.oceanview.dto;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Data Transfer Object for User.
 * Used to transfer user data between layers without exposing domain models.
 */
public class UserDTO implements Serializable {
    private static final long serialVersionUID = 1L;

    private int userId;
    private String username;
    private String password;
    private String fullName;
    private String email;
    private Timestamp createdAt;

    // Settings
    private boolean isDarkMode;
    private boolean isEmailNotif;
    private boolean isBrowserNotif;

    // Constructors
    public UserDTO() {
    }

    public UserDTO(int userId, String username, String fullName, String email,
            boolean isDarkMode, boolean isEmailNotif, boolean isBrowserNotif) {
        this.userId = userId;
        this.username = username;
        this.fullName = fullName;
        this.email = email;
        this.isDarkMode = isDarkMode;
        this.isEmailNotif = isEmailNotif;
        this.isBrowserNotif = isBrowserNotif;
    }

    // Getters and Setters
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public boolean isDarkMode() {
        return isDarkMode;
    }

    public void setDarkMode(boolean isDarkMode) {
        this.isDarkMode = isDarkMode;
    }

    public boolean isEmailNotif() {
        return isEmailNotif;
    }

    public void setEmailNotif(boolean isEmailNotif) {
        this.isEmailNotif = isEmailNotif;
    }

    public boolean isBrowserNotif() {
        return isBrowserNotif;
    }

    public void setBrowserNotif(boolean isBrowserNotif) {
        this.isBrowserNotif = isBrowserNotif;
    }
}
