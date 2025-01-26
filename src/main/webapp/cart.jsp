<%@ page import="java.util.Collection" %>
<%@ page import="lk.ijse.shopweb.CartModel" %>
<%@ page import="lk.ijse.shopweb.CartItem" %>

<html>
<head>
    <title>Your Cart</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Poppins', sans-serif;
            padding: 20px;
        }
        .cart-table {
            width: 100%;
            margin-bottom: 30px;
        }
        .cart-table th, .cart-table td {
            padding: 15px;
            text-align: center;
        }
        .cart-table th {
            background-color: #ff6600;
            color: white;
        }
        .cart-table td {
            background-color: #ffffff;
        }
        .cart-table input[type="number"] {
            width: 60px;
            padding: 5px;
            text-align: center;
            border-radius: 5px;
            border: 1px solid #ccc;
        }
        .btn-action {
            background-color: #ff6600;
            color: white;
            font-weight: bold;
            padding: 5px 10px;
            border-radius: 5px;
            border: none;
            cursor: pointer;
        }
        .btn-action:hover {
            background-color: #e65c00;
        }
        .total-price {
            font-size: 24px;
            font-weight: bold;
            margin-top: 20px;
        }
        .empty-cart {
            text-align: center;
            font-size: 18px;
            color: #888;
        }
    </style>
</head>
<body>
<div class="container">
    <h2 class="text-center my-4">Your Shopping Cart</h2>

    <%
        HttpSession session1 = request.getSession();
        CartModel cart = (CartModel) session1.getAttribute("cart");
        if (cart == null || cart.getTotalItems() == 0) {
    %>
    <p class="empty-cart">Your cart is empty!</p>
    <%
    } else {
    %>
    <form action="CartServlet" method="GET">
        <table class="cart-table table table-bordered">
            <thead>
            <tr>
                <th>Product</th>
                <th>Image</th>
                <th>Description</th>
                <th>Price</th>
                <th>Quantity</th>
                <th>Total</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody>
            <%
                for (CartItem item : cart.getItems()) {
            %>
            <tr>
                <td><%= item.getProductName() %></td>
                <td><img src="<%= item.getProductImage() %>" alt="Product Image" width="50" height="50"></td>
                <td><%= item.getProductDescription() %></td>
                <td>$<%= item.getPrice() %></td>
                <td>
                    <input type="number" name="quantity" value="<%= item.getQuantity() %>" min="1">
                </td>
                <td>$<%= item.getPrice() * item.getQuantity() %></td>
                <td>
                    <button type="submit" name="action" value="update" class="btn-action">Update</button>
                    <button type="submit" name="action" value="remove" class="btn-action">Remove</button>
                    <input type="hidden" name="id" value="<%= item.getProductId() %>">
                </td>
            </tr>
            <%
                }
            %>
            </tbody>
        </table>
    </form>

    <div class="total-price">
        Total: $<%= cart.getTotalPrice() %>
    </div>
    <%
        }
    %>
</div>
</body>
</html>
