package lk.ijse.shopweb;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class Product {
    private int id;
    private String name;
    private String description;
    private double price;
    private String imageUrl;
    private String category;

    public Product(String name, String description, BigDecimal price, String imageUrl, String category) {
    }

    public Product(int id, String name, String description, BigDecimal price, String imageUrl, String category) {
    }

    // Constructors





}
