package com.oceanview.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import com.oceanview.util.DBConnection;

public class ReservationService {

    // Room Limits
    private static final int MAX_SINGLE_ROOMS = 10;
    private static final int MAX_DOUBLE_ROOMS = 8;
    private static final int MAX_LUXURY_ROOMS = 6;

    public boolean isRoomAvailable(String roomType, LocalDate checkIn, LocalDate checkOut) throws Exception {
        int maxRooms = 0;
        switch (roomType) {
            case "Single":
                maxRooms = MAX_SINGLE_ROOMS;
                break;
            case "Double":
                maxRooms = MAX_DOUBLE_ROOMS;
                break;
            case "Luxury":
                maxRooms = MAX_LUXURY_ROOMS;
                break;
            default:
                return false; // Invalid room type
        }

        Connection conn = DBConnection.getConnection();
        // Count overlapping reservations for this room type
        // Two time periods (StartA, EndA) and (StartB, EndB) overlap if:
        // StartA < EndB AND EndA > StartB
        String query = "SELECT COUNT(*) FROM reservations " +
                "WHERE room_type = ? " +
                "AND status IN ('Pending', 'Confirmed', 'Checked-In') " +
                "AND check_in < ? AND check_out > ?"; // Logic for overlapping dates

        PreparedStatement pst = conn.prepareStatement(query);
        pst.setString(1, roomType);
        pst.setDate(2, java.sql.Date.valueOf(checkOut)); // EndB (Requested Check-out)
        pst.setDate(3, java.sql.Date.valueOf(checkIn)); // StartB (Requested Check-in)

        ResultSet rs = pst.executeQuery();
        int bookedCount = 0;
        if (rs.next()) {
            bookedCount = rs.getInt(1);
        }

        rs.close();
        pst.close();
        // Note: DBConnection is not closed here as it is a singleton shared connection,
        // usually managed by the Servlet or a filter, but checking implementation it
        // seems we might need to be careful.
        // The DBConnection.getConnection returns a static connection? Checking
        // DBConnection.java...
        // ... It returns a singleton connection. We should NOT close it here if we want
        // to reuse it.
        // However, checking DBConnection.java usage in ReservationServlet, it doesn't
        // close it explicitly per request often.

        return bookedCount < maxRooms;
    }
}
