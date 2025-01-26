package lk.ijse.shopweb;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import javax.naming.InitialContext;
import javax.sql.DataSource;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/ProductServlet")
public class ProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String searchQuery = request.getParameter("search"); // Get search query if exists
        String sortOrder = request.getParameter("sort"); // Get sorting order (asc or desc)
        List<Product> products = new ArrayList<>();

        // Setup database connection and query
        try (Connection conn = getConnection()) {
            StringBuilder sql = new StringBuilder("SELECT * FROM products");

            // If search query exists, add WHERE condition
            if (searchQuery != null && !searchQuery.isEmpty()) {
                sql.append(" WHERE name LIKE ?");
            }

            // Add sorting condition if "sort" parameter is provided
            if (sortOrder != null && !sortOrder.isEmpty()) {
                sql.append(" ORDER BY price ").append(sortOrder.equals("asc") ? "ASC" : "DESC");
            }

            // Prepare SQL statement
            PreparedStatement stmt = conn.prepareStatement(sql.toString());

            // Set the search query parameter
            if (searchQuery != null && !searchQuery.isEmpty()) {
                stmt.setString(1, "%" + searchQuery + "%");
            }

            // Execute the query
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    // Create product object and set values
                    Product product = new Product(
                            rs.getInt("id"),
                            rs.getString("name"),
                            rs.getString("description"),
                            rs.getDouble("price"),
                            rs.getString("image_url"),
                            rs.getString("category")
                    );
                    products.add(product); // Add product to the list
                }
            }

            // Check if the request is an AJAX request
            String isAjax = request.getHeader("X-Requested-With");
            if ("XMLHttpRequest".equals(isAjax)) {
                // If it's an AJAX request, send JSON response
                response.setContentType("application/json");
                response.getWriter().write(new com.google.gson.Gson().toJson(products));
            } else {
                // Otherwise, forward to the JSP page
                request.setAttribute("products", products);
                RequestDispatcher dispatcher = request.getRequestDispatcher("home.jsp");
                dispatcher.forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp"); // Redirect to an error page in case of an exception
        }
    }

    // Method to get a database connection from the DataSource
    private Connection getConnection() throws Exception {
        InitialContext ctx = new InitialContext();
        DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/ecommerceshop");
        return ds.getConnection();
    }
}
