package controller;

import dao.OrderDAO;
import model.CartItem;
import model.Order;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        @SuppressWarnings("unchecked")
        Map<String, CartItem> cart = (Map<String, CartItem>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        User user = (User) session.getAttribute("user");
        req.setAttribute("currentUser", user);

        Double finalTotal = (Double) session.getAttribute("cartFinalTotal");
        if (finalTotal == null) finalTotal = 0.0;

        // Tạo VietQR URL mẫu chuyển khoản
        String bankCode = "MB"; // MBBank
        String accountNo = "0901234567";
        String accountName = "FASHIONSTORE OMNICHANNEL";
        String qrUrl = String.format("https://img.vietqr.io/image/%s-%s-compact.png?amount=%d&addInfo=Thanh+toan+FashionStore&accountName=%s",
                bankCode, accountNo, Math.round(finalTotal), accountName.replace(" ", "+"));

        req.setAttribute("qrUrl", qrUrl);
        req.setAttribute("bankName", "MB Bank (Ngân hàng Quân Đội)");
        req.setAttribute("accountNo", accountNo);
        req.setAttribute("accountName", accountName);

        req.getRequestDispatcher("/customer/checkout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        @SuppressWarnings("unchecked")
        Map<String, CartItem> cart = (Map<String, CartItem>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        User user = (User) session.getAttribute("user");
        String name = req.getParameter("customerName");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");
        String paymentMethod = req.getParameter("paymentMethod");
        String notes = req.getParameter("notes");

        Double discount = (Double) session.getAttribute("discountAmount");
        if (discount == null) discount = 0.0;

        try {
            List<CartItem> items = new ArrayList<>(cart.values());
            Integer userId = (user != null) ? user.getId() : null;

            Order order = orderDAO.createOnlineOrder(userId, name, phone, address, paymentMethod, notes, items, discount);

            // Dọn dẹp session
            session.removeAttribute("cart");
            session.removeAttribute("appliedVoucher");
            session.removeAttribute("discountAmount");
            session.removeAttribute("cartSubtotal");
            session.removeAttribute("cartFinalTotal");
            session.removeAttribute("cartTotalItems");

            resp.sendRedirect(req.getContextPath() + "/order?success=1&code=" + order.getOrderCode());
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Không thể xử lý đơn hàng: " + e.getMessage());
            doGet(req, resp);
        }
    }
}
