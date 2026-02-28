<%@ page import="java.sql.*" %>
    <%@ page import="com.oceanview.util.DBConnection" %>
        <%@ page contentType="text/html;charset=UTF-8" language="java" %>
            <!DOCTYPE html>
            <html>

            <head>
                <title>Database Migration</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            </head>

            <body>
                <div class="container mt-5">
                    <h1>Database Migration Status</h1>
                    <div class="card">
                        <div class="card-body">
                            <pre><%
                    Connection conn = null;
                    Statement stmt = null;
                    try {
                        conn = DBConnection.getConnection();
                        conn.setAutoCommit(false);
                        stmt = conn.createStatement();
                        
                        out.println("Starting migration...");

                        // 1. Create room_types table
                        String createRoomTypes = "CREATE TABLE IF NOT EXISTS room_types (" +
                                "type_id INT PRIMARY KEY AUTO_INCREMENT, " +
                                "type_name VARCHAR(50) UNIQUE NOT NULL, " +
                                "price DECIMAL(10, 2) NOT NULL, " +
                                "description TEXT, " +
                                "image_url VARCHAR(255), " +
                                "capacity INT DEFAULT 1)";
                        stmt.executeUpdate(createRoomTypes);
                        out.println("✓ Table 'room_types' checked/created.");

                        // 2. Create rooms table
                        String createRooms = "CREATE TABLE IF NOT EXISTS rooms (" +
                                "room_id INT PRIMARY KEY AUTO_INCREMENT, " +
                                "room_number VARCHAR(10) UNIQUE NOT NULL, " +
                                "room_type VARCHAR(50) NOT NULL, " + // Changed from ENUM to VARCHAR for flexibility
                                "status ENUM('Available', 'Booked', 'Maintenance') DEFAULT 'Available')";
                        stmt.executeUpdate(createRooms);
                        out.println("✓ Table 'rooms' checked/created.");

                        // 3. Seed Room Types (Only if empty)
                        ResultSet rsTypeCount = stmt.executeQuery("SELECT COUNT(*) FROM room_types");
                        rsTypeCount.next();
                        if (rsTypeCount.getInt(1) == 0) {
                            out.println("Seeding initial room types...");
                            stmt.addBatch("INSERT INTO room_types (type_name, price, description, image_url, capacity) VALUES " +
                                "('Single', 5000.00, 'Perfect for solo travelers or business trips. Enjoy a cozy atmosphere with all modern amenities and a beautiful garden view.', 'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 1)");
                            stmt.addBatch("INSERT INTO room_types (type_name, price, description, image_url, capacity) VALUES " +
                                "('Double', 8500.00, 'Ideal for couples or friends. Spacious room with a king-size bed, private balcony, and stunning ocean views. Includes a mini-bar and premium toiletries.', 'https://images.unsplash.com/photo-1611892440504-42a792e24d32?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 2)");
                            stmt.addBatch("INSERT INTO room_types (type_name, price, description, image_url, capacity) VALUES " +
                                "('Luxury', 15000.00, 'The ultimate experience. Expansive suite with separate living area, jacuzzi, and premium concierge service. Enjoy panoramic views and exclusive access to the VIP lounge.', 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', 4)");
                            stmt.executeBatch();
                            out.println("✓ Seeded 3 room types.");
                        }
                        rsTypeCount.close();

                        // 4. Add room_id to reservations if not exists
                        // Check if column exists first to avoid error on re-run
                        DatabaseMetaData md = conn.getMetaData();
                        ResultSet rs = md.getColumns(null, null, "reservations", "room_id");
                        if (!rs.next()) {
                            String alterReservations = "ALTER TABLE reservations ADD COLUMN room_id INT";
                            stmt.executeUpdate(alterReservations);
                            out.println("✓ Column 'room_id' added to 'reservations'.");
                            
                            String addFK = "ALTER TABLE reservations ADD CONSTRAINT fk_room FOREIGN KEY (room_id) REFERENCES rooms(room_id)";
                            stmt.executeUpdate(addFK);
                            out.println("✓ Foreign key constraint added.");
                        } else {
                            out.println("- Column 'room_id' already exists in 'reservations'.");
                        }
                        rs.close();

                        // 5. Seed Data (Only if empty)
                        ResultSet rsRooms = stmt.executeQuery("SELECT COUNT(*) FROM rooms");
                        rsRooms.next();
                        if (rsRooms.getInt(1) == 0) {
                            out.println("Seeding initial rooms...");
                            // Single Rooms (101-105)
                            for(int i=101; i<=105; i++) {
                                stmt.addBatch("INSERT INTO rooms (room_number, room_type) VALUES ('"+i+"', 'Single')");
                            }
                            // Double Rooms (201-208)
                            for(int i=201; i<=208; i++) {
                                stmt.addBatch("INSERT INTO rooms (room_number, room_type) VALUES ('"+i+"', 'Double')");
                            }
                            // Luxury Rooms (301-306)
                            for(int i=301; i<=306; i++) {
                                stmt.addBatch("INSERT INTO rooms (room_number, room_type) VALUES ('"+i+"', 'Luxury')");
                            }
                            int[] updates = stmt.executeBatch();
                            out.println("✓ Seeded " + updates.length + " rooms.");
                        } else {
                            out.println("- Rooms table already has data. Skipping seed.");
                        }
                        rsRooms.close();

                        conn.commit();
                        out.println("\nSUCCESS: Migration completed successfully!");
                        
                    } catch (Exception e) {
                        try { if(conn != null) conn.rollback(); } catch(Exception ex) {}
                        out.println("\nERROR: " + e.getMessage());
                        e.printStackTrace(new java.io.PrintWriter(out));
                    } finally {
                        // Singleton connection - do not close
                    }
                    %>
                </pre>
                            <div class="mt-3">
                                <a href="index.jsp" class="btn btn-primary">Go to Home</a>
                                <a href="admin-rooms.jsp" class="btn btn-secondary">Go to Room Management</a>
                            </div>
                        </div>
                    </div>
                </div>
            </body>

            </html>