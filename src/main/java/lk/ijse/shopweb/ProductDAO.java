package lk.ijse.shopweb;

import java.sql.*;

public class ProductDAO {


    private static Connection getConnection() throws SQLException {

        return DriverManager.getConnection("jdbc:mysql://localhost:3306/shop", "root", "password");
    }

    public static double getPriceById(int productId) {
        double price = 0;
        try (Connection connection = getConnection()) {
            String query = "SELECT price FROM products WHERE product_id = ?";
            try (PreparedStatement statement = connection.prepareStatement(query)) {
                statement.setInt(1, productId);
                ResultSet resultSet = statement.executeQuery();
                if (resultSet.next()) {
                    price = resultSet.getDouble("price");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return price;
    }

    public static String getProductNameById(int productId) {
        String name = "";
        try (Connection connection = getConnection()) {
            String query = "SELECT name FROM products WHERE product_id = ?";
            try (PreparedStatement statement = connection.prepareStatement(query)) {
                statement.setInt(1, productId);
                ResultSet resultSet = statement.executeQuery();
                if (resultSet.next()) {
                    name = resultSet.getString("name");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return name;
    }

    public static String getProductDescriptionById(int productId) {
        String description = "";
        try (Connection connection = getConnection()) {
            String query = "SELECT description FROM products WHERE product_id = ?";
            try (PreparedStatement statement = connection.prepareStatement(query)) {
                statement.setInt(1, productId);
                ResultSet resultSet = statement.executeQuery();
                if (resultSet.next()) {
                    description = resultSet.getString("description");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return description;
    }

    public static String getProductImageById(int productId) {
        String image = "";
        try (Connection connection = getConnection()) {
            String query = "SELECT image FROM products WHERE product_id = ?";
            try (PreparedStatement statement = connection.prepareStatement(query)) {
                statement.setInt(1, productId);
                ResultSet resultSet = statement.executeQuery();
                if (resultSet.next()) {
                    image = resultSet.getString("image");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return image;
    }
}
