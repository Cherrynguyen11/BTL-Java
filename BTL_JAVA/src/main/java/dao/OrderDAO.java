package dao;

import model.*;
import utils.DBConnection;

import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.Date;

public class OrderDAO {

    private String generateOrderCode(String prefix) {
        String timestamp = new SimpleDateFormat("yyMMdd-HHmmss").format(new Date());
        int random = new Random().nextInt(900) + 100;
        return prefix + "-" + timestamp + "-" + random;
    }

    // 1. Tạo đơn hàng Online (Website E-commerce)
    public Order createOnlineOrder(Integer userId, String customerName, String phone, String address,
                                   String paymentMethod, String notes, List<CartItem> cartItems, double discountAmount) throws Exception {
        Connection conn = DBConnection.getConnection();
        conn.setAutoCommit(false);
        try {
            double totalItems = 0;
            for (CartItem item : cartItems) {
                totalItems += item.getSubtotal();
            }
            double finalTotal = Math.max(0, totalItems - discountAmount);

            String orderCode = generateOrderCode("WEB");
            String paymentStatus = "TRANSFER".equalsIgnoreCase(paymentMethod) ? "PAID" : "UNPAID";

            String insertOrderSql = "INSERT INTO orders (order_code, user_id, customer_name, phone, shipping_address, " +
                    "channel, payment_method, payment_status, discount_amount, total_amount, status, notes) " +
                    "VALUES (?, ?, ?, ?, ?, 'WEBSITE', ?, ?, ?, ?, 'PENDING', ?)";

            PreparedStatement psOrder = conn.prepareStatement(insertOrderSql, Statement.RETURN_GENERATED_KEYS);
            psOrder.setString(1, orderCode);
            if (userId != null && userId > 0) {
                psOrder.setInt(2, userId);
            } else {
                psOrder.setNull(2, Types.INTEGER);
            }
            psOrder.setString(3, customerName);
            psOrder.setString(4, phone);
            psOrder.setString(5, address);
            psOrder.setString(6, paymentMethod);
            psOrder.setString(7, paymentStatus);
            psOrder.setDouble(8, discountAmount);
            psOrder.setDouble(9, finalTotal);
            psOrder.setString(10, notes);
            psOrder.executeUpdate();

            ResultSet rsKey = psOrder.getGeneratedKeys();
            if (!rsKey.next()) {
                throw new SQLException("Không tạo được mã đơn hàng!");
            }
            int orderId = rsKey.getInt(1);

            // Chi tiết đơn hàng và trừ tồn kho
            String insertDetailSql = "INSERT INTO order_details (order_id, product_id, variant_id, size, color, quantity, price, subtotal) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            String updateStockSql = "UPDATE product_variants SET quantity = quantity - ? WHERE id = ? AND quantity >= ?";

            PreparedStatement psDetail = conn.prepareStatement(insertDetailSql);
            PreparedStatement psStock = conn.prepareStatement(updateStockSql);

            for (CartItem item : cartItems) {
                psDetail.setInt(1, orderId);
                psDetail.setInt(2, item.getProduct().getId());
                if (item.getVariant() != null) {
                    psDetail.setInt(3, item.getVariant().getId());
                } else {
                    psDetail.setNull(3, Types.INTEGER);
                }
                psDetail.setString(4, item.getSize());
                psDetail.setString(5, item.getColor());
                psDetail.setInt(6, item.getQuantity());
                psDetail.setDouble(7, item.getProduct().getPrice());
                psDetail.setDouble(8, item.getSubtotal());
                psDetail.addBatch();

                if (item.getVariant() != null) {
                    psStock.setInt(1, item.getQuantity());
                    psStock.setInt(2, item.getVariant().getId());
                    psStock.setInt(3, item.getQuantity());
                    psStock.addBatch();
                }
            }

            psDetail.executeBatch();
            psStock.executeBatch();

            conn.commit();
            return byId(orderId);
        } catch (Exception e) {
            conn.rollback();
            throw e;
        } finally {
            conn.setAutoCommit(true);
            conn.close();
        }
    }

