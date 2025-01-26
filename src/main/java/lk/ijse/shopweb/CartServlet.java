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

@WebServlet("/CartServlet")
public class CartServlet extends HttpServlet {
    private DataSource dataSource;

    @Override
    public void init() throws ServletException {
        try {

            InitialContext ctx = new InitialContext();
            dataSource = (DataSource) ctx.lookup("java:/comp/env/jdbc/ecommerceshop");
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Unable to initialize DataSource", e);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        int productId = Integer.parseInt(request.getParameter("id"));


        CartModel cart = (CartModel) session.getAttribute("cart");
        if (cart == null) {
            cart = new CartModel();
            session.setAttribute("cart", cart);
        }

            if ("add".equals(action)) {
            cart.addItem(productId, dataSource);
        } else if ("update".equals(action)) {
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            cart.updateItemQuantity(productId, quantity);  // Update product quantity in cart
        } else if ("remove".equals(action)) {
            cart.removeItem(productId);
        }


        response.sendRedirect("cart.jsp");
    }
}
