package lk.ijse.shopweb;

import lombok.Data;

import java.sql.*;
import javax.sql.DataSource;
@Data
public class CartItem {
    private int productId;
    private int quantity;
    private double price;
    private String productName;
    private String productDescription;
    private String productImage;

    public CartItem(int productId, int quantity, DataSource dataSource) {
        this.productId = productId;
        this.quantity = quantity;
        fetchProductDetails(dataSource);
    }

    // Getter methods
    public String getProductName() {
        return productName;
    }

    public String getProductDescription() {
        return productDescription;
    }

    public String getProductImage() {
        return productImage;
    }

    public double getPrice() {
        return price;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    // Method to fetch product details from database
    private void fetchProductDetails(DataSource dataSource) {
        String query = "SELECT name, description, price, image FROM products WHERE id = ?";

        try (Connection connection = dataSource.getConnection();
             PreparedStatement pst = connection.prepareStatement(query)) {
            pst.setInt(1, productId);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                this.productName = rs.getString("name");
                this.productDescription = rs.getString("description");
                this.price = rs.getDouble("price");
                this.productImage = rs.getString("image"); // Make sure the column is 'image' or update accordingly
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
