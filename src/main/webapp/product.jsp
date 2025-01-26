<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.DriverManager" %><%--
  Created by IntelliJ IDEA.
  User: HP
  Date: 1/22/2025
  Time: 7:30 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<style>
    /* General Styles */
    body {
        background-color: #f8f9fa;
        font-family: 'Poppins', sans-serif;
    }

    /* Product Grid Layout */
    .product-card {
        border: none;
        border-radius: 10px;
        overflow: hidden;
        transition: transform 0.3s ease-in-out, box-shadow 0.3s ease-in-out;
        box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
    }

    .product-card:hover {
        transform: scale(1.05);
        box-shadow: 0px 6px 15px rgba(0, 0, 0, 0.2);
    }

    /* Product Image */
    .product-card img {
        width: 100%;
        height: 200px;
        object-fit: cover;
    }

    /* Card Body */
    .product-card .card-body {
        text-align: center;
    }

    /* Product Title */
    .product-card .card-title {
        font-size: 18px;
        font-weight: bold;
        color: #333;
    }

    /* Price */
    .product-card .card-text {
        font-size: 16px;
        color: #28a745;
        font-weight: bold;
    }

    /* Add to Cart Button */
    .product-card .btn {
        background-color: #ff6600;
        color: white;
        font-weight: bold;
    }

    .product-card .btn:hover {
        background-color: #e65c00;
    }

</style>
<body>
<%
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecommerceshop", "root", "Ijse@1234");
        stmt = conn.createStatement();
        rs = stmt.executeQuery("SELECT * FROM products");
%>

<!-- Product Grid -->
<div class="container mt-4">
    <div class="row">
        <%
            while (rs.next()) {
        %>
        <div class="col-md-4 mb-4">
            <div class="card product-card">
                <img src="<%= rs.getString("image_url") %>" class="card-img-top" alt="Product Image">
                <div class="card-body">
                    <h5 class="card-title"><%= rs.getString("name") %></h5>
                    <p class="card-text">$<%= rs.getDouble("price") %></p>
                    <a href="CartServlet?id=<%= rs.getInt("id") %>" class="btn btn-warning w-100">🛒 Add to Cart</a>
                </div>
            </div>
        </div>
        <%
            }
        %>
    </div>
</div>

<%
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>
</body>
</html>
