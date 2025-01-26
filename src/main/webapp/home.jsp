<%@ page import="java.util.List" %>
<%@ page import="lk.ijse.shopweb.Product" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>Home - E-Commerce</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        /* Your existing styles */
        body {
            background-color: #f8f9fa;
            font-family: 'Poppins', sans-serif;
        }

        .navbar {
            background-color: #ff6600;
            padding: 15px;
        }

        .navbar-brand {
            font-weight: bold;
            font-size: 24px;
        }

        .nav-link {
            font-size: 16px;
            transition: 0.3s;
        }

        .nav-link:hover {
            color: #ffc107 !important;
        }

        .search-bar input {
            width: 50%;
            padding: 10px;
            font-size: 16px;
            border: 1px solid #ccc;
            border-radius: 25px;
        }

        .welcome {
            text-align: center;
            margin: 30px 0;
            font-size: 24px;
            font-weight: bold;
            color: #333;
        }

        .product-list {
            margin-top: 20px;
        }

        .product-card {
            border: none;
            border-radius: 10px;
            overflow: hidden;
            transition: transform 0.3s ease-in-out, box-shadow 0.3s ease-in-out;
        }

        .product-card:hover {
            transform: scale(1.05);
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.2);
        }

        .product-card img {
            width: 100%;
            height: 200px;
            object-fit: cover;
        }

        .product-card .card-body {
            text-align: center;
        }

        .product-card .btn {
            background-color: #ff6600;
            color: white;
            font-weight: bold;
        }

        .product-card .btn:hover {
            background-color: #e65c00;
        }
        .hero {
            position: relative;
            overflow: hidden;
            background-color: #333;
            color: white;
            text-align: center;
            padding: 50px 20px;
            max-width: 100%;
        }

        .hero-content h2 {
            font-size: 36px;
            font-weight: 700;
        }

        .hero-content p {
            font-size: 16px;
            margin-top: 10px;
        }

        .slider-container {
            position: relative;
            max-width: 100%;
            overflow: hidden;
            height: 350px;
        }

        .slider img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: none;
        }

        .slider img.active {
            display: block;
            transition: opacity 1s ease-in-out;
        }

        .prev, .next {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            background-color: rgba(0, 0, 0, 0.5);
            color: white;
            border: none;
            padding: 10px;
            cursor: pointer;
            font-size: 20px;
        }

        .prev { left: 10px; }
        .next { right: 10px; }

        .prev:hover, .next:hover {
            background-color: rgba(0, 0, 0, 0.8);
        }

    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark">
    <div class="container">
        <a class="navbar-brand" href="home.jsp">E-Commerce</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="nav-link" href="cart.jsp">🛒 Cart</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="profile.jsp">👤 Profile</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link btn btn-light text-dark px-3" href="LogoutServlet">Logout</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div class="container">
    <div class="welcome">
        <h2>Welcome, User! 🎉</h2>
    </div>

    <form action="ProductServlet" method="GET" class="d-flex justify-content-center mb-4">
        <input type="text" name="search" class="form-control w-50 me-2" placeholder="Search for products..." value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
        <select name="sort" class="form-control w-auto me-2">
            <option value="" disabled selected>Sort By Price</option>
            <option value="asc" <%= "asc".equals(request.getParameter("sort")) ? "selected" : "" %>>Low to High</option>
            <option value="desc" <%= "desc".equals(request.getParameter("sort")) ? "selected" : "" %>>High to Low</option>
        </select>
        <button type="submit" class="btn btn-primary">Search</button>
    </form>
    <section class="hero">
        <div class="slider-container">
            <div class="slider">
                <img src="images/8409617c-c704-45c5-b75e-224e8d895c03_LK-1976-688.jpg_2200x2200q80.jpg" alt="Slide 1" class="slide active">
                <img src="images/fb639c53-5f8d-439b-a195-63186a2c817c_LK-1976-688.jpg_2200x2200q80.jpg" alt="Slide 2" class="slide">
                <img src="images/download%20(1).jpeg" alt="Slide 3" class="slide">
            </div>
            <button class="prev" onclick="changeSlide(-1)">&#10094;</button>
            <button class="next" onclick="changeSlide(1)">&#10095;</button>
        </div>
        <div class="hero-content">
            <h2>Welcome to Our E-Commerce Store</h2>
            <p>Your one-stop shop for the best deals on top products!</p>
        </div>
    </section>
    <div class="product-list">
        <h3 class="text-center">🛍️ Available Products</h3>
        <div class="row">
            <%
                List<Product> products = (List<Product>) request.getAttribute("products");
                if (products != null && !products.isEmpty()) {
                    for (Product product : products) {
            %>
            <div class="col-md-4 mb-4">
                <div class="card product-card">
                    <img src="<%= product.getImageUrl() %>" class="card-img-top" alt="Product Image">
                    <div class="card-body">
                        <h5 class="card-title"><%= product.getName() %></h5>
                        <p class="card-text">$<%= product.getPrice() %></p>
                        <a href="CartServlet?action=add&id=<%= product.getId() %>" class="btn btn-warning w-100">🛒 Add to Cart</a>

                    </div>
                </div>
            </div>
            <%
                }
            } else {
            %>
            <div class="col-12 text-center">
                <p>No products found.</p>
            </div>
            <%
                }
            %>
        </div>
    </div>
</div>
<script>
    let slideIndex = 0;
    const slides = document.querySelectorAll(".slide");

    function showSlides() {
        slides.forEach(slide => slide.classList.remove("active"));
        slides[slideIndex].classList.add("active");
    }

    function changeSlide(n) {
        slideIndex += n;
        if (slideIndex >= slides.length) slideIndex = 0;
        if (slideIndex < 0) slideIndex = slides.length - 1;
        showSlides();
    }

    setInterval(() => changeSlide(1), 5000);
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
