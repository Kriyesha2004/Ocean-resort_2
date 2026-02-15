<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.oceanview.dao.UserDAO" %>
        <%@ page import="com.oceanview.dao.MessageDAO" %>
            <%@ page import="com.oceanview.model.User" %>
                <%@ page import="java.util.List" %>
                    <%@ page import="java.util.Map" %>
                        <% if (session.getAttribute("user_id")==null) { response.sendRedirect("index.jsp"); return; }
                            UserDAO userDAO=new UserDAO(); MessageDAO messageDAO=new MessageDAO(); List<User> users =
                            userDAO.getAllUsers();
                            List<Map<String, Object>> sentMessages = messageDAO.getAllSentMessages();
                                %>
                                <!DOCTYPE html>
                                <html>

                                <head>
                                    <meta charset="UTF-8">
                                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                    <title>Notices - Ocean View Resort</title>
                                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                                        rel="stylesheet">
                                    <link rel="stylesheet"
                                        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
                                    <link rel="stylesheet" href="css/style.css">
                                </head>

                                <body>
                                    <%@ include file="admin_navbar.jsp" %>

                                        <div class="container py-4">
                                            <div class="row">
                                                <!-- Send Message Column -->
                                                <div class="col-md-4">
                                                    <div class="card border-0 shadow-sm mb-4">
                                                        <div class="card-header bg-white border-bottom-0 pt-4 px-4">
                                                            <h4 class="card-title fw-bold"><i class="bi bi-send"></i>
                                                                Send Notice</h4>
                                                        </div>
                                                        <div class="card-body px-4 pb-4">
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

                                                                            <form action="send-message" method="post">
                                                                                <div class="mb-3">
                                                                                    <label
                                                                                        class="form-label">To:</label>
                                                                                    <select name="receiver_id"
                                                                                        class="form-select" required>
                                                                                        <option value="all">Everyone
                                                                                            (Broadcast)</option>
                                                                                        <% for (User u : users) { %>
                                                                                            <option
                                                                                                value="<%= u.getUserId() %>">
                                                                                                <%= u.getFullName() %>
                                                                                                    (@<%=
                                                                                                        u.getUsername()
                                                                                                        %>)
                                                                                            </option>
                                                                                            <% } %>
                                                                                    </select>
                                                                                </div>
                                                                                <div class="mb-3">
                                                                                    <label
                                                                                        class="form-label">Message:</label>
                                                                                    <textarea name="content"
                                                                                        class="form-control" rows="5"
                                                                                        required></textarea>
                                                                                </div>
                                                                                <button type="submit"
                                                                                    class="btn btn-primary w-100">Send
                                                                                    Message</button>
                                                                            </form>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Message History Column -->
                                                <div class="col-md-8">
                                                    <div class="card border-0 shadow-sm">
                                                        <div class="card-header bg-light border-bottom">
                                                            <h5 class="card-title mb-0">Sent Messages History</h5>
                                                        </div>
                                                        <div class="card-body p-0">
                                                            <div class="list-group list-group-flush">
                                                                <% if (sentMessages.isEmpty()) { %>
                                                                    <div
                                                                        class="list-group-item text-center py-4 text-muted">
                                                                        No messages sent yet.</div>
                                                                    <% } else { for (Map<String, Object> msg :
                                                                        sentMessages) { %>
                                                                        <div class="list-group-item bg-transparent">
                                                                            <div
                                                                                class="d-flex w-100 justify-content-between mb-1">
                                                                                <h6 class="mb-0 text-primary">
                                                                                    <% if
                                                                                        (msg.get("receiver_name")==null)
                                                                                        { %>
                                                                                        <i class="bi bi-broadcast"></i>
                                                                                        To: Everyone
                                                                                        <% } else { %>
                                                                                            <i class="bi bi-person"></i>
                                                                                            To: <%=
                                                                                                msg.get("receiver_name")
                                                                                                %>
                                                                                                <% } %>
                                                                                </h6>
                                                                                <small class="text-muted">
                                                                                    <%= msg.get("created_at") %>
                                                                                </small>
                                                                            </div>
                                                                            <p class="mb-1">
                                                                                <%= msg.get("content") %>
                                                                            </p>
                                                                        </div>
                                                                        <% } } %>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <script
                                            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                                </body>

                                </html>