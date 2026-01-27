package com.oceanview.service;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.math.BigDecimal;

/**
 * BillingService - Handles all billing calculations for reservations
 * Implements room rate calculations and total bill computation
 */
public class BillingService {
    
    // Room rates per night (in currency units)
    private static final double SINGLE_ROOM_RATE = 5000.00;
    private static final double DOUBLE_ROOM_RATE = 8500.00;
    private static final double LUXURY_ROOM_RATE = 15000.00;
    
    /**
     * Calculate the rate per night based on room type
     * @param roomType The type of room (Single, Double, Luxury)
     * @return Daily rate for the room type
     */
    public double getRatePerNight(String roomType) {
        if (roomType == null) return 0;
        
        switch (roomType.toLowerCase()) {
            case "single":
                return SINGLE_ROOM_RATE;
            case "double":
                return DOUBLE_ROOM_RATE;
            case "luxury":
                return LUXURY_ROOM_RATE;
            default:
                return 0;
        }
    }
    
    /**
     * Calculate number of nights between check-in and check-out dates
     * @param checkInDate Check-in date
     * @param checkOutDate Check-out date
     * @return Number of nights
     */
    public long calculateNights(LocalDate checkInDate, LocalDate checkOutDate) {
        if (checkInDate == null || checkOutDate == null) return 0;
        if (checkOutDate.isBefore(checkInDate)) return 0;
        
        return ChronoUnit.DAYS.between(checkInDate, checkOutDate);
    }
    
    /**
     * Calculate total bill for a reservation
     * @param nights Number of nights
     * @param roomType Type of room
     * @return Total bill amount
     */
    public double calculateBill(long nights, String roomType) {
        double rate = getRatePerNight(roomType);
        return nights * rate;
    }
    
    /**
     * Calculate total bill using date parameters
     * @param checkInDate Check-in date
     * @param checkOutDate Check-out date
     * @param roomType Type of room
     * @return Total bill amount
     */
    public double calculateBill(LocalDate checkInDate, LocalDate checkOutDate, String roomType) {
        long nights = calculateNights(checkInDate, checkOutDate);
        return calculateBill(nights, roomType);
    }
    
    /**
     * Calculate bill with additional charges (service tax, etc.)
     * @param nights Number of nights
     * @param roomType Type of room
     * @param taxPercentage Tax percentage to apply
     * @return Total bill including tax
     */
    public double calculateBillWithTax(long nights, String roomType, double taxPercentage) {
        double baseBill = calculateBill(nights, roomType);
        double tax = baseBill * (taxPercentage / 100.0);
        return baseBill + tax;
    }
    
    /**
     * Format bill amount to 2 decimal places
     * @param amount Bill amount
     * @return Formatted amount
     */
    public String formatBill(double amount) {
        return String.format("%.2f", amount);
    }
    
    /**
     * Get room rate description for display
     * @param roomType Type of room
     * @return Formatted rate string
     */
    public String getRateDescription(String roomType) {
        return roomType + " Room: $" + formatBill(getRatePerNight(roomType)) + " per night";
    }
}
