package lk.ijse.shopweb;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.*;

@WebServlet("/AdministratorProductDeleteServlet")
public class AdministratorProductDeleteServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int productId = Integer.parseInt(request.getParameter("id"));

        try (Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecommerceshop", "root", "Ijse@1234")) {
            String query = "DELETE FROM products WHERE id = ?";
            try (PreparedStatement stmt = connection.prepareStatement(query)) {
                stmt.setInt(1, productId);
                stmt.executeUpdate(); // Execute the delete query
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        response.sendRedirect("adminproducts.jsp");
    }
}
