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

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User u = (User) session.getAttribute("user");
            if (u.isAdmin()) {
                resp.sendRedirect(req.getContextPath() + "/admin?page=dashboard");
                return;
            } else if (u.isStaff()) {
                resp.sendRedirect(req.getContextPath() + "/pos");
                return;
            } else {
                resp.sendRedirect(req.getContextPath() + "/home");
                return;
            }
        }
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String redirect = req.getParameter("redirect");

        User user = userDAO.login(username, password);

        if (user != null) {
            HttpSession session = req.getSession(true);
            session.setAttribute("user", user);

            if (redirect != null && !redirect.trim().isEmpty() && !redirect.contains("/login")) {
                resp.sendRedirect(redirect);
            } else if (user.isAdmin()) {
                resp.sendRedirect(req.getContextPath() + "/admin?page=dashboard");
            } else if (user.isStaff()) {
                resp.sendRedirect(req.getContextPath() + "/pos");
            } else {
                resp.sendRedirect(req.getContextPath() + "/home");
            }
        } else {
            req.setAttribute("errorMessage", "Tên đăng nhập hoặc mật khẩu không chính xác!");
            req.setAttribute("username", username);
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }
}