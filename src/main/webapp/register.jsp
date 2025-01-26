<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Sign Up - E-Commerce</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Arial', sans-serif;
        }

        .card {
            border-radius: 10px;
            border: none;
            box-shadow: 0px 10px 20px rgba(0, 0, 0, 0.1);
            background-color: #ffffff;
        }

        .card-body {
            padding: 30px;
        }

        h2 {
            font-size: 24px;
            color: #333;
            margin-bottom: 20px;
        }

        .form-control {
            border-radius: 5px;
            padding: 10px;
            border: 1px solid #ccc;
            transition: border-color 0.3s;
        }

        .form-control:focus {
            border-color: #ff6600;
            box-shadow: 0 0 0 0.2rem rgba(255, 102, 0, 0.25);
        }

        .btn-primary {
            background-color: #ff6600;
            border-color: #ff6600;
            font-weight: bold;
            padding: 10px 20px;
            border-radius: 5px;
            transition: background-color 0.3s;
        }

        .btn-primary:hover {
            background-color: #e65c00;
            border-color: #e65c00;
        }

        .text-center a {
            text-decoration: none;
            color: #ff6600;
            font-weight: bold;
            transition: color 0.3s;
        }

        .text-center a:hover {
            color: #e65c00;
        }

        .form-label {
            font-weight: bold;
            margin-bottom: 5px;
            font-size: 14px;
            color: #333;
        }

        .container {
            margin-top: 50px;
        }
    </style>
</head>
<body>

<div class="container mt-5">
    <div class="card mx-auto" style="max-width: 400px;">
        <div class="card-body">
            <h2 class="text-center">Sign Up</h2>

            <%-- Display error messages --%>
            <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-danger">
                <% if ("emailExists".equals(request.getParameter("error"))) { %>
                Email already exists. Try another one.
                <% } else { %>
                Registration failed. Please try again.
                <% } %>
            </div>
            <% } %>

            <form action="RegisterServlet" method="post">
                <!-- Full Name -->
                <div class="mb-3">
                    <label for="name" class="form-label">Full Name:</label>
                    <input type="text" id="name" name="name" class="form-control" required>
                </div>

                <!-- Email -->
                <div class="mb-3">
                    <label for="email" class="form-label">Email:</label>
                    <input type="email" id="email" name="email" class="form-control" required>
                </div>

                <!-- Phone -->
                <div class="mb-3">
                    <label for="phone" class="form-label">Phone:</label>
                    <input type="text" id="phone" name="phone" class="form-control" required>
                </div>

                <!-- Address -->
                <div class="mb-3">
                    <label for="address" class="form-label">Address:</label>
                    <textarea id="address" name="address" class="form-control" required></textarea>
                </div>

                <!-- Password -->
                <div class="mb-3">
                    <label for="password" class="form-label">Password:</label>
                    <input type="password" id="password" name="password" class="form-control" required>
                </div>
                <!-- Add a Role dropdown to register.jsp -->
                <div class="mb-3">
                    <label for="role" class="form-label">Role:</label>
                    <select id="role" name="role" class="form-control" required>
                        <option value="customer">Customer</option>
                        <option value="admin">Admin</option>
                    </select>
                </div>

                <button type="submit" class="btn btn-primary w-100">Register</button>
            </form>

            <p class="mt-3 text-center">Already have an account? <a href="index.jsp">Login here</a></p>
        </div>
    </div>
</div>

</body>
</html>
