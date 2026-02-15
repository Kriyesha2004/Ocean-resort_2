<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.oceanview.dao.UserDAO" %>
        <%@ page import="com.oceanview.model.User" %>
            <%@ page import="java.util.List" %>
                <% if (session.getAttribute("user_id")==null) { response.sendRedirect("index.jsp"); return; } // Ideally
                    check for admin role here too UserDAO userDAO=new UserDAO(); List<User> users =
                    userDAO.getAllUsers();
                    %>
                    <!DOCTYPE html>
                    <html>

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Manage Staff - Ocean View Resort</title>
                        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                            rel="stylesheet">
                        <link rel="stylesheet"
                            href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
                        <link rel="stylesheet" href="css/style.css">
                    </head>

                    <body>
                        <%@ include file="admin_navbar.jsp" %>

                            <div class="container py-4">
                                <div class="d-flex justify-content-between align-items-center mb-4">
                                    <h2><i class="bi bi-people"></i> Manage Staff</h2>
                                    <button class="btn btn-primary" data-bs-toggle="modal"
                                        data-bs-target="#addStaffModal">
                                        <i class="bi bi-plus-lg"></i> Add Staff
                                    </button>
                                </div>

                                <% if (request.getParameter("error") !=null) { %>
                                    <div class="alert alert-danger">
                                        <%= request.getParameter("error") %>
                                    </div>
                                    <% } %>
                                        <% if (request.getParameter("success") !=null) { %>
                                            <div class="alert alert-success">
                                                <%= request.getParameter("success") %>
                                            </div>
                                            <% } %>

                                                <div class="card border-0 shadow-sm">
                                                    <div class="card-body">
                                                        <div class="table-responsive">
                                                            <table class="table table-hover align-middle">
                                                                <thead class="table-light">
                                                                    <tr>
                                                                        <th>ID</th>
                                                                        <th>Username</th>
                                                                        <th>Full Name</th>
                                                                        <th>Email</th>
                                                                        <th>Actions</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                                    <% for (User u : users) { %>
                                                                        <tr>
                                                                            <td>
                                                                                <%= u.getUserId() %>
                                                                            </td>
                                                                            <td>@<%= u.getUsername() %>
                                                                            </td>
                                                                            <td>
                                                                                <%= u.getFullName() %>
                                                                            </td>
                                                                            <td>
                                                                                <%= u.getEmail() %>
                                                                            </td>
                                                                            <td>
                                                                                <button
                                                                                    class="btn btn-sm btn-outline-primary me-1"
                                                                                    onclick="editUser('<%= u.getUserId() %>', '<%= u.getUsername() %>', '<%= u.getFullName() %>', '<%= u.getEmail() %>')">
                                                                                    <i class="bi bi-pencil"></i>
                                                                                </button>
                                                                                <form action="staff-action"
                                                                                    method="post" class="d-inline"
                                                                                    onsubmit="return confirm('Are you sure you want to delete this user?');">
                                                                                    <input type="hidden" name="action"
                                                                                        value="delete">
                                                                                    <input type="hidden" name="user_id"
                                                                                        value="<%= u.getUserId() %>">
                                                                                    <button type="submit"
                                                                                        class="btn btn-sm btn-outline-danger">
                                                                                        <i class="bi bi-trash"></i>
                                                                                    </button>
                                                                                </form>
                                                                            </td>
                                                                        </tr>
                                                                        <% } %>
                                                                </tbody>
                                                            </table>
                                                        </div>
                                                    </div>
                                                </div>
                            </div>

                            <!-- Add Staff Modal -->
                            <div class="modal fade" id="addStaffModal" tabindex="-1">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <form action="staff-action" method="post">
                                            <div class="modal-header">
                                                <h5 class="modal-title">Add New Staff</h5>
                                                <button type="button" class="btn-close"
                                                    data-bs-dismiss="modal"></button>
                                            </div>
                                            <div class="modal-body">
                                                <input type="hidden" name="action" value="add">
                                                <div class="mb-3">
                                                    <label class="form-label">Username</label>
                                                    <input type="text" name="username" class="form-control" required>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">Full Name</label>
                                                    <input type="text" name="full_name" class="form-control" required>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">Email</label>
                                                    <input type="email" name="email" class="form-control" required>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">Password</label>
                                                    <input type="password" name="password" class="form-control"
                                                        required>
                                                </div>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary"
                                                    data-bs-dismiss="modal">Cancel</button>
                                                <button type="submit" class="btn btn-primary">Add Staff</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>

                            <!-- Edit Staff Modal -->
                            <div class="modal fade" id="editStaffModal" tabindex="-1">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <form action="staff-action" method="post">
                                            <div class="modal-header">
                                                <h5 class="modal-title">Edit Staff</h5>
                                                <button type="button" class="btn-close"
                                                    data-bs-dismiss="modal"></button>
                                            </div>
                                            <div class="modal-body">
                                                <input type="hidden" name="action" value="edit">
                                                <input type="hidden" name="user_id" id="edit_user_id">
                                                <div class="mb-3">
                                                    <label class="form-label">Username</label>
                                                    <input type="text" name="username" id="edit_username"
                                                        class="form-control" required>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">Full Name</label>
                                                    <input type="text" name="full_name" id="edit_full_name"
                                                        class="form-control" required>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">Email</label>
                                                    <input type="email" name="email" id="edit_email"
                                                        class="form-control" required>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">New Password (leave plain to
                                                        change)</label>
                                                    <input type="password" name="password" class="form-control"
                                                        placeholder="Enter new password">
                                                </div>
                                                <div class="form-text">Note: For security, enter the old password if not
                                                    changing, or implementing password change logic separately is
                                                    better. Here expecting full update.</div>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary"
                                                    data-bs-dismiss="modal">Cancel</button>
                                                <button type="submit" class="btn btn-primary">Update Staff</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>

                            <script
                                src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                            <script>
                                function editUser(id, username, fullName, email) {
                                    document.getElementById('edit_user_id').value = id;
                                    document.getElementById('edit_username').value = username;
                                    document.getElementById('edit_full_name').value = fullName;
                                    document.getElementById('edit_email').value = email;

                                    var editModal = new bootstrap.Modal(document.getElementById('editStaffModal'));
                                    editModal.show();
                                }
                            </script>
                    </body>

                    </html>