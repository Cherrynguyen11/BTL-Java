package controller;

import dao.UserDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");

        if (password != null && !password.equals(confirmPassword)) {
            req.setAttribute("errorMessage", "Mật khẩu xác nhận không khớp!");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        if (userDAO.existsUsername(username)) {
            req.setAttribute("errorMessage", "Tên đăng nhập đã tồn tại trong hệ thống!");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        User u = new User();
        u.setUsername(username);
        u.setPassword(password);
        u.setFullName(fullName);
        u.setEmail(email);
        u.setPhone(phone);
        u.setAddress(address);

        if (userDAO.register(u)) {
            User registeredUser = userDAO.login(username, password);
            HttpSession session = req.getSession(true);
            session.setAttribute("user", registeredUser);
            resp.sendRedirect(req.getContextPath() + "/home?registered=1");
        } else {
            req.setAttribute("errorMessage", "Đăng ký không thành công, vui lòng thử lại!");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
        }
    }
}