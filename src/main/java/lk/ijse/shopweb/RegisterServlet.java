package lk.ijse.shopweb;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get user inputs from the registration form
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String password = request.getParameter("password");
        String role = request.getParameter("role");  // Get role from the form

        // Database connection details
        String jdbcURL = "jdbc:mysql://localhost:3306/ecommerceshop";
        String dbUser = "root";
        String dbPassword = "Ijse@1234";

        try {
            // Load the JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Create a connection to the database
            Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

            // Check if the email already exists in the database
            String checkEmailQuery = "SELECT COUNT(*) FROM users WHERE email = ?";
            PreparedStatement checkEmailStatement = conn.prepareStatement(checkEmailQuery);
            checkEmailStatement.setString(1, email);
            ResultSet rs = checkEmailStatement.executeQuery();

            if (rs.next() && rs.getInt(1) > 0) {
                // Email already exists
                response.sendRedirect("register.jsp?error=emailExists");
            } else {
                // SQL query to insert user data into the users table
                String sql = "INSERT INTO users (name, email, phone, address, password, role) VALUES (?, ?, ?, ?, ?, ?)";
                PreparedStatement statement = conn.prepareStatement(sql);
                statement.setString(1, name);
                statement.setString(2, email);
                statement.setString(3, phone);
                statement.setString(4, address);
                statement.setString(5, password); // In a real-world scenario, consider hashing the password
                statement.setString(6, role); // Set the user role

                int rowsInserted = statement.executeUpdate();

                if (rowsInserted > 0) {
                    response.sendRedirect("index.jsp?success=1");
                } else {
                    response.sendRedirect("register.jsp?error=1");
                }
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("register.jsp?error=1");
        }
    }
}
