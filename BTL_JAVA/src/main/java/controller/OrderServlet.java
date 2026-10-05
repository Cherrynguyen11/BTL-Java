package controller;

import dao.OrderDAO;
import model.Order;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/order", "/orders"})
public class OrderServlet extends HttpServlet {
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String orderIdParam = req.getParameter("id");
        if (orderIdParam != null && !orderIdParam.trim().isEmpty()) {
            try {
                int orderId = Integer.parseInt(orderIdParam);
                Order order = orderDAO.byId(orderId);
                // Khách chỉ được xem đơn của mình
                if (order != null && (order.getUserId() == null || order.getUserId() == user.getId())) {
                    req.setAttribute("order", order);
                    req.getRequestDispatcher("/customer/orders.jsp").forward(req, resp);
                    return;
                }
            } catch (NumberFormatException ignored) {}
        }

        List<Order> orders = orderDAO.byUser(user.getId());
        req.setAttribute("orders", orders);
        req.getRequestDispatcher("/customer/orders.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        if ("cancel".equalsIgnoreCase(action)) {
            try {
                int orderId = Integer.parseInt(req.getParameter("orderId"));
                Order order = orderDAO.byId(orderId);
                if (order != null && order.getUserId() != null && order.getUserId() == user.getId()) {
                    if ("PENDING".equalsIgnoreCase(order.getStatus())) {
                        orderDAO.updateStatus(orderId, "CANCELLED");
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        resp.sendRedirect(req.getContextPath() + "/order");
    }
}