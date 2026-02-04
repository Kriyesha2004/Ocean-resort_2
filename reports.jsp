<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <% if (session.getAttribute("user_id")==null) { response.sendRedirect("index.jsp"); return; } %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Reports - Ocean View Resort</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="css/style.css">

            <!-- React & ReactDOM -->
            <script crossorigin src="https://unpkg.com/react@18/umd/react.development.js"></script>
            <script crossorigin src="https://unpkg.com/react-dom@18/umd/react-dom.development.js"></script>

            <!-- Babel for JSX -->
            <script src="https://unpkg.com/@babel/standalone/babel.min.js"></script>

            <!-- Chart.js -->
            <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

            <!-- SheetJS -->
            <script src="https://cdn.sheetjs.com/xlsx-latest/package/dist/xlsx.full.min.js"></script>

            <!-- Docx & FileSaver -->
            <script src="https://unpkg.com/docx@7.1.0/build/index.js"></script>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/2.0.5/FileSaver.min.js"></script>
        </head>

        <body>
            <%@ include file="navbar.jsp" %>

                <div id="root" class="container-fluid py-4">
                    <!-- React App mounts here -->
                    <div class="text-center mt-5">
                        <div class="spinner-border text-primary" role="status">
                            <span class="visually-hidden">Loading...</span>
                        </div>
                    </div>
                </div>

                <!-- Main Application Logic -->
                <script type="text/babel" src="js/reports.js"></script>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>