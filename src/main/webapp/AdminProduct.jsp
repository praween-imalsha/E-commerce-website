<%@ page import="java.sql.*, javax.naming.*, javax.sql.DataSource" %>
<%@ page import="java.math.BigDecimal" %>
<%
    Connection connection = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        // Get connection from the connection pool
        Context ctx = new InitialContext();
        DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/ecommerceshop");
        connection = ds.getConnection();

        String query = "SELECT * FROM products";
        stmt = connection.prepareStatement(query);
        rs = stmt.executeQuery();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Products</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body {
            background-color: #f4f6f9;
            font-family: 'Arial', sans-serif;
            color: #333;
        }

        .container {
            max-width: 1200px;
            margin-top: 50px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            padding: 30px;
        }

        h2, h3 {
            color: #343a40;
        }

        .table {
            border: 1px solid #dee2e6;
        }

        .table th, .table td {
            text-align: center;
            padding: 12px;
            border: 1px solid #ddd;
        }

        .table th {
            background-color: #007bff;
            color: white;
        }

        .table td img {
            border-radius: 5px;
            width: 50px;
            height: 50px;
            object-fit: cover;
        }

        .btn {
            padding: 10px 15px;
            font-size: 14px;
            border-radius: 5px;
        }

        .btn-primary {
            background-color: #007bff;
            border: none;
        }

        .btn-danger {
            background-color: #dc3545;
            border: none;
        }

        .btn-primary:hover,
        .btn-danger:hover {
            opacity: 0.8;
        }

        .form-label {
            font-weight: bold;
        }

        .form-control {
            border-radius: 5px;
            border: 1px solid #ccc;
            padding: 10px;
        }

        .form-control:focus {
            border-color: #007bff;
            box-shadow: 0 0 8px rgba(0, 123, 255, 0.25);
        }

        .form-group {
            margin-bottom: 20px;
        }

        .mb-3 {
            margin-bottom: 15px;
        }

        @media (max-width: 768px) {
            .table th, .table td {
                font-size: 12px;
                padding: 8px;
            }

            .btn {
                font-size: 12px;
                padding: 8px 12px;
            }

            .container {
                padding: 20px;
            }
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Product Management</h2>

    <!-- Add Product Form -->
    <h3>Add New Product</h3>
    <form action="AdministratorProductSaveServlet" method="post" enctype="multipart/form-data">
        <input type="hidden" name="action" value="add">
        <div class="form-group mb-3">
            <label for="name" class="form-label">Product Name</label>
            <input type="text" id="name" name="name" class="form-control" required>
        </div>
        <div class="form-group mb-3">
            <label for="description" class="form-label">Description</label>
            <textarea name="description" id="description" class="form-control" required></textarea>
        </div>
        <div class="form-group mb-3">
            <label for="price" class="form-label">Price</label>
            <input type="number" step="0.01" id="price" name="price" class="form-control" required>
        </div>
        <div class="form-group mb-3">
            <label for="category" class="form-label">Category</label>
            <input type="text" id="category" name="category" class="form-control" required>
        </div>
        <div class="form-group mb-3">
            <label for="image" class="form-label">Product Image</label>
            <input type="file" id="image" name="image_url" class="form-control" required>
        </div>
        <button type="submit" class="btn btn-primary">Add Product</button>
    </form>

    <hr>

    <!-- Display all products -->
    <h3>Existing Products</h3>
    <table class="table table-striped">
        <thead>
        <tr>
            <th>#</th>
            <th>Name</th>
            <th>Description</th>
            <th>Price</th>
            <th>Category</th>
            <th>Image</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <%
            boolean hasProducts = false;
            while (rs.next()) {
                hasProducts = true;
        %>
        <tr>
            <td><%= rs.getInt("id") %></td>
            <td><%= rs.getString("name") %></td>
            <td><%= rs.getString("description") %></td>
            <td><%= rs.getBigDecimal("price") %></td>
            <td><%= rs.getString("category") %></td>
            <td><img src="<%= request.getContextPath() + "/" + rs.getString("image_url") %>" alt="Product Image"></td>
            <td>
                <a href="editproduct.jsp?id=<%= rs.getInt("id") %>" class="btn btn-primary btn-sm">Edit</a>
                <a href="AdministratorProductDeleteServlet?action=delete&id=<%= rs.getInt("id") %>" class="btn btn-danger btn-sm">Delete</a>
            </td>
        </tr>
        <% } %>
        <% if (!hasProducts) { %>
        <tr>
            <td colspan="7" class="text-center">No products available.</td>
        </tr>
        <% } %>
        </tbody>
    </table>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>

<%
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (connection != null) try { connection.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
