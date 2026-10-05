package dao;

import model.Product;
import model.ProductVariant;
import utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    private static final String BASE_SELECT =
            "SELECT p.*, c.name AS category_name, " +
            "COALESCE((SELECT SUM(quantity) FROM product_variants v WHERE v.product_id = p.id), 0) AS stock " +
            "FROM products p JOIN categories c ON p.category_id = c.id ";

    private Product mapProduct(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setId(rs.getInt("id"));
        p.setCategoryId(rs.getInt("category_id"));
        p.setCategoryName(rs.getString("category_name"));
        p.setName(rs.getString("name"));
        p.setDescription(rs.getString("description"));
        p.setPrice(rs.getDouble("price"));
        p.setOriginalPrice(rs.getDouble("original_price"));
        p.setImage(rs.getString("image"));
        p.setStatus(rs.getInt("status"));
        p.setCreatedAt(rs.getTimestamp("created_at"));
        p.setStock(rs.getInt("stock"));
        return p;
    }

    public List<Product> all() {
        List<Product> list = new ArrayList<>();
        String sql = BASE_SELECT + "WHERE p.status = 1 ORDER BY p.id DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(mapProduct(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Product> allForAdmin() {
        List<Product> list = new ArrayList<>();
        String sql = BASE_SELECT + "ORDER BY p.id DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Product p = mapProduct(rs);
                p.setVariants(getVariantsByProductId(p.getId()));
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Product> filter(String keyword, Integer categoryId, Double minPrice, Double maxPrice, String sort) {
        List<Product> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(BASE_SELECT).append("WHERE p.status = 1 ");

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (p.name LIKE ? OR p.description LIKE ? OR c.name LIKE ?) ");
        }
        if (categoryId != null && categoryId > 0) {
            sql.append("AND p.category_id = ? ");
        }
        if (minPrice != null && minPrice > 0) {
            sql.append("AND p.price >= ? ");
        }
        if (maxPrice != null && maxPrice > 0) {
            sql.append("AND p.price <= ? ");
        }

        if ("price_asc".equalsIgnoreCase(sort)) {
            sql.append("ORDER BY p.price ASC");
        } else if ("price_desc".equalsIgnoreCase(sort)) {
            sql.append("ORDER BY p.price DESC");
        } else {
            sql.append("ORDER BY p.id DESC");
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                String pattern = "%" + keyword.trim() + "%";
                ps.setString(idx++, pattern);
                ps.setString(idx++, pattern);
                ps.setString(idx++, pattern);
            }
            if (categoryId != null && categoryId > 0) {
                ps.setInt(idx++, categoryId);
            }
            if (minPrice != null && minPrice > 0) {
                ps.setDouble(idx++, minPrice);
            }
            if (maxPrice != null && maxPrice > 0) {
                ps.setDouble(idx++, maxPrice);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapProduct(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Product> search(String keyword) {
        return filter(keyword, null, null, null, null);
    }

    public List<Product> byCategory(int categoryId) {
        return filter(null, categoryId, null, null, null);
    }

    public Product byId(int id) {
        String sql = BASE_SELECT + "WHERE p.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Product p = mapProduct(rs);
                    p.setVariants(getVariantsByProductId(id));
                    return p;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<ProductVariant> getVariantsByProductId(int productId) {
        List<ProductVariant> list = new ArrayList<>();
        String sql = "SELECT * FROM product_variants WHERE product_id = ? ORDER BY id ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new ProductVariant(
                            rs.getInt("id"),
                            rs.getInt("product_id"),
                            rs.getString("sku"),
                            rs.getString("size"),
                            rs.getString("color"),
                            rs.getInt("quantity")
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public ProductVariant getVariantById(int variantId) {
        String sql = "SELECT * FROM product_variants WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, variantId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new ProductVariant(
                            rs.getInt("id"),
                            rs.getInt("product_id"),
                            rs.getString("sku"),
                            rs.getString("size"),
                            rs.getString("color"),
                            rs.getInt("quantity")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public ProductVariant findVariant(int productId, String size, String color) {
        String sql = "SELECT * FROM product_variants WHERE product_id = ? AND size = ? AND color = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setString(2, size);
            ps.setString(3, color);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new ProductVariant(
                            rs.getInt("id"),
                            rs.getInt("product_id"),
                            rs.getString("sku"),
                            rs.getString("size"),
                            rs.getString("color"),
                            rs.getInt("quantity")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int add(Product product) {
        String sql = "INSERT INTO products (category_id, name, description, price, original_price, image, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, product.getCategoryId());
            ps.setString(2, product.getName());
            ps.setString(3, product.getDescription());
            ps.setDouble(4, product.getPrice());
            ps.setDouble(5, product.getOriginalPrice());
            ps.setString(6, product.getImage());
            ps.setInt(7, product.getStatus());
            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public boolean addVariant(ProductVariant variant) {
        String sql = "INSERT INTO product_variants (product_id, sku, size, color, quantity) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, variant.getProductId());
            ps.setString(2, variant.getSku());
            ps.setString(3, variant.getSize());
            ps.setString(4, variant.getColor());
            ps.setInt(5, variant.getQuantity());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean update(Product product) {
        String sql = "UPDATE products SET category_id = ?, name = ?, description = ?, price = ?, " +
                     "original_price = ?, image = ?, status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, product.getCategoryId());
            ps.setString(2, product.getName());
            ps.setString(3, product.getDescription());
            ps.setDouble(4, product.getPrice());
            ps.setDouble(5, product.getOriginalPrice());
            ps.setString(6, product.getImage());
            ps.setInt(7, product.getStatus());
            ps.setInt(8, product.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean delete(int id) {
        String sql = "UPDATE products SET status = 0 WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateVariantQuantity(int variantId, int newQuantity) {
        String sql = "UPDATE product_variants SET quantity = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, newQuantity);
            ps.setInt(2, variantId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<ProductVariant> getLowStockVariants(int threshold) {
        List<ProductVariant> list = new ArrayList<>();
        String sql = "SELECT v.*, p.name AS product_name FROM product_variants v " +
                     "JOIN products p ON v.product_id = p.id " +
                     "WHERE v.quantity <= ? AND p.status = 1 ORDER BY v.quantity ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, threshold);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProductVariant pv = new ProductVariant();
                    pv.setId(rs.getInt("id"));
                    pv.setProductId(rs.getInt("product_id"));
                    pv.setSku(rs.getString("sku") + " (" + rs.getString("product_name") + ")");
                    pv.setSize(rs.getString("size"));
                    pv.setColor(rs.getString("color"));
                    pv.setQuantity(rs.getInt("quantity"));
                    list.add(pv);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}