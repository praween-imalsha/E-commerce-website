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

@WebServlet("/AdministratorProductUpdateServlet")
@MultipartConfig(fileSizeThreshold = 2 * 1024 * 1024,  // 2MB
        maxFileSize = 10 * 1024 * 1024,       // 10MB
        maxRequestSize = 50 * 1024 * 1024)    // 50MB
public class AdministratorProductUpdateServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Validate and parse product ID
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Product ID is missing.");
            return;
        }

        int productId;
        try {
            productId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid product ID format.");
            return;
        }

        // Get form parameters
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        double price = Double.parseDouble(request.getParameter("price"));
        String category = request.getParameter("category");

        // Define upload path inside `webapp/images`
        String uploadPath = "D:/shop-web/src/main/webapp/images";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs(); // Create the directory if it doesn't exist
        }

        // Handling image upload
        Part imagePart = request.getPart("image_url");
        String imageFileName = null;
        if (imagePart != null && imagePart.getSize() > 0) {
            imageFileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
            String imageFilePath = uploadPath + File.separator + imageFileName;
            try {
                imagePart.write(imageFilePath); // Save the image
            } catch (IOException e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "File upload failed. Check folder permissions.");
                return;
            }
        }

        Connection connection = null;
        PreparedStatement stmt = null;

        try {
            // Database connection
            Context ctx = new InitialContext();
            DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/ecommerceshop");
            connection = ds.getConnection();

            String updateQuery;
            if (imageFileName != null) {
                updateQuery = "UPDATE products SET name=?, description=?, price=?, category=?, image_url=? WHERE id=?";
            } else {
                updateQuery = "UPDATE products SET name=?, description=?, price=?, category=? WHERE id=?";
            }

            stmt = connection.prepareStatement(updateQuery);
            stmt.setString(1, name);
            stmt.setString(2, description);
            stmt.setDouble(3, price);
            stmt.setString(4, category);

            if (imageFileName != null) {
                stmt.setString(5, "images/" + imageFileName); // Save relative path in DB
                stmt.setInt(6, productId);
            } else {
                stmt.setInt(5, productId);
            }

            int rowsUpdated = stmt.executeUpdate();
            if (rowsUpdated > 0) {
                response.sendRedirect("AdminProduct.jsp?updateSuccess=true");
            } else {
                response.sendRedirect("AdminProduct.jsp?updateFailed=true");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error updating product.");
        } finally {
            if (stmt != null) try { stmt.close(); } catch (Exception e) { e.printStackTrace(); }
            if (connection != null) try { connection.close(); } catch (Exception e) { e.printStackTrace(); }
        }
    }
}
