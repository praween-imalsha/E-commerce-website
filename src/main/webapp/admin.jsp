<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  String userRole = (String) session.getAttribute("userRole");
  if (userRole == null || !userRole.equals("admin")) {
    response.sendRedirect("index.jsp");
    return;
  }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin Dashboard</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  <style>
    body {
      background-color: #f8f9fa;
      font-family: 'Arial', sans-serif;
    }

    .dashboard-container {
      max-width: 900px;
      margin: 50px auto;
      padding: 30px;
      background: #ffffff;
      border-radius: 10px;
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    }

    .dashboard-container h2 {
      color: #343a40;
      margin-bottom: 30px;
      text-align: center;
    }

    .dashboard-menu {
      list-style: none;
      padding: 0;
    }

    .dashboard-menu li {
      margin-bottom: 15px;
    }

    .dashboard-menu a {
      display: block;
      padding: 12px;
      border-radius: 5px;
      text-decoration: none;
      font-size: 18px;
      font-weight: bold;
      color: #fff;
      background-color: #ff6600;
      transition: all 0.3s ease-in-out;
      text-align: center;
    }

    .dashboard-menu a:hover {
      background-color: #e65c00;
    }

    .logout-btn {
      margin-top: 30px;
      text-align: center;
    }

    .logout-btn a {
      padding: 10px 20px;
      font-size: 18px;
      font-weight: bold;
      color: #fff;
      background-color: #dc3545;
      border-radius: 5px;
      text-decoration: none;
    }

    .logout-btn a:hover {
      background-color: #c82333;
    }

    @media (max-width: 767px) {
      .dashboard-container {
        padding: 20px;
      }

      .dashboard-menu a {
        font-size: 16px;
        padding: 10px;
      }
    }
  </style>
</head>
<body>
<div class="container">
  <div class="dashboard-container">
    <h2>Admin Dashboard</h2>
    <ul class="dashboard-menu">
      <li><a href="AdminProduct.jsp">Manage Products</a></li>
      <li><a href="manage_categories.jsp">Manage Categories</a></li>
      <li><a href="manage_orders.jsp">View Orders</a></li>
      <li><a href="userList.jsp">Manage Users</a></li>
    </ul>
    <div class="logout-btn">
      <a href="index.jsp">Logout</a>
    </div>
  </div>
</div>
</body>
</html>
