<%@ page import="java.util.List" %>
<%@ page import="lk.ijse.shopweb.UserDTO" %> <!-- Corrected import -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>User List</title>
    <!-- Bootstrap for basic styling -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body {
            background-color: #f8f9fa;
            font-family: Arial, sans-serif;
        }

        h1 {
            color: #007bff;
            margin-bottom: 30px;
            text-align: center;
        }

        table {
            margin: 0 auto;
            border-radius: 10px;
            border-collapse: collapse;
            width: 80%;
        }

        th, td {
            padding: 12px 20px;
            text-align: left;
            border: 1px solid #ddd;
        }

        th {
            background-color: #007bff;
            color: white;
        }

        tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        tr:hover {
            background-color: #f1f1f1;
        }

        .table-container {
            margin-top: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
            overflow: hidden;
        }

        .no-users {
            text-align: center;
            color: #6c757d;
            font-size: 18px;
        }

        .back-btn {
            display: block;
            width: 150px;
            margin: 20px auto;
            text-align: center;
            padding: 10px 15px;
            background-color: #007bff;
            color: white;
            border-radius: 5px;
            text-decoration: none;
        }

        .back-btn:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
<h1>User List</h1>

<div class="table-container">
    <%
        // Retrieve users list from request attribute
        List<UserDTO> users = (List<UserDTO>) request.getAttribute("users");

        // Check if users are available and display accordingly
        if (users != null && !users.isEmpty()) {
    %>
    <table class="table table-striped table-bordered">
        <thead>
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Email</th>
            <th>Phone</th>
            <th>Address</th>
            <th>Role</th>
        </tr>
        </thead>
        <tbody>
        <%
            // Loop through users and display their details
            for (UserDTO user : users) {
        %>
        <tr>
            <td><%= user.getId() %></td>
            <td><%= user.getName() %></td>
            <td><%= user.getEmail() %></td>
            <td><%= user.getPhone() %></td>
            <td><%= user.getAddress() %></td>
            <td><%= user.getRole() %></td>
        </tr>
        <%
            }
        %>
        </tbody>
    </table>
    <%
    } else {
    %>
    <p class="no-users">No users found.</p>
    <%
        }
    %>
</div>

<a href="admin.jsp" class="back-btn">Back to Admin Dashboard</a>
</body>
</html>
