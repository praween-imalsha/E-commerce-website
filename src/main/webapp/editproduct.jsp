<%@ page import="java.sql.*, javax.naming.*, javax.sql.DataSource" %>
<%@ page import="java.math.BigDecimal" %>
<%
    int productId = Integer.parseInt(request.getParameter("id"));
    Connection connection = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    String name = "", description = "", category = "", imageUrl = "";
    BigDecimal price = BigDecimal.ZERO;

    try {
        Context ctx = new InitialContext();
        DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/ecommerceshop");
        connection = ds.getConnection();

        String query = "SELECT * FROM products WHERE id=?";
        stmt = connection.prepareStatement(query);
        stmt.setInt(1, productId);
        rs = stmt.executeQuery();

        if (rs.next()) {
            name = rs.getString("name");
            description = rs.getString("description");
            price = rs.getBigDecimal("price");
            category = rs.getString("category");
            imageUrl = rs.getString("image_url");
        } else {
            response.getWriter().println("<script>alert('Product not found!'); window.location='adminproducts.jsp';</script>");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (connection != null) try { connection.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Product</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body {
            background-color: #f4f6f9;
            font-family: 'Arial', sans-serif;
            color: #333;
        }

        .container {
            max-width: 800px;
            margin-top: 50px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            padding: 30px;
        }

        h2 {
            color: #343a40;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 15px;
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

        .btn-primary {
            background-color: #007bff;
            border: none;
        }

        .btn-primary:hover {
            opacity: 0.8;
        }

        .btn {
            padding: 10px 15px;
            font-size: 14px;
            border-radius: 5px;
        }

        .form-label {
            font-weight: bold;
        }

        .form-group img {
            border-radius: 5px;
            width: 100px;
            height: auto;
            margin-top: 10px;
        }

        .text-center {
            margin-top: 20px;
        }

        @media (max-width: 768px) {
            .container {
                padding: 20px;
                margin-top: 30px;
            }

            .form-group {
                margin-bottom: 12px;
            }

            .btn {
                font-size: 12px;
                padding: 8px 12px;
            }

            h2 {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Edit Product</h2>
    <form action="AdministratorProductUpdateServlet" method="post" enctype="multipart/form-data">
        <input type="hidden" name="id" value="<%= productId %>">
        <div class="form-group">
            <label for="name" class="form-label">Product Name</label>
            <input type="text" name="name" id="name" class="form-control" value="<%= name %>" required>
        </div>
        <div class="form-group">
            <label for="description" class="form-label">Description</label>
            <textarea name="description" id="description" class="form-control" required><%= description %></textarea>
        </div>
        <div class="form-group">
            <label for="price" class="form-label">Price</label>
            <input type="number" name="price" id="price" class="form-control" step="0.01" value="<%= price %>" required>
        </div>
        <div class="form-group">
            <label for="category" class="form-label">Category</label>
            <input type="text" name="category" id="category" class="form-control" value="<%= category %>" required>
        </div>
        <div class="form-group">
            <label for="image" class="form-label">Product Image</label>
            <input type="file" name="image_url" id="image" class="form-control">
            <p>Current Image: <img src="<%= request.getContextPath() + "/" + imageUrl %>" alt="Product Image"></p>
        </div>
        <button type="submit" class="btn btn-primary">Update Product</button>
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
