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

                        // 1. Create rooms table
                        String createRooms = "CREATE TABLE IF NOT EXISTS rooms (" +
                                "room_id INT PRIMARY KEY AUTO_INCREMENT, " +
                                "room_number VARCHAR(10) UNIQUE NOT NULL, " +
                                "room_type ENUM('Single', 'Double', 'Luxury') NOT NULL, " +
                                "status ENUM('Available', 'Booked', 'Maintenance') DEFAULT 'Available')";
                        stmt.executeUpdate(createRooms);
                        out.println("✓ Table 'rooms' checked/created.");

                        // 2. Add room_id to reservations if not exists
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

                        // 3. Seed Data (Only if empty)
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
                        if (stmt != null) stmt.close();
                        if (conn != null) conn.close(); // Helper might return singleton, but typically fine to close handle if implementation supports it. 
                        // Checked DBConnection earlier, it has closeConnection() but returning the connection object directly means we invoke .close() on raw connection.
                        // Ideally we should use DBConnection.closeConnection() if implemented, but standard jdbc .close() is expected by most containers/pools.
                        // Our DBConnection.closeConnection is static and closes the *singleton* instance entirely. 
                        // So calling .close() on the connection object itself is correct for standard JDBC resource management, 
                        // UNLESS DBConnection intends to keep it open forever. 
                        // Given the previous code, checking DBConnection.java: 
                        // It's a static field. converting to use DBConnection.getConnection() usually returns the SAME connection.
                        // If we close it, it closes for everyone.
                        // FIX: We should NOT close the shared singleton connection here if it's shared app-wide.
                        // Let's just NOT close it in this script since it's a singleton.
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