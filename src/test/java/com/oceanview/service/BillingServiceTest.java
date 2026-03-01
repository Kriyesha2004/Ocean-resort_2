package com.oceanview.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;

import java.time.LocalDate;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Unit tests for BillingService
 * Tests billing calculations
 */
@DisplayName("Billing Service Tests")
class BillingServiceTest {

    private BillingService billingService;

    @BeforeEach
    void setUp() {
        billingService = new BillingService();
    }

    @Test
    @DisplayName("Should calculate nights between check-in and check-out")
    void testCalculateNights() {
        LocalDate checkIn = LocalDate.of(2026, 3, 1);
        LocalDate checkOut = LocalDate.of(2026, 3, 5);

        long nights = billingService.calculateNights(checkIn, checkOut);

        assertEquals(4, nights, "Should calculate 4 nights");
    }

    @Test
    @DisplayName("Should return 1 night for consecutive days")
    void testCalculateNightsSingleNight() {
        LocalDate checkIn = LocalDate.of(2026, 3, 1);
        LocalDate checkOut = LocalDate.of(2026, 3, 2);

        long nights = billingService.calculateNights(checkIn, checkOut);

        assertEquals(1, nights, "Should calculate 1 night");
    }

    @Test
    @DisplayName("Should get correct rate per night for Single Room")
    void testGetRatePerNightSingleRoom() {
        double rate = billingService.getRatePerNight("Single Room");
        
        assertEquals(5000.0, rate, "Single Room should be 5000 per night");
    }

    @Test
    @DisplayName("Should get correct rate per night for Double Room")
    void testGetRatePerNightDoubleRoom() {
        double rate = billingService.getRatePerNight("Double Room");
        
        assertEquals(8500.0, rate, "Double Room should be 8500 per night");
    }

    @Test
    @DisplayName("Should get correct rate per night for Luxury Suite")
    void testGetRatePerNightLuxurySuite() {
        double rate = billingService.getRatePerNight("Luxury Suite");
        
        assertEquals(15000.0, rate, "Luxury Suite should be 15000 per night");
    }

    @ParameterizedTest
    @ValueSource(ints = {1, 2, 3, 5, 10})
    @DisplayName("Should calculate bill correctly for various night counts")
    void testCalculateBillParameterized(int nights) {
        LocalDate checkIn = LocalDate.of(2026, 3, 1);
        LocalDate checkOut = checkIn.plusDays(nights);

        double bill = billingService.calculateBill(checkIn, checkOut, "Single Room");
        double expected = nights * 5000.0;

        assertEquals(expected, bill, "Bill calculation should be nights * rate");
    }

    @Test
    @DisplayName("Should calculate bill for 2-night Double Room stay")
    void testCalculateBillDoubleRoom() {
        LocalDate checkIn = LocalDate.of(2026, 3, 1);
        LocalDate checkOut = LocalDate.of(2026, 3, 3); // 2 nights

        double bill = billingService.calculateBill(checkIn, checkOut, "Double Room");
        double expected = 2 * 8500.0; // 17000

        assertEquals(expected, bill, "Should calculate 17000 for 2 nights at 8500/night");
    }

    @Test
    @DisplayName("Should calculate bill for 7-night Luxury Suite stay")
    void testCalculateBillLuxurySuite() {
        LocalDate checkIn = LocalDate.of(2026, 3, 1);
        LocalDate checkOut = LocalDate.of(2026, 3, 8); // 7 nights

        double bill = billingService.calculateBill(checkIn, checkOut, "Luxury Suite");
        double expected = 7 * 15000.0; // 105000

        assertEquals(expected, bill, "Should calculate 105000 for 7 nights at 15000/night");
    }
}
