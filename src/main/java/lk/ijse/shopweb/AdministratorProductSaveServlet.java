package lk.ijse.shopweb;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/AdministratorProductSaveServlet")
@MultipartConfig(fileSizeThreshold = 2 * 1024 * 1024,  // 2MB
        maxFileSize = 10 * 1024 * 1024,       // 10MB
        maxRequestSize = 50 * 1024 * 1024)    // 50MB
public class AdministratorProductSaveServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve form data
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        double price = Double.parseDouble(request.getParameter("price"));
        String category = request.getParameter("category");

        // Define the upload directory
        String uploadDirectory = "D:/shop-web/src/main/webapp/images/";
        File uploadDir = new File(uploadDirectory);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }


        Part imagePart = request.getPart("image_url");
        String imageFileName = null;
        if (imagePart != null && imagePart.getSize() > 0) {
            imageFileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
            String imageFilePath = uploadDirectory + imageFileName;
            try {
                imagePart.write(imageFilePath);
            } catch (IOException e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "File upload failed.");
                return;
            }
        }


        Connection connection = null;
        PreparedStatement stmt = null;

        try {
            Context ctx = new InitialContext();
            DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/ecommerceshop");
            connection = ds.getConnection();

            // Insert product into the database
            String insertQuery = "INSERT INTO products (name, description, price, category, image_url) VALUES (?, ?, ?, ?, ?)";
            stmt = connection.prepareStatement(insertQuery);
            stmt.setString(1, name);
            stmt.setString(2, description);
            stmt.setDouble(3, price);
            stmt.setString(4, category);
            stmt.setString(5, imageFileName != null ? "images/" + imageFileName : null);
            stmt.executeUpdate();

            // Redirect to the correct page after saving
            response.sendRedirect("AdminProduct.jsp?saveSuccess=true");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error saving product.");
        } finally {
            if (stmt != null) try { stmt.close(); } catch (Exception e) { e.printStackTrace(); }
            if (connection != null) try { connection.close(); } catch (Exception e) { e.printStackTrace(); }
        }
    }
}
