<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.util.List" %>
        <%@ page import="com.oceanview.model.Room" %>
            <%@ page import="com.oceanview.model.RoomType" %>
                <%@ page import="com.oceanview.dao.RoomDAO" %>
                    <%@ page import="com.oceanview.dao.RoomTypeDAO" %>
                        <% if (session.getAttribute("user_id")==null) { response.sendRedirect(request.getContextPath() + "/index.jsp"); return; }
                            RoomDAO roomDAO=new RoomDAO(); List<Room> rooms = roomDAO.getAllRooms();
                            RoomTypeDAO typeDAO = new RoomTypeDAO();
                            List<RoomType> roomTypes = typeDAO.getAllRoomTypes();
                                %>
                                <!DOCTYPE html>
                                <html>

                                <head>
                                    <meta charset="UTF-8">
                                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                    <title>Room Management - Ocean View Resort</title>
                                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                                        rel="stylesheet">
                                    <link rel="stylesheet"
                                        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
                                    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                                </head>

                                <body>
                                    <%@ include file="/WEB-INF/views/shared/admin_navbar.jsp" %>

                                        <div class="container py-5">
                                            <% if(session.getAttribute("successMsg") !=null) { %>
                                                <div class="alert alert-success alert-dismissible fade show"
                                                    role="alert">
                                                    <%= session.getAttribute("successMsg") %>
                                                        <button type="button" class="btn-close" data-bs-dismiss="alert"
                                                            aria-label="Close"></button>
                                                </div>
                                                <% session.removeAttribute("successMsg"); } %>

                                                    <% if(session.getAttribute("errorMsg") !=null) { %>
                                                        <div class="alert alert-danger alert-dismissible fade show"
                                                            role="alert">
                                                            <%= session.getAttribute("errorMsg") %>
                                                                <button type="button" class="btn-close"
                                                                    data-bs-dismiss="alert" aria-label="Close"></button>
                                                        </div>
                                                        <% session.removeAttribute("errorMsg"); } %>

                                                            <div
                                                                class="d-flex justify-content-between align-items-center mb-4">
                                                                <h1>Room Management</h1>
                                                                <button class="btn btn-primary" disabled>+ Add Room
                                                                    (Coming
                                                                    Soon)</button>
                                                            </div>

                                                            <!-- Tabs for Rooms and Categories -->
                                                            <ul class="nav nav-tabs mb-4" id="roomTabs" role="tablist">
                                                                <li class="nav-item" role="presentation">
                                                                    <button class="nav-link active" id="rooms-tab"
                                                                        data-bs-toggle="tab"
                                                                        data-bs-target="#rooms-pane" type="button"
                                                                        role="tab" aria-controls="rooms-pane"
                                                                        aria-selected="true">Individual Rooms</button>
                                                                </li>
                                                                <li class="nav-item" role="presentation">
                                                                    <button class="nav-link" id="types-tab"
                                                                        data-bs-toggle="tab"
                                                                        data-bs-target="#types-pane" type="button"
                                                                        role="tab" aria-controls="types-pane"
                                                                        aria-selected="false">Room Categories</button>
                                                                </li>
                                                            </ul>

                                                            <div class="tab-content" id="roomTabsContent">
                                                                <!-- Rooms Tab -->
                                                                <div class="tab-pane fade show active" id="rooms-pane"
                                                                    role="tabpanel" aria-labelledby="rooms-tab">
                                                                    <div class="card shadow-sm">
                                                                        <div class="card-body">
                                                                            <div class="table-responsive">
                                                                                <table class="table table-hover">
                                                                                    <thead class="table-light">
                                                                                        <tr>
                                                                                            <th>Room Number</th>
                                                                                            <th>Type</th>
                                                                                            <th>Status</th>
                                                                                            <th>Action</th>
                                                                                        </tr>
                                                                                    </thead>
                                                                                    <tbody>
                                                                                        <% for(Room room : rooms) { %>
                                                                                            <tr>
                                                                                                <td><strong>
                                                                                                        <%= room.getRoomNumber()
                                                                                                            %>
                                                                                                    </strong></td>
                                                                                                <td><span
                                                                                                        class="badge bg-info text-dark">
                                                                                                        <%= room.getRoomType()
                                                                                                            %>
                                                                                                    </span></td>
                                                                                                <td>
                                                                                                    <% if("Available".equals(room.getStatus()))
                                                                                                        { %>
                                                                                                        <span
                                                                                                            class="badge bg-success">Available</span>
                                                                                                        <% } else
                                                                                                            if("Booked".equals(room.getStatus()))
                                                                                                            { %>
                                                                                                            <span
                                                                                                                class="badge bg-danger">Booked</span>
                                                                                                            <% } else {
                                                                                                                %>
                                                                                                                <span
                                                                                                                    class="badge bg-warning text-dark">
                                                                                                                    <%= room.getStatus()
                                                                                                                        %>
                                                                                                                </span>
                                                                                                                <% } %>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <button
                                                                                                        class="btn btn-sm btn-outline-primary edit-room-btn"
                                                                                                        data-id="<%= room.getRoomId() %>"
                                                                                                        data-number="<%= room.getRoomNumber() %>"
                                                                                                        data-type="<%= room.getRoomType() %>"
                                                                                                        data-status="<%= room.getStatus() %>">
                                                                                                        <i
                                                                                                            class="bi bi-pencil"></i>
                                                                                                        Edit</button>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <% } %>
                                                                                    </tbody>
                                                                                </table>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>

                                                                <!-- Categories Tab -->
                                                                <div class="tab-pane fade" id="types-pane"
                                                                    role="tabpanel" aria-labelledby="types-tab">
                                                                    <div class="card shadow-sm">
                                                                        <div class="card-body">
                                                                            <div class="table-responsive">
                                                                                <table class="table table-hover">
                                                                                    <thead class="table-light">
                                                                                        <tr>
                                                                                            <th>Category Name</th>
                                                                                            <th>Price (Night)</th>
                                                                                            <th>Capacity</th>
                                                                                            <th>Photo</th>
                                                                                            <th>Action</th>
                                                                                        </tr>
                                                                                    </thead>
                                                                                    <tbody>
                                                                                        <% for(RoomType rt : roomTypes)
                                                                                            { %>
                                                                                            <tr>
                                                                                                <td><strong>
                                                                                                        <%= rt.getTypeName()
                                                                                                            %>
                                                                                                    </strong></td>
                                                                                                <td>$<%= String.format("%.2f",
                                                                                                        rt.getPrice())
                                                                                                        %>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <%= rt.getCapacity()
                                                                                                        %>
                                                                                                        Guests
                                                                                                </td>
                                                                                                <td>
                                                                                                    <img src="<%= rt.getImageUrl() %>"
                                                                                                        alt="<%= rt.getTypeName() %>"
                                                                                                        class="rounded"
                                                                                                        style="width: 50px; height: 50px; object-fit: cover;">
                                                                                                </td>
                                                                                                <td>
                                                                                                    <button
                                                                                                        class="btn btn-sm btn-outline-primary manage-type-btn"
                                                                                                        data-id="<%= rt.getTypeId() %>"
                                                                                                        data-name="<%= rt.getTypeName() %>"
                                                                                                        data-price="<%= rt.getPrice() %>"
                                                                                                        data-image="<%= rt.getImageUrl() %>"
                                                                                                        data-capacity="<%= rt.getCapacity() %>"
                                                                                                        data-description="<%= rt.getDescription() %>">
                                                                                                        <i
                                                                                                            class="bi bi-gear"></i>
                                                                                                        Manage</button>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <% } %>
                                                                                    </tbody>
                                                                                </table>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                        </div>

                                        <!-- Edit Room Modal -->
                                        <div class="modal fade" id="editRoomModal" tabindex="-1">
                                            <div class="modal-dialog">
                                                <div class="modal-content">
                                                    <form action="update-room" method="POST">
                                                        <div class="modal-header">
                                                            <h5 class="modal-title">Edit Room</h5>
                                                            <button type="button" class="btn-close"
                                                                data-bs-dismiss="modal"></button>
                                                        </div>
                                                        <div class="modal-body">
                                                            <input type="hidden" name="roomId" id="edit_roomId">
                                                            <div class="mb-3">
                                                                <label class="form-label">Room Number</label>
                                                                <input type="text" name="roomNumber"
                                                                    id="edit_roomNumber" class="form-control" required>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label class="form-label">Room Type</label>
                                                                <select name="roomType" id="edit_roomType"
                                                                    class="form-control">
                                                                    <% for(RoomType rt : roomTypes) { %>
                                                                        <option value="<%= rt.getTypeName() %>">
                                                                            <%= rt.getTypeName() %>
                                                                        </option>
                                                                        <% } %>
                                                                </select>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label class="form-label">Status</label>
                                                                <select name="status" id="edit_status"
                                                                    class="form-control">
                                                                    <option value="Available">Available</option>
                                                                    <option value="Booked">Booked</option>
                                                                    <option value="Maintenance">Maintenance</option>
                                                                </select>
                                                            </div>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-secondary"
                                                                data-bs-dismiss="modal">Cancel</button>
                                                            <button type="submit" class="btn btn-primary">Save
                                                                Changes</button>
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Edit Room Type Modal -->
                                        <div class="modal fade" id="editTypeModal" tabindex="-1">
                                            <div class="modal-dialog modal-lg">
                                                <div class="modal-content">
                                                    <form action="update-room-type" method="POST">
                                                        <div class="modal-header">
                                                            <h5 class="modal-title">Manage Room Category: <span
                                                                    id="editType_name_display"></span></h5>
                                                            <button type="button" class="btn-close"
                                                                data-bs-dismiss="modal"></button>
                                                        </div>
                                                        <div class="modal-body">
                                                            <input type="hidden" name="typeId" id="editType_id">
                                                            <div class="row">
                                                                <div class="col-md-6 mb-3">
                                                                    <label class="form-label">Price per Night
                                                                        ($)</label>
                                                                    <input type="number" step="0.01" name="price"
                                                                        id="editType_price" class="form-control"
                                                                        required>
                                                                </div>
                                                                <div class="col-md-6 mb-3">
                                                                    <label class="form-label">Capacity (Persons)</label>
                                                                    <input type="number" name="capacity"
                                                                        id="editType_capacity" class="form-control"
                                                                        required>
                                                                </div>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label class="form-label">Image URL</label>
                                                                <input type="text" name="imageUrl"
                                                                    id="editType_imageUrl" class="form-control"
                                                                    required>
                                                                <div class="form-text">Provide a direct link to the room
                                                                    photo.</div>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label class="form-label">Description</label>
                                                                <textarea name="description" id="editType_description"
                                                                    class="form-control" rows="4" required></textarea>
                                                            </div>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-secondary"
                                                                data-bs-dismiss="modal">Cancel</button>
                                                            <button type="submit" class="btn btn-primary">Update
                                                                Category</button>
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>

                                        <script
                                            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                                        <script>
                                            const roomModal = new bootstrap.Modal(document.getElementById('editRoomModal'));
                                            const typeModal = new bootstrap.Modal(document.getElementById('editTypeModal'));

                                            document.querySelectorAll('.edit-room-btn').forEach(btn => {
                                                btn.addEventListener('click', () => {
                                                    const data = btn.dataset;
                                                    document.getElementById('edit_roomId').value = data.id;
                                                    document.getElementById('edit_roomNumber').value = data.number;
                                                    document.getElementById('edit_roomType').value = data.type;
                                                    document.getElementById('edit_status').value = data.status;
                                                    roomModal.show();
                                                });
                                            });

                                            document.querySelectorAll('.manage-type-btn').forEach(btn => {
                                                btn.addEventListener('click', () => {
                                                    const data = btn.dataset;
                                                    document.getElementById('editType_id').value = data.id;
                                                    document.getElementById('editType_name_display').innerText = data.name;
                                                    document.getElementById('editType_price').value = data.price;
                                                    document.getElementById('editType_imageUrl').value = data.image;
                                                    document.getElementById('editType_capacity').value = data.capacity;
                                                    document.getElementById('editType_description').value = data.description;
                                                    typeModal.show();
                                                });
                                            });
                                        </script>
                                </body>

                                </html>