    // 2. Tạo hóa đơn bán hàng tại quầy (Store POS)
    public Order createPOSOrder(Integer staffId, String customerName, String phone, String paymentMethod,
                                double discountAmount, List<CartItem> items) throws Exception {
        Connection conn = DBConnection.getConnection();
        conn.setAutoCommit(false);
        try {
            double totalItems = 0;
            for (CartItem item : items) {
                totalItems += item.getSubtotal();
            }
            double finalTotal = Math.max(0, totalItems - discountAmount);
            String orderCode = generateOrderCode("POS");

            String insertOrderSql = "INSERT INTO orders (order_code, user_id, customer_name, phone, shipping_address, " +
                    "channel, payment_method, payment_status, discount_amount, total_amount, status, staff_id, notes) " +
                    "VALUES (?, NULL, ?, ?, 'Bán trực tiếp tại cửa hàng', 'STORE_POS', ?, 'PAID', ?, ?, 'COMPLETED', ?, 'Hóa đơn POS tại quầy')";

            PreparedStatement psOrder = conn.prepareStatement(insertOrderSql, Statement.RETURN_GENERATED_KEYS);
            psOrder.setString(1, orderCode);
            psOrder.setString(2, customerName != null && !customerName.trim().isEmpty() ? customerName : "Khách lẻ tại quầy");
            psOrder.setString(3, phone != null && !phone.trim().isEmpty() ? phone : "---");
            psOrder.setString(4, paymentMethod);
            psOrder.setDouble(5, discountAmount);
            psOrder.setDouble(6, finalTotal);
            if (staffId != null) {
                psOrder.setInt(7, staffId);
            } else {
                psOrder.setNull(7, Types.INTEGER);
            }
            psOrder.executeUpdate();

            ResultSet rsKey = psOrder.getGeneratedKeys();
            if (!rsKey.next()) {
                throw new SQLException("Không tạo được mã đơn hàng POS!");
            }
            int orderId = rsKey.getInt(1);

            String insertDetailSql = "INSERT INTO order_details (order_id, product_id, variant_id, size, color, quantity, price, subtotal) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            String updateStockSql = "UPDATE product_variants SET quantity = quantity - ? WHERE id = ? AND quantity >= ?";

            PreparedStatement psDetail = conn.prepareStatement(insertDetailSql);
            PreparedStatement psStock = conn.prepareStatement(updateStockSql);

            for (CartItem item : items) {
                psDetail.setInt(1, orderId);
                psDetail.setInt(2, item.getProduct().getId());
                if (item.getVariant() != null) {
                    psDetail.setInt(3, item.getVariant().getId());
                } else {
                    psDetail.setNull(3, Types.INTEGER);
                }
                psDetail.setString(4, item.getSize());
                psDetail.setString(5, item.getColor());
                psDetail.setInt(6, item.getQuantity());
                psDetail.setDouble(7, item.getProduct().getPrice());
                psDetail.setDouble(8, item.getSubtotal());
                psDetail.addBatch();

                if (item.getVariant() != null) {
                    psStock.setInt(1, item.getQuantity());
                    psStock.setInt(2, item.getVariant().getId());
                    psStock.setInt(3, item.getQuantity());
                    psStock.addBatch();
                }
            }

            psDetail.executeBatch();
            psStock.executeBatch();

            conn.commit();
            return byId(orderId);
        } catch (Exception e) {
            conn.rollback();
            throw e;
        } finally {
            conn.setAutoCommit(true);
            conn.close();
        }
    }

