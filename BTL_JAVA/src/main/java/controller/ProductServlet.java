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

@WebServlet("/products")
public class ProductServlet extends HttpServlet {
    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String keyword = req.getParameter("keyword");
        String catParam = req.getParameter("category");
        String minParam = req.getParameter("minPrice");
        String maxParam = req.getParameter("maxPrice");
        String sort = req.getParameter("sort");

        Integer categoryId = null;
        if (catParam != null && !catParam.trim().isEmpty()) {
            try { categoryId = Integer.parseInt(catParam); } catch (NumberFormatException ignored) {}
        }

        Double minPrice = null;
        if (minParam != null && !minParam.trim().isEmpty()) {
            try { minPrice = Double.parseDouble(minParam); } catch (NumberFormatException ignored) {}
        }

        Double maxPrice = null;
        if (maxParam != null && !maxParam.trim().isEmpty()) {
            try { maxPrice = Double.parseDouble(maxParam); } catch (NumberFormatException ignored) {}
        }

        List<Product> list = productDAO.filter(keyword, categoryId, minPrice, maxPrice, sort);

        req.setAttribute("products", list);
        req.setAttribute("categories", categoryDAO.all());
        req.setAttribute("selectedCategory", categoryId);
        req.setAttribute("keyword", keyword);
        req.setAttribute("minPrice", minPrice);
        req.setAttribute("maxPrice", maxPrice);
        req.setAttribute("sort", sort);

        req.getRequestDispatcher("/customer/products.jsp").forward(req, resp);
    }
}