package controller;

import dao.CategoryDAO;
import dao.OrderDAO;
import dao.ProductDAO;
import model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/pos")
public class POSServlet extends HttpServlet {
    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || (!user.isAdmin() && !user.isStaff())) {
            resp.sendRedirect(req.getContextPath() + "/login?error=unauthorized");
            return;
        }

        req.setAttribute("categories", categoryDAO.all());
        req.setAttribute("products", productDAO.allForAdmin());
        req.getRequestDispatcher("/admin/pos.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || (!user.isAdmin() && !user.isStaff())) {
            resp.sendRedirect(req.getContextPath() + "/login?error=unauthorized");
            return;
        }

        String customerName = req.getParameter("customerName");
        String phone = req.getParameter("phone");
        String paymentMethod = req.getParameter("paymentMethod");
        double discount = 0;
        try {
            discount = Double.parseDouble(req.getParameter("discount"));
        } catch (Exception ignored) {}

        String[] productIds = req.getParameterValues("productId");
        String[] variantIds = req.getParameterValues("variantId");
        String[] sizes = req.getParameterValues("size");
        String[] colors = req.getParameterValues("color");
        String[] quantities = req.getParameterValues("quantity");

        if (productIds != null && productIds.length > 0) {
            List<CartItem> items = new ArrayList<>();
            for (int i = 0; i < productIds.length; i++) {
                try {
                    int pId = Integer.parseInt(productIds[i]);
                    int vId = (variantIds != null && i < variantIds.length && !variantIds[i].isEmpty()) ? Integer.parseInt(variantIds[i]) : 0;
                    String size = (sizes != null && i < sizes.length) ? sizes[i] : "M";
                    String color = (colors != null && i < colors.length) ? colors[i] : "Tiêu chuẩn";
                    int qty = (quantities != null && i < quantities.length) ? Integer.parseInt(quantities[i]) : 1;

                    Product prod = productDAO.byId(pId);
                    ProductVariant var = (vId > 0) ? productDAO.getVariantById(vId) : productDAO.findVariant(pId, size, color);

                    if (prod != null) {
                        items.add(new CartItem(prod, var, size, color, qty));
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            if (!items.isEmpty()) {
                try {
                    Order posOrder = orderDAO.createPOSOrder(user.getId(), customerName, phone, paymentMethod, discount, items);
                    req.setAttribute("posOrder", posOrder);
                    req.setAttribute("checkoutSuccess", true);
                } catch (Exception e) {
                    e.printStackTrace();
                    req.setAttribute("errorMessage", "Lỗi tạo hóa đơn POS: " + e.getMessage());
                }
            }
        }

        doGet(req, resp);
    }
}
