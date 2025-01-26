package lk.ijse.shopweb;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import javax.naming.InitialContext;
import javax.sql.DataSource;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/UserProfileServlet")
public class UserProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Process POST request to update user profile
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the user email from the session
        HttpSession session = request.getSession();
        String userEmail = (String) session.getAttribute("user");  // Assume the user's email is stored in session

        if (userEmail == null) {
            response.sendRedirect("login.jsp");  // Redirect to login if session is not valid
            return;
        }

        // Get the new user data from the form
        String newName = request.getParameter("name");
        String newEmail = request.getParameter("email");
        String newPassword = request.getParameter("password");

        // Validate form data
        if (newName == null || newName.isEmpty() || newEmail == null || newEmail.isEmpty() || newPassword == null || newPassword.isEmpty()) {
            response.sendRedirect("profile.jsp?error=All fields must be filled");
            return;
        }

        // Database connection
        try {
            // Get the DataSource from the context (configured in web.xml)
            InitialContext ctx = new InitialContext();
            DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/ecommerceshop");

            // Get connection from the pool
            try (Connection conn = ds.getConnection()) {
                // Prepare SQL query to update user information
                String sql = "UPDATE users SET name = ?, email = ?, password = ? WHERE email = ?";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, newName);
                    stmt.setString(2, newEmail);
                    stmt.setString(3, newPassword);
                    stmt.setString(4, userEmail);

                    // Execute update query
                    int rowsUpdated = stmt.executeUpdate();
                    if (rowsUpdated > 0) {
                        // Update session data if the user email is changed
                        session.setAttribute("user", newEmail);
                        session.setAttribute("userName", newName);

                        // Redirect to user profile page with a success message
                        response.sendRedirect("profile.jsp?message=Profile updated successfully");
                    } else {
                        // Redirect with an error message if update failed
                        response.sendRedirect("profile.jsp?error=Failed to update profile");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("profile.jsp?error=Server error");
        }
    }

    // Default GET method (can be used for other purposes if necessary)
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // You can implement logic for GET request if needed
    }
}
