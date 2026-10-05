package controller;

import dao.ProductDAO;
import dao.VoucherDAO;
import model.CartItem;
import model.Product;
import model.ProductVariant;
import model.Voucher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private final ProductDAO productDAO = new ProductDAO();
    private final VoucherDAO voucherDAO = new VoucherDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Map<String, CartItem> cart = getCart(session);
        recalculateCart(session, cart);
        req.getRequestDispatcher("/customer/cart.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Map<String, CartItem> cart = getCart(session);
        String action = req.getParameter("action");

        try {
            if ("add".equalsIgnoreCase(action)) {
                int productId = Integer.parseInt(req.getParameter("productId"));
                String size = req.getParameter("size");
                String color = req.getParameter("color");
                int quantity = 1;
                try {
                    quantity = Integer.parseInt(req.getParameter("quantity"));
                    if (quantity < 1) quantity = 1;
                } catch (Exception ignored) {}

                Product product = productDAO.byId(productId);
                if (product != null) {
                    ProductVariant variant = productDAO.findVariant(productId, size, color);
                    String itemKey = productId + "_" + (size != null ? size : "default") + "_" + (color != null ? color : "default");

                    CartItem existing = cart.get(itemKey);
                    if (existing != null) {
                        existing.setQuantity(existing.getQuantity() + quantity);
                    } else {
                        cart.put(itemKey, new CartItem(product, variant, size, color, quantity));
                    }
                }
            } else if ("update".equalsIgnoreCase(action)) {
                String itemKey = req.getParameter("itemKey");
                int quantity = Integer.parseInt(req.getParameter("quantity"));
                if (quantity <= 0) {
                    cart.remove(itemKey);
                } else if (cart.containsKey(itemKey)) {
                    cart.get(itemKey).setQuantity(quantity);
                }
            } else if ("remove".equalsIgnoreCase(action)) {
                String itemKey = req.getParameter("itemKey");
                cart.remove(itemKey);
            } else if ("clear".equalsIgnoreCase(action)) {
                cart.clear();
                session.removeAttribute("appliedVoucher");
                session.removeAttribute("discountAmount");
            } else if ("applyVoucher".equalsIgnoreCase(action)) {
                String code = req.getParameter("voucherCode");
                Voucher voucher = voucherDAO.byCode(code);
                double subtotal = calculateSubtotal(cart);
                if (voucher != null && subtotal >= voucher.getMinOrderValue()) {
                    session.setAttribute("appliedVoucher", voucher);
                    session.setAttribute("voucherSuccess", "Áp dụng mã " + voucher.getCode() + " thành công!");
                } else {
                    session.removeAttribute("appliedVoucher");
                    session.setAttribute("voucherError", "Mã giảm giá không hợp lệ hoặc đơn chưa đạt mức tối thiểu!");
                }
            } else if ("removeVoucher".equalsIgnoreCase(action)) {
                session.removeAttribute("appliedVoucher");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        recalculateCart(session, cart);

        String redirect = req.getParameter("redirect");
        if ("checkout".equalsIgnoreCase(redirect)) {
            resp.sendRedirect(req.getContextPath() + "/checkout");
        } else {
            resp.sendRedirect(req.getContextPath() + "/cart");
        }
    }

    @SuppressWarnings("unchecked")
    private Map<String, CartItem> getCart(HttpSession session) {
        Map<String, CartItem> cart = (Map<String, CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new LinkedHashMap<>();
            session.setAttribute("cart", cart);
        }
        return cart;
    }

    private double calculateSubtotal(Map<String, CartItem> cart) {
        double subtotal = 0;
        for (CartItem item : cart.values()) {
            subtotal += item.getSubtotal();
        }
        return subtotal;
    }

    private void recalculateCart(HttpSession session, Map<String, CartItem> cart) {
        double subtotal = calculateSubtotal(cart);
        int totalItems = 0;
        for (CartItem item : cart.values()) {
            totalItems += item.getQuantity();
        }

        Voucher voucher = (Voucher) session.getAttribute("appliedVoucher");
        double discount = 0;
        if (voucher != null) {
            discount = voucher.calculateDiscount(subtotal);
        }

        double finalTotal = Math.max(0, subtotal - discount);

        session.setAttribute("cartSubtotal", subtotal);
        session.setAttribute("cartTotalItems", totalItems);
        session.setAttribute("discountAmount", discount);
        session.setAttribute("cartFinalTotal", finalTotal);
    }
}