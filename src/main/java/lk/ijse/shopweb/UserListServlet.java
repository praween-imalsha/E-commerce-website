package lk.ijse.shopweb;

import jakarta.servlet.RequestDispatcher;
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
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;




@WebServlet("/userList")
public class UserListServlet extends HttpServlet {

    // Database connection details
    private static final String DB_URL = "jdbc:mysql://localhost:3306/ecommerceshop";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "Ijse@1234";

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // List to hold user data
        List<UserDTO> users = new ArrayList<>();

        // Database connection and query execution
        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            // SQL query to fetch all users
            String sql = "SELECT * FROM users";
            try (PreparedStatement preparedStatement = connection.prepareStatement(sql);
                 ResultSet resultSet = preparedStatement.executeQuery()) {

                // Loop through result set and populate users list
                while (resultSet.next()) {
                    UserDTO user = new UserDTO();
                    user.setId(resultSet.getInt("id"));
                    user.setName(resultSet.getString("name"));
                    user.setEmail(resultSet.getString("email"));
                    user.setPhone(resultSet.getString("phone"));
                    user.setAddress(resultSet.getString("address"));
                    user.setRole(resultSet.getString("role"));
                    users.add(user);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            // You could log this error or send an error message to the client
        }

        // Set the list of users as a request attribute
        request.setAttribute("users", users);

        // Forward to the JSP page to display users
        RequestDispatcher dispatcher = request.getRequestDispatcher("userList.jsp");
        dispatcher.forward(request, response);
    }
}
