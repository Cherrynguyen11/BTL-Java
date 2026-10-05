package dao;

import model.Voucher;
import utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VoucherDAO {

    public Voucher byCode(String code) {
        if (code == null || code.trim().isEmpty()) return null;
        String sql = "SELECT * FROM vouchers WHERE code = ? AND status = 1 AND (expired_at IS NULL OR expired_at >= CURRENT_DATE())";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code.trim().toUpperCase());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Voucher v = new Voucher();
                    v.setId(rs.getInt("id"));
                    v.setCode(rs.getString("code"));
                    v.setDiscountPercent(rs.getDouble("discount_percent"));
                    v.setDiscountMax(rs.getDouble("discount_max"));
                    v.setMinOrderValue(rs.getDouble("min_order_value"));
                    v.setStatus(rs.getInt("status"));
                    v.setExpiredAt(rs.getDate("expired_at"));
                    return v;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Voucher> all() {
        List<Voucher> list = new ArrayList<>();
        String sql = "SELECT * FROM vouchers ORDER BY id DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Voucher v = new Voucher();
                v.setId(rs.getInt("id"));
                v.setCode(rs.getString("code"));
                v.setDiscountPercent(rs.getDouble("discount_percent"));
                v.setDiscountMax(rs.getDouble("discount_max"));
                v.setMinOrderValue(rs.getDouble("min_order_value"));
                v.setStatus(rs.getInt("status"));
                v.setExpiredAt(rs.getDate("expired_at"));
                list.add(v);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean add(Voucher v) {
        String sql = "INSERT INTO vouchers (code, discount_percent, discount_max, min_order_value, status, expired_at) VALUES (?, ?, ?, ?, 1, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, v.getCode().toUpperCase());
            ps.setDouble(2, v.getDiscountPercent());
            ps.setDouble(3, v.getDiscountMax());
            ps.setDouble(4, v.getMinOrderValue());
            ps.setDate(5, v.getExpiredAt());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
