package lk.ijse.shopweb;

import javax.sql.DataSource;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

public class CartModel {
    private Map<Integer, CartItem> items = new HashMap<>();


    public void addItem(int productId, DataSource dataSource) {
        CartItem item = items.get(productId);
        if (item == null) {
            item = new CartItem(productId, 1, dataSource);
            items.put(productId, item);
        } else {
            item.setQuantity(item.getQuantity() + 1);
        }
    }


    public void updateItemQuantity(int productId, int quantity) {
        CartItem item = items.get(productId);
        if (item != null) {
            item.setQuantity(quantity);
        }
    }


    public void removeItem(int productId) {
        items.remove(productId);
    }


    public Collection<CartItem> getItems() {
        return items.values();
    }


    public int getTotalItems() {
        return items.size();
    }


    public double getTotalPrice() {
        double total = 0;
        for (CartItem item : items.values()) {
            total += item.getPrice() * item.getQuantity();
        }
        return total;
    }
}
