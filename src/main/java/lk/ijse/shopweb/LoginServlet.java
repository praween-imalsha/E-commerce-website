package lk.ijse.shopweb;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.sql.DataSource;
import javax.naming.InitialContext;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Process POST request to authenticate the user
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get email and password from form
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            // Get the DataSource from the context (configured in web.xml)
            InitialContext ctx = new InitialContext();
            DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/ecommerceshop");

            // Get connection from the pool
            try (Connection conn = ds.getConnection()) {
                // Prepare SQL query to find user by email and password
                String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, email);
                    stmt.setString(2, password);

                    // Execute query
                    try (ResultSet rs = stmt.executeQuery()) {
                        // Check if user exists
                        if (rs.next()) {
                            // Create a session and set user name and role as session attributes
                            HttpSession session = request.getSession();
                            session.setAttribute("user", rs.getString("name"));
                            session.setAttribute("userRole", rs.getString("role"));  // Store role in session

                            // Redirect based on role
                            String role = rs.getString("role");
                            if ("admin".equals(role)) {
                                // Redirect to admin dashboard if admin
                                response.sendRedirect("admin.jsp");
                            } else {
                                // Redirect to home page if customer
                                response.sendRedirect("home.jsp");
                            }
                        } else {
                            // Redirect to login page with error message if credentials are invalid
                            response.sendRedirect("index.jsp?error=Invalid credentials");
                        }
                    }
                }
            }
        } catch (Exception e) {
            // Log the error and send error message to login page
            e.printStackTrace();
            response.sendRedirect("index.jsp?error=Server error");
        }
    }

    // Process GET request (used for logout or additional logic)
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Redirect to login page if the user is not logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            String role = (String) session.getAttribute("userRole");
            if ("admin".equals(role)) {
                response.sendRedirect("admin.jsp");
            } else {
                response.sendRedirect("home.jsp");
            }
        } else {
            response.sendRedirect("index.jsp");
        }
    }
}
