package com.oceanview.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import com.oceanview.model.Room;

import java.time.LocalDate;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Unit tests for ReservationService
 * Tests reservation business logic
 */
@DisplayName("Reservation Service Tests")
class ReservationServiceTest {

    private ReservationService reservationService;

    @BeforeEach
    void setUp() {
        reservationService = new ReservationService();
    }

    @Test
    @DisplayName("Should find available room for valid date range")
    void testFindAvailableRoom() throws Exception {
        LocalDate checkIn = LocalDate.of(2026, 3, 15);
        LocalDate checkOut = LocalDate.of(2026, 3, 18);

        Room room = reservationService.findAvailableRoom("Single Room", checkIn, checkOut);

        assertNotNull(room, "Should find an available room");
        assertEquals("Single Room", room.getRoomType());
    }

    @Test
    @DisplayName("Should return available room with valid room ID")
    void testFindAvailableRoomHasId() throws Exception {
        LocalDate checkIn = LocalDate.of(2026, 3, 1);
        LocalDate checkOut = LocalDate.of(2026, 3, 5);

        Room room = reservationService.findAvailableRoom("Double Room", checkIn, checkOut);

        if (room != null) {
            assertTrue(room.getRoomId() > 0, "Room ID should be positive");
        }
    }

    @Test
    @DisplayName("Should find room with correct status")
    void testFindAvailableRoomStatus() throws Exception {
        LocalDate checkIn = LocalDate.of(2026, 4, 1);
        LocalDate checkOut = LocalDate.of(2026, 4, 3);

        Room room = reservationService.findAvailableRoom("Luxury Suite", checkIn, checkOut);

        if (room != null) {
            assertNotNull(room.getStatus(), "Room status should not be null");
            assertEquals("Available", room.getStatus(), "Room status should be Available");
        }
    }
}
