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
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "UserListServlet", value = "/user-list")
public class UserListServlet extends HttpServlet {
    String DB_URL = "jdbc:mysql://localhost:3306/ecommerceshop";
    String DB_USER = "root";
    String DB_PASSWORD = "Ijse@1234";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<UserDTO> userList = new ArrayList<>();
        try {
            // Load the JDBC driver and establish the connection
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            System.out.println("Database connected successfully!");  // Debugging line

            // SQL query to fetch all users
            String sql = "SELECT * FROM users";
            Statement stm = connection.createStatement();
            ResultSet rst = stm.executeQuery(sql);

            // Check if any users were retrieved
            while (rst.next()) {
                UserDTO userDTO = new UserDTO(
                        rst.getInt("id"),
                        rst.getString("name"),
                        rst.getString("email"),
                        rst.getString("password"),
                        rst.getString("phone"),
                        rst.getString("address"),
                        rst.getString("role")
                );
                userList.add(userDTO);
            }

            // Log how many users were retrieved
            System.out.println("Number of users retrieved: " + userList.size());  // Debugging line

            // Set the users list in the request scope
            req.setAttribute("users", userList);


            RequestDispatcher rd = req.getRequestDispatcher("View_users.jsp");
            rd.forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("user-list.jsp?error=Failed to retrieve users");
        }
    }
}
