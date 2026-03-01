package com.oceanview.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import com.oceanview.util.DBConnection;

public class ReservationService {

    private com.oceanview.dao.RoomDAO roomDAO = new com.oceanview.dao.RoomDAO();

    public boolean isRoomAvailable(String roomType, LocalDate checkIn, LocalDate checkOut) throws Exception {
        com.oceanview.model.Room room = roomDAO.findAvailableRoom(roomType, java.sql.Date.valueOf(checkIn),
                java.sql.Date.valueOf(checkOut));
        return room != null;
    }

    public com.oceanview.model.Room findAvailableRoom(String roomType, LocalDate checkIn, LocalDate checkOut)
            throws Exception {
        return roomDAO.findAvailableRoom(roomType, java.sql.Date.valueOf(checkIn), java.sql.Date.valueOf(checkOut));
    }
}
