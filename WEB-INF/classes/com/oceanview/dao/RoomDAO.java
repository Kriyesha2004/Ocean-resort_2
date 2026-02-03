package com.oceanview.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.oceanview.model.Room;
import com.oceanview.util.DBConnection;

public class RoomDAO {

    public List<Room> getAllRooms() throws Exception {
        List<Room> rooms = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        String query = "SELECT * FROM rooms ORDER BY room_number";
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(query);

        while (rs.next()) {
            Room room = new Room();
            room.setRoomId(rs.getInt("room_id"));
            room.setRoomNumber(rs.getString("room_number"));
            room.setRoomType(rs.getString("room_type"));
            room.setStatus(rs.getString("status"));
            rooms.add(room);
        }
        rs.close();
        stmt.close();
        return rooms;
    }

    public Room getRoomById(int roomId) throws Exception {
        Room room = null;
        Connection conn = DBConnection.getConnection();
        String query = "SELECT * FROM rooms WHERE room_id = ?";
        PreparedStatement pst = conn.prepareStatement(query);
        pst.setInt(1, roomId);
        ResultSet rs = pst.executeQuery();

        if (rs.next()) {
            room = new Room();
            room.setRoomId(rs.getInt("room_id"));
            room.setRoomNumber(rs.getString("room_number"));
            room.setRoomType(rs.getString("room_type"));
            room.setStatus(rs.getString("status"));
        }
        rs.close();
        pst.close();
        return room;
    }

    // Find available room for specific dates and type
    public Room findAvailableRoom(String roomType, Date checkIn, Date checkOut) throws Exception {
        Room availableRoom = null;
        Connection conn = DBConnection.getConnection();

        // Query to find a room of valid type that has NO overlapping reservations
        // AND is not in 'Maintenance' status
        String query = "SELECT r.* FROM rooms r " +
                "WHERE r.room_type = ? " +
                "AND r.status != 'Maintenance' " +
                "AND r.room_id NOT IN (" +
                "SELECT res.room_id FROM reservations res " +
                "WHERE res.status IN ('Pending', 'Confirmed', 'Checked-In') " +
                "AND res.room_id IS NOT NULL " +
                "AND res.check_in < ? AND res.check_out > ?" +
                ") LIMIT 1";

        PreparedStatement pst = conn.prepareStatement(query);
        pst.setString(1, roomType);
        pst.setDate(2, checkOut); // Overlap logic: Req.Start < Existing.End
        pst.setDate(3, checkIn); // Overlap logic: Req.End > Existing.Start

        ResultSet rs = pst.executeQuery();
        if (rs.next()) {
            availableRoom = new Room();
            availableRoom.setRoomId(rs.getInt("room_id"));
            availableRoom.setRoomNumber(rs.getString("room_number"));
            availableRoom.setRoomType(rs.getString("room_type"));
            availableRoom.setStatus(rs.getString("status"));
        }

        rs.close();
        pst.close();
        return availableRoom;
    }
}
