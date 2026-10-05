package controller;

import dao.*;
import model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {
    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final OrderDAO orderDAO = new OrderDAO();
    private final UserDAO userDAO = new UserDAO();
    private final VoucherDAO voucherDAO = new VoucherDAO();

    private boolean isAuthorized(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) return false;
        User u = (User) session.getAttribute("user");
        return u != null && (u.isAdmin() || u.isStaff());
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!isAuthorized(req)) {
            resp.sendRedirect(req.getContextPath() + "/login?error=unauthorized");
            return;
        }

        String page = req.getParameter("page");
        if (page == null || page.trim().isEmpty()) {
            page = "dashboard";
        }

        switch (page) {
            case "dashboard":
                OmniStats stats = orderDAO.getOmniStats();
                req.setAttribute("stats", stats);
                req.setAttribute("recentOrders", orderDAO.filter(null, null, null));
                req.getRequestDispatcher("/admin/dashboard.jsp").forward(req, resp);
                break;

            case "orders":
                String channel = req.getParameter("channel");
                String status = req.getParameter("status");
                String keyword = req.getParameter("keyword");
                List<Order> orders = orderDAO.filter(channel, status, keyword);
                req.setAttribute("orders", orders);
                req.setAttribute("selectedChannel", channel);
                req.setAttribute("selectedStatus", status);
                req.setAttribute("keyword", keyword);
                req.getRequestDispatcher("/admin/orders.jsp").forward(req, resp);
                break;

            case "order-detail":
                try {
                    int orderId = Integer.parseInt(req.getParameter("id"));
                    Order o = orderDAO.byId(orderId);
                    req.setAttribute("order", o);
                    req.getRequestDispatcher("/admin/order-detail.jsp").forward(req, resp);
                } catch (Exception e) {
                    resp.sendRedirect(req.getContextPath() + "/admin?page=orders");
                }
                break;

            case "products":
                req.setAttribute("products", productDAO.allForAdmin());
                req.setAttribute("categories", categoryDAO.all());
                req.getRequestDispatcher("/admin/products.jsp").forward(req, resp);
                break;

            case "categories":
                req.setAttribute("categories", categoryDAO.all());
                req.getRequestDispatcher("/admin/categories.jsp").forward(req, resp);
                break;

            case "inventory":
                req.setAttribute("products", productDAO.allForAdmin());
                req.setAttribute("lowStockVariants", productDAO.getLowStockVariants(10));
                req.getRequestDispatcher("/admin/inventory.jsp").forward(req, resp);
                break;

            case "users":
                req.setAttribute("users", userDAO.allUsers());
                req.getRequestDispatcher("/admin/users.jsp").forward(req, resp);
                break;

            default:
                resp.sendRedirect(req.getContextPath() + "/admin?page=dashboard");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!isAuthorized(req)) {
            resp.sendRedirect(req.getContextPath() + "/login?error=unauthorized");
            return;
        }

        String action = req.getParameter("action");
        String redirectPage = req.getParameter("page");
        if (redirectPage == null) redirectPage = "dashboard";

        try {
            if ("productAdd".equalsIgnoreCase(action)) {
                Product p = new Product();
                p.setCategoryId(Integer.parseInt(req.getParameter("categoryId")));
                p.setName(req.getParameter("name"));
                p.setDescription(req.getParameter("description"));
                p.setPrice(Double.parseDouble(req.getParameter("price")));
                double origPrice = p.getPrice();
                try {
                    origPrice = Double.parseDouble(req.getParameter("originalPrice"));
                } catch (Exception ignored) {}
                p.setOriginalPrice(origPrice);
                p.setImage(req.getParameter("image"));
                p.setStatus(1);

                int newId = productDAO.add(p);
                if (newId > 0) {
                    // Thêm biến thể ban đầu
                    String[] sizes = req.getParameterValues("sizes");
                    String color = req.getParameter("color");
                    int initialQty = 10;
                    try {
                        initialQty = Integer.parseInt(req.getParameter("initialQuantity"));
                    } catch (Exception ignored) {}

                    if (sizes != null && color != null) {
                        for (String size : sizes) {
                            String sku = "FS-" + newId + "-" + size + "-" + color.substring(0, Math.min(2, color.length())).toUpperCase();
                            productDAO.addVariant(new ProductVariant(0, newId, sku, size, color, initialQty));
                        }
                    }
                }
            } else if ("productUpdate".equalsIgnoreCase(action)) {
                Product p = new Product();
                p.setId(Integer.parseInt(req.getParameter("id")));
                p.setCategoryId(Integer.parseInt(req.getParameter("categoryId")));
                p.setName(req.getParameter("name"));
                p.setDescription(req.getParameter("description"));
                p.setPrice(Double.parseDouble(req.getParameter("price")));
                p.setOriginalPrice(Double.parseDouble(req.getParameter("originalPrice")));
                p.setImage(req.getParameter("image"));
                p.setStatus(Integer.parseInt(req.getParameter("status")));
                productDAO.update(p);
            } else if ("productDelete".equalsIgnoreCase(action)) {
                productDAO.delete(Integer.parseInt(req.getParameter("id")));
            } else if ("addVariant".equalsIgnoreCase(action)) {
                int productId = Integer.parseInt(req.getParameter("productId"));
                String size = req.getParameter("size");
                String color = req.getParameter("color");
                int qty = Integer.parseInt(req.getParameter("quantity"));
                String sku = "FS-" + productId + "-" + size + "-" + (color.length() >= 2 ? color.substring(0, 2).toUpperCase() : color.toUpperCase());
                productDAO.addVariant(new ProductVariant(0, productId, sku, size, color, qty));
            } else if ("updateStock".equalsIgnoreCase(action)) {
                int variantId = Integer.parseInt(req.getParameter("variantId"));
                int addQty = Integer.parseInt(req.getParameter("addQuantity"));
                ProductVariant pv = productDAO.getVariantById(variantId);
                if (pv != null) {
                    int newQty = Math.max(0, pv.getQuantity() + addQty);
                    productDAO.updateVariantQuantity(variantId, newQty);
                }
            } else if ("categoryAdd".equalsIgnoreCase(action)) {
                Category c = new Category();
                c.setName(req.getParameter("name"));
                c.setDescription(req.getParameter("description"));
                c.setIcon(req.getParameter("icon"));
                categoryDAO.add(c);
            } else if ("categoryDelete".equalsIgnoreCase(action)) {
                categoryDAO.delete(Integer.parseInt(req.getParameter("id")));
            } else if ("orderStatus".equalsIgnoreCase(action)) {
                int orderId = Integer.parseInt(req.getParameter("id"));
                String newStatus = req.getParameter("status");
                orderDAO.updateStatus(orderId, newStatus);
            } else if ("userRole".equalsIgnoreCase(action)) {
                int userId = Integer.parseInt(req.getParameter("userId"));
                String newRole = req.getParameter("role");
                userDAO.updateRole(userId, newRole);
            } else if ("userToggleStatus".equalsIgnoreCase(action)) {
                int userId = Integer.parseInt(req.getParameter("userId"));
                userDAO.toggleStatus(userId);
            } else if ("simulateExternalOrder".equalsIgnoreCase(action)) {
                // Mô phỏng đơn hàng sàn TMĐT Shopee / TikTok
                String channel = req.getParameter("channel");
                String custName = req.getParameter("customerName");
                String phone = req.getParameter("phone");
                String address = req.getParameter("address");
                int variantId = Integer.parseInt(req.getParameter("variantId"));
                ProductVariant pv = productDAO.getVariantById(variantId);
                if (pv != null) {
                    Product prod = productDAO.byId(pv.getProductId());
                    if (prod != null) {
                        orderDAO.createExternalOrder(channel, custName, phone, address, prod.getId(), pv.getId(), pv.getSize(), pv.getColor(), 1, prod.getPrice());
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        resp.sendRedirect(req.getContextPath() + "/admin?page=" + redirectPage);
    }
}
