package controller;

import dao.CategoryDAO;
import dao.ProductDAO;
import model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/home", ""})
public class HomeController extends HttpServlet {
    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Product> allProducts = productDAO.all();
        req.setAttribute("categories", categoryDAO.all());
        req.setAttribute("featuredProducts", allProducts.size() > 4 ? allProducts.subList(0, 4) : allProducts);
        req.setAttribute("newArrivals", allProducts);
        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }
}