    // 3. Tiếp nhận đơn sàn TMĐT ngoại (Shopee / TikTok Shop)
    public Order createExternalOrder(String channel, String customerName, String phone, String address,
                                     int productId, int variantId, String size, String color, int quantity, double price) throws Exception {
        Connection conn = DBConnection.getConnection();
        conn.setAutoCommit(false);
        try {
            String prefix = "SHOPEE".equalsIgnoreCase(channel) ? "SP" : "TT";
            String orderCode = generateOrderCode(prefix);
            double total = price * quantity;

            String insertOrderSql = "INSERT INTO orders (order_code, customer_name, phone, shipping_address, channel, " +
                    "payment_method, payment_status, total_amount, status, notes) " +
                    "VALUES (?, ?, ?, ?, ?, 'TRANSFER', 'PAID', ?, 'PROCESSING', ?)";

            PreparedStatement psOrder = conn.prepareStatement(insertOrderSql, Statement.RETURN_GENERATED_KEYS);
            psOrder.setString(1, orderCode);
            psOrder.setString(2, customerName);
            psOrder.setString(3, phone);
            psOrder.setString(4, address);
            psOrder.setString(5, channel.toUpperCase());
            psOrder.setDouble(6, total);
            psOrder.setString(7, "Đơn hàng đồng bộ tự động từ " + channel);
            psOrder.executeUpdate();

            ResultSet rsKey = psOrder.getGeneratedKeys();
            if (!rsKey.next()) throw new SQLException("Lỗi tạo đơn sàn TMĐT!");
            int orderId = rsKey.getInt(1);

            String insertDetail = "INSERT INTO order_details (order_id, product_id, variant_id, size, color, quantity, price, subtotal) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement psDetail = conn.prepareStatement(insertDetail);
            psDetail.setInt(1, orderId);
            psDetail.setInt(2, productId);
            psDetail.setInt(3, variantId);
            psDetail.setString(4, size);
            psDetail.setString(5, color);
            psDetail.setInt(6, quantity);
            psDetail.setDouble(7, price);
            psDetail.setDouble(8, total);
            psDetail.executeUpdate();

            // Trừ kho
            String updateStock = "UPDATE product_variants SET quantity = quantity - ? WHERE id = ?";
            PreparedStatement psStock = conn.prepareStatement(updateStock);
            psStock.setInt(1, quantity);
            psStock.setInt(2, variantId);
            psStock.executeUpdate();

            conn.commit();
            return byId(orderId);
        } catch (Exception e) {
            conn.rollback();
            throw e;
        } finally {
            conn.setAutoCommit(true);
            conn.close();
        }
    }

    // 4. Cập nhật trạng thái đơn hàng (Tự động hoàn kho nếu hủy đơn CANCELLED)
    public boolean updateStatus(int orderId, String newStatus) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Kiểm tra trạng thái cũ
            String checkSql = "SELECT status FROM orders WHERE id = ?";
            String currentStatus = "";
            try (PreparedStatement psCheck = conn.prepareStatement(checkSql)) {
                psCheck.setInt(1, orderId);
                try (ResultSet rs = psCheck.executeQuery()) {
                    if (rs.next()) currentStatus = rs.getString("status");
                }
            }

            // Nếu đơn cũ chưa hủy mà trạng thái mới là CANCELLED -> Hoàn trả tồn kho
            if (!"CANCELLED".equalsIgnoreCase(currentStatus) && "CANCELLED".equalsIgnoreCase(newStatus)) {
                String getItemsSql = "SELECT variant_id, quantity FROM order_details WHERE order_id = ? AND variant_id IS NOT NULL";
                try (PreparedStatement psItems = conn.prepareStatement(getItemsSql)) {
                    psItems.setInt(1, orderId);
                    try (ResultSet rsItems = psItems.executeQuery()) {
                        String restoreStockSql = "UPDATE product_variants SET quantity = quantity + ? WHERE id = ?";
                        try (PreparedStatement psRestore = conn.prepareStatement(restoreStockSql)) {
                            while (rsItems.next()) {
                                psRestore.setInt(1, rsItems.getInt("quantity"));
                                psRestore.setInt(2, rsItems.getInt("variant_id"));
                                psRestore.addBatch();
                            }
                            psRestore.executeBatch();
                        }
                    }
                }
            }

