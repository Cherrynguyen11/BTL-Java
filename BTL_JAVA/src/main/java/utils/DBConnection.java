package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/fashion_store?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Ho_Chi_Minh&allowPublicKeyRetrieval=true&useSSL=false";
    private static final String USER = "root";
    private static final String[] PASSWORDS = {"dungnv060505", "123456", "root", ""};

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            throw new RuntimeException("Không tìm thấy MySQL Driver: " + e.getMessage());
        }
    }

    public static Connection getConnection() throws SQLException {
        // Thử mật khẩu đã biết
        for (String pwd : PASSWORDS) {
            try {
                return DriverManager.getConnection(URL, USER, pwd);
            } catch (SQLException ignored) {
                // Thử mật khẩu tiếp theo
            }
        }
        // Thử lần cuối với mật khẩu mặc định để ném lỗi cụ thể nếu không kết nối được
        return DriverManager.getConnection(URL, USER, PASSWORDS[0]);
    }
}