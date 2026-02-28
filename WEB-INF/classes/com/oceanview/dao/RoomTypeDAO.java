package com.oceanview.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.oceanview.model.RoomType;
import com.oceanview.util.DBConnection;

public class RoomTypeDAO {

    public List<RoomType> getAllRoomTypes() throws Exception {
        List<RoomType> types = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        String query = "SELECT * FROM room_types";
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(query);

        while (rs.next()) {
            RoomType type = new RoomType();
            type.setTypeId(rs.getInt("type_id"));
            type.setTypeName(rs.getString("type_name"));
            type.setPrice(rs.getDouble("price"));
            type.setDescription(rs.getString("description"));
            type.setImageUrl(rs.getString("image_url"));
            type.setCapacity(rs.getInt("capacity"));
            types.add(type);
        }
        rs.close();
        stmt.close();
        return types;
    }

    public RoomType getRoomTypeByName(String typeName) throws Exception {
        RoomType type = null;
        Connection conn = DBConnection.getConnection();
        String query = "SELECT * FROM room_types WHERE type_name = ?";
        PreparedStatement pst = conn.prepareStatement(query);
        pst.setString(1, typeName);
        ResultSet rs = pst.executeQuery();

        if (rs.next()) {
            type = new RoomType();
            type.setTypeId(rs.getInt("type_id"));
            type.setTypeName(rs.getString("type_name"));
            type.setPrice(rs.getDouble("price"));
            type.setDescription(rs.getString("description"));
            type.setImageUrl(rs.getString("image_url"));
            type.setCapacity(rs.getInt("capacity"));
        }
        rs.close();
        pst.close();
        return type;
    }

    public RoomType getRoomTypeById(int typeId) throws Exception {
        RoomType type = null;
        Connection conn = DBConnection.getConnection();
        String query = "SELECT * FROM room_types WHERE type_id = ?";
        PreparedStatement pst = conn.prepareStatement(query);
        pst.setInt(1, typeId);
        ResultSet rs = pst.executeQuery();

        if (rs.next()) {
            type = new RoomType();
            type.setTypeId(rs.getInt("type_id"));
            type.setTypeName(rs.getString("type_name"));
            type.setPrice(rs.getDouble("price"));
            type.setDescription(rs.getString("description"));
            type.setImageUrl(rs.getString("image_url"));
            type.setCapacity(rs.getInt("capacity"));
        }
        rs.close();
        pst.close();
        return type;
    }

    public void updateRoomType(RoomType type) throws Exception {
        Connection conn = DBConnection.getConnection();
        String query = "UPDATE room_types SET price = ?, description = ?, image_url = ?, capacity = ? WHERE type_id = ?";
        PreparedStatement pst = conn.prepareStatement(query);
        pst.setDouble(1, type.getPrice());
        pst.setString(2, type.getDescription());
        pst.setString(3, type.getImageUrl());
        pst.setInt(4, type.getCapacity());
        pst.setInt(5, type.getTypeId());
        pst.executeUpdate();
        pst.close();
    }
}