            // Cập nhật trạng thái đơn hàng
            String updateOrderSql = "UPDATE orders SET status = ? WHERE id = ?";
            try (PreparedStatement psUpdate = conn.prepareStatement(updateOrderSql)) {
                psUpdate.setString(1, newStatus);
                psUpdate.setInt(2, orderId);
                psUpdate.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ignored) {}
            }
            return false;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ignored) {}
            }
        }
    }

    // 5. Lấy đơn hàng theo ID kèm danh sách mặt hàng
    public Order byId(int orderId) {
        String sql = "SELECT o.*, s.full_name AS staff_name FROM orders o " +
                     "LEFT JOIN users s ON o.staff_id = s.id WHERE o.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Order o = mapOrder(rs);
                    o.setItems(getOrderDetails(orderId));
                    return o;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // 6. Lấy danh sách mặt hàng của đơn
    public List<OrderDetail> getOrderDetails(int orderId) {
        List<OrderDetail> list = new ArrayList<>();
        String sql = "SELECT d.*, p.name AS product_name, p.image AS product_image " +
                     "FROM order_details d JOIN products p ON d.product_id = p.id " +
                     "WHERE d.order_id = ? ORDER BY d.id ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderDetail od = new OrderDetail();
                    od.setId(rs.getInt("id"));
                    od.setOrderId(rs.getInt("order_id"));
                    od.setProductId(rs.getInt("product_id"));
                    od.setProductName(rs.getString("product_name"));
                    od.setProductImage(rs.getString("product_image"));
                    int varId = rs.getInt("variant_id");
                    od.setVariantId(rs.wasNull() ? null : varId);
                    od.setSize(rs.getString("size"));
                    od.setColor(rs.getString("color"));
                    od.setQuantity(rs.getInt("quantity"));
                    od.setPrice(rs.getDouble("price"));
                    od.setSubtotal(rs.getDouble("subtotal"));
                    list.add(od);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 7. Lấy danh sách đơn theo khách hàng
    public List<Order> byUser(int userId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, NULL AS staff_name FROM orders o WHERE o.user_id = ? ORDER BY o.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order o = mapOrder(rs);
                    o.setItems(getOrderDetails(o.getId()));
                    list.add(o);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 8. Lấy toàn bộ đơn hàng lọc theo kênh, trạng thái và từ khóa
    public List<Order> filter(String channel, String status, String keyword) {
        List<Order> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT o.*, s.full_name AS staff_name FROM orders o " +
                "LEFT JOIN users s ON o.staff_id = s.id WHERE 1=1 ");

        if (channel != null && !channel.trim().isEmpty() && !"ALL".equalsIgnoreCase(channel)) {
            sql.append("AND o.channel = ? ");
        }
        if (status != null && !status.trim().isEmpty() && !"ALL".equalsIgnoreCase(status)) {
            sql.append("AND o.status = ? ");
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (o.order_code LIKE ? OR o.customer_name LIKE ? OR o.phone LIKE ?) ");
        }
        sql.append("ORDER BY o.id DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            if (channel != null && !channel.trim().isEmpty() && !"ALL".equalsIgnoreCase(channel)) {
                ps.setString(idx++, channel.toUpperCase());
            }
            if (status != null && !status.trim().isEmpty() && !"ALL".equalsIgnoreCase(status)) {
                ps.setString(idx++, status.toUpperCase());
            }
            if (keyword != null && !keyword.trim().isEmpty()) {
                String pat = "%" + keyword.trim() + "%";
                ps.setString(idx++, pat);
                ps.setString(idx++, pat);
                ps.setString(idx++, pat);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order o = mapOrder(rs);
                    o.setItems(getOrderDetails(o.getId()));
                    list.add(o);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Order> all() {
        return filter(null, null, null);
    }

    // 9. Thống kê Đa Kênh Toàn Diện (Omnichannel Analytics BI)
    public OmniStats getOmniStats() {
        OmniStats stats = new OmniStats();
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {

            // Tổng quan KPI
            String kpiSql = "SELECT " +
                    "(SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE status <> 'CANCELLED') AS total_rev, " +
                    "(SELECT COUNT(*) FROM orders) AS total_ord, " +
                    "(SELECT COUNT(*) FROM products WHERE status = 1) AS total_prod, " +
                    "(SELECT COUNT(*) FROM users WHERE role = 'CUSTOMER') AS total_cust";
            try (ResultSet rs = stmt.executeQuery(kpiSql)) {
                if (rs.next()) {
                    stats.setTotalRevenue(rs.getDouble("total_rev"));
                    stats.setTotalOrders(rs.getInt("total_ord"));
                    stats.setTotalProducts(rs.getInt("total_prod"));
                    stats.setTotalCustomers(rs.getInt("total_cust"));
                }
            }

            // Doanh thu và số đơn theo Kênh bán (Omnichannel breakdown)
            String channelSql = "SELECT channel, COUNT(*) AS ord_count, COALESCE(SUM(total_amount), 0) AS rev " +
                    "FROM orders WHERE status <> 'CANCELLED' GROUP BY channel";
            try (ResultSet rs = stmt.executeQuery(channelSql)) {
                while (rs.next()) {
                    String ch = rs.getString("channel");
                    stats.getRevenueByChannel().put(ch, rs.getDouble("rev"));
                    stats.getOrdersByChannel().put(ch, rs.getInt("ord_count"));
                }
            }

            // Top 5 sản phẩm bán chạy nhất
            String topSql = "SELECT p.id, p.name, p.price, p.image, c.name AS category_name, SUM(d.quantity) AS sold " +
                    "FROM order_details d JOIN products p ON d.product_id = p.id " +
                    "JOIN categories c ON p.category_id = c.id " +
                    "JOIN orders o ON d.order_id = o.id " +
                    "WHERE o.status <> 'CANCELLED' " +
                    "GROUP BY p.id, p.name, p.price, p.image, c.name " +
                    "ORDER BY sold DESC LIMIT 5";
            List<Product> topProducts = new ArrayList<>();
            try (ResultSet rs = stmt.executeQuery(topSql)) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setId(rs.getInt("id"));
                    p.setName(rs.getString("name"));
                    p.setPrice(rs.getDouble("price"));
                    p.setImage(rs.getString("image"));
                    p.setCategoryName(rs.getString("category_name"));
                    p.setStock(rs.getInt("sold")); // mượn trường stock để chứa số lượng đã bán
                    topProducts.add(p);
                }
            }
            stats.setTopSellingProducts(topProducts);

            // Cảnh báo tồn kho thấp
            stats.setLowStockVariants(new ProductDAO().getLowStockVariants(10));

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }

    // Tương thích ngược với các trang cũ
    public Map<String, Object> stats() {
        OmniStats s = getOmniStats();
        Map<String, Object> map = new HashMap<>();
        map.put("revenue", s.getTotalRevenue());
        map.put("orders", s.getTotalOrders());
        map.put("products", s.getTotalProducts());
        map.put("users", s.getTotalCustomers());
        return map;
    }

    public boolean status(int id, String s) {
        return updateStatus(id, s);
    }

    private Order mapOrder(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setId(rs.getInt("id"));
        o.setOrderCode(rs.getString("order_code"));
        int uid = rs.getInt("user_id");
        o.setUserId(rs.wasNull() ? null : uid);
        o.setCustomerName(rs.getString("customer_name"));
        o.setPhone(rs.getString("phone"));
        o.setAddress(rs.getString("shipping_address"));
        o.setChannel(rs.getString("channel"));
        o.setPaymentMethod(rs.getString("payment_method"));
        o.setPaymentStatus(rs.getString("payment_status"));
        o.setDiscountAmount(rs.getDouble("discount_amount"));
        o.setTotalAmount(rs.getDouble("total_amount"));
        o.setStatus(rs.getString("status"));
        int sid = rs.getInt("staff_id");
        o.setStaffId(rs.wasNull() ? null : sid);
        o.setStaffName(rs.getString("staff_name"));
        o.setNotes(rs.getString("notes"));
        o.setCreatedAt(rs.getTimestamp("created_at"));
        return o;
    }
}