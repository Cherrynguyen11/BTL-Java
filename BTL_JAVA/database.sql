-- Cơ sở dữ liệu Bán Lẻ Thời Trang Đa Kênh (FashionStore Omnichannel)
CREATE DATABASE IF NOT EXISTS fashion_store CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE fashion_store;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS order_details;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS product_variants;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS vouchers;
DROP TABLE IF EXISTS stock_transactions;
SET FOREIGN_KEY_CHECKS = 1;

-- 1. Bảng Người dùng & Phân quyền
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    address VARCHAR(255),
    role ENUM('ADMIN', 'STAFF', 'CUSTOMER') DEFAULT 'CUSTOMER',
    status TINYINT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. Bảng Danh mục thời trang
CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    icon VARCHAR(50) DEFAULT 'fa-tshirt'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. Bảng Sản phẩm thời trang
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    price DECIMAL(12, 2) NOT NULL,
    original_price DECIMAL(12, 2) DEFAULT 0,
    image VARCHAR(500),
    status TINYINT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. Bảng Biến thể sản phẩm (Size & Màu sắc, Tồn kho tập trung)
CREATE TABLE product_variants (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    sku VARCHAR(50) UNIQUE,
    size VARCHAR(20) NOT NULL,
    color VARCHAR(50) NOT NULL,
    quantity INT DEFAULT 0,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 5. Bảng Mã giảm giá (Vouchers)
CREATE TABLE vouchers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(50) UNIQUE NOT NULL,
    discount_percent DECIMAL(5, 2) DEFAULT 0,
    discount_max DECIMAL(12, 2) DEFAULT 0,
    min_order_value DECIMAL(12, 2) DEFAULT 0,
    status TINYINT DEFAULT 1,
    expired_at DATE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 6. Bảng Đơn hàng Đa Kênh (Omnichannel Orders)
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_code VARCHAR(50) UNIQUE NOT NULL,
    user_id INT NULL,
    customer_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    shipping_address VARCHAR(255),
    channel ENUM('STORE_POS', 'WEBSITE', 'SHOPEE', 'TIKTOK') DEFAULT 'WEBSITE',
    payment_method ENUM('CASH', 'TRANSFER', 'COD') DEFAULT 'COD',
    payment_status ENUM('PAID', 'UNPAID') DEFAULT 'UNPAID',
    discount_amount DECIMAL(12, 2) DEFAULT 0,
    total_amount DECIMAL(12, 2) NOT NULL,
    status ENUM('PENDING', 'CONFIRMED', 'PROCESSING', 'SHIPPING', 'COMPLETED', 'CANCELLED') DEFAULT 'PENDING',
    staff_id INT NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (staff_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 7. Bảng Chi tiết Đơn hàng
CREATE TABLE order_details (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    variant_id INT NULL,
    size VARCHAR(20),
    color VARCHAR(50),
    quantity INT NOT NULL,
    price DECIMAL(12, 2) NOT NULL,
    subtotal DECIMAL(12, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (variant_id) REFERENCES product_variants(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 8. Bảng Lịch sử Nhập/Xuất kho (Stock Adjustment)
CREATE TABLE stock_transactions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    variant_id INT NOT NULL,
    type ENUM('IMPORT', 'EXPORT', 'ADJUST') NOT NULL,
    quantity INT NOT NULL,
    reason VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (variant_id) REFERENCES product_variants(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- DỮ LIỆU KHỞI TẠO MẪU (SEED DATA)
-- ============================================================

-- Tài khoản: admin/123456, staff/123456, user/123456
INSERT INTO users (username, password, full_name, email, phone, address, role, status) VALUES
('admin', '123456', 'Nguyễn Hoàng Long (Admin)', 'admin@fashionstore.vn', '0901234567', 'Trụ sở chính - Hoàn Kiếm, Hà Nội', 'ADMIN', 1),
('staff', '123456', 'Trần Thu Ngân (Staff POS)', 'staff@fashionstore.vn', '0912345678', 'Showroom Vincom Bà Triệu, Hà Nội', 'STAFF', 1),
('user', '123456', 'Lê Hải Đăng (Khách hàng)', 'haidang@gmail.com', '0987654321', 'Số 88 Cầu Giấy, Cầu Giấy, Hà Nội', 'CUSTOMER', 1),
('customer2', '123456', 'Phạm Quỳnh Nga', 'quynhnga@gmail.com', '0978112233', '120 Nguyễn Huệ, Quận 1, TP.HCM', 'CUSTOMER', 1);

-- Danh mục thời trang
INSERT INTO categories (id, name, description, icon) VALUES
(1, 'Áo Sơ Mi & Áo Polo', 'Thời trang công sở và dạo phố lịch lãm', '👔'),
(2, 'Áo Thun Basic & Graphic', 'Chất liệu 100% Cotton thoáng mát, phong cách năng động', '👕'),
(3, 'Quần Jeans & Kaki', 'Quần âu, jeans dáng slim-fit và ống đứng thời thượng', '👖'),
(4, 'Váy Đầm & Chân Váy', 'Thiết kế sang trọng, tinh tế cho phái đẹp', '👗'),
(5, 'Áo Khoác & Blazer', 'Áo khoác gió, bomber, măng tô và blazer thanh lịch', '🧥'),
(6, 'Phụ Kiện & Giày Dép', 'Sneakers, thắt lưng da, túi xách thời trang', '👟');

-- Sản phẩm thời trang
INSERT INTO products (id, category_id, name, description, price, original_price, image, status) VALUES
(1, 1, 'Áo Sơ Mi Oxford Slimfit Trắng', 'Chất vải Oxford dệt cao cấp, chống nhăn, phom dáng tôn vinh vẻ lịch lãm của quý ông.', 389000, 450000, 'https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?w=800', 1),
(2, 2, 'Áo Thun Cotton Compact 280GSM', 'Dệt từ sợi bông chải kỹ tự nhiên 280GSM dày dặn, đứng form, không bai dão sau nhiều lần giặt.', 249000, 299000, 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=800', 1),
(3, 1, 'Áo Polo Thể Thao Phối Viền Cổ', 'Vải cá sấu poly-cotton co giãn 4 chiều, thấm hút mồ hôi cực tốt khi vận động ngoài trời.', 329000, 399000, 'https://images.unsplash.com/photo-1586363104862-3a5e2ab60d99?w=800', 1),
(4, 3, 'Quần Jeans Selvedge Denim Xanh Chàm', 'Vải denim dệt biên cổ điển cá tính, đường may chỉ vàng sắc sảo, độ bền vượt trội theo năm tháng.', 599000, 750000, 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=800', 1),
(5, 3, 'Quần Tây Âu Co Giãn Dáng Hàn', 'Chất vải tuyết mưa nhập khẩu mềm mịn, tôn dáng người mặc, phù hợp môi trường công sở chuyên nghiệp.', 489000, 560000, 'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=800', 1),
(6, 4, 'Đầm Voan Hoa Nhí Dáng Chữ A', 'Phong cách vintage Pháp nữ tính, chất voan tơ mềm lượn bay bổng, có lớp lót lụa habutai cao cấp.', 549000, 680000, 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=800', 1),
(7, 5, 'Áo Blazer Unisex Dáng Rộng Phong Cách', 'Thiết kế độn vai nhẹ, đường may 2 lớp cao cấp, dễ phối với áo thun hoặc áo sơ mi cho outfit thanh lịch.', 890000, 1150000, 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=800', 1),
(8, 6, 'Giày Sneaker Da Minimalist Trắng', 'Chất liệu da bò thật mềm mại, đế cao su nguyên khối êm chân, phối màu đơn giản phù hợp mọi trang phục.', 850000, 990000, 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800', 1);

-- Biến thể sản phẩm (Size & Màu sắc, Tồn kho tập trung)
INSERT INTO product_variants (product_id, sku, size, color, quantity) VALUES
(1, 'SM-OX-W-M', 'M', 'Trắng', 25),
(1, 'SM-OX-W-L', 'L', 'Trắng', 30),
(1, 'SM-OX-B-M', 'M', 'Xanh Nhạt', 18),
(1, 'SM-OX-B-L', 'L', 'Xanh Nhạt', 22),

(2, 'TS-CP-W-L', 'L', 'Trắng', 40),
(2, 'TS-CP-B-L', 'L', 'Đen', 35),
(2, 'TS-CP-G-XL', 'XL', 'Xám Tiêu', 15),

(3, 'PL-CS-N-M', 'M', 'Xanh Navy', 20),
(3, 'PL-CS-N-L', 'L', 'Xanh Navy', 28),
(3, 'PL-CS-W-L', 'L', 'Trắng Sữa', 22),

(4, 'JN-SV-30', '30', 'Xanh Chàm', 12),
(4, 'JN-SV-31', '31', 'Xanh Chàm', 14),
(4, 'JN-SV-32', '32', 'Xanh Chàm', 8),

(5, 'QT-AH-30', '30', 'Đen', 16),
(5, 'QT-AH-31', '31', 'Đen', 20),
(5, 'QT-AH-32', '32', 'Ghi Đậm', 10),

(6, 'DV-VH-S', 'S', 'Hoa Vàng', 10),
(6, 'DV-VH-M', 'M', 'Hoa Vàng', 12),
(6, 'DV-VH-L', 'L', 'Hoa Xanh', 6),

(7, 'BZ-OV-M', 'M', 'Đen Tuyển', 15),
(7, 'BZ-OV-L', 'L', 'Nâu Be', 12),

(8, 'SN-MN-40', '40', 'Trắng Đế Trắng', 8),
(8, 'SN-MN-41', '41', 'Trắng Đế Trắng', 10),
(8, 'SN-MN-42', '42', 'Trắng Đế Trắng', 4);

-- Mã giảm giá khuyến mãi (Vouchers)
INSERT INTO vouchers (code, discount_percent, discount_max, min_order_value, status, expired_at) VALUES
('FASHION10', 10, 100000, 300000, 1, '2026-12-31'),
('VIP20', 20, 200000, 800000, 1, '2026-12-31'),
('SUMMER50K', 0, 50000, 500000, 1, '2026-12-31');

-- Đơn hàng Đa Kênh mẫu (Omnichannel Orders)
INSERT INTO orders (id, order_code, user_id, customer_name, phone, shipping_address, channel, payment_method, payment_status, discount_amount, total_amount, status, staff_id, notes, created_at) VALUES
(1, 'POS-2609-001', NULL, 'Khách lẻ tại quầy', '0905123456', 'Tại quầy Store Bà Triệu', 'STORE_POS', 'CASH', 'PAID', 0, 638000, 'COMPLETED', 2, 'Khách mua thử trực tiếp tại cửa hàng', NOW() - INTERVAL 2 DAY),
(2, 'WEB-2609-002', 3, 'Lê Hải Đăng', '0987654321', 'Số 88 Cầu Giấy, Cầu Giấy, Hà Nội', 'WEBSITE', 'TRANSFER', 'PAID', 50000, 848000, 'COMPLETED', NULL, 'Chuyển khoản VietQR thành công', NOW() - INTERVAL 1 DAY),
(3, 'SP-2609-003', NULL, 'Nguyễn Văn Minh (Shopee)', '0912445566', 'Khu Đô Thị Ecopark, Hưng Yên', 'SHOPEE', 'TRANSFER', 'PAID', 0, 599000, 'SHIPPING', 2, 'Đơn từ gian hàng Shopee Mall', NOW() - INTERVAL 12 HOUR),
(4, 'TT-2609-004', NULL, 'Vũ Hoàng Yến (TikTok Shop)', '0933778899', 'Số 25 Lý Thường Kiệt, Hải Phòng', 'TIKTOK', 'COD', 'UNPAID', 30000, 519000, 'PROCESSING', 2, 'Livestream TikTok Mega Sale', NOW() - INTERVAL 4 HOUR),
(5, 'POS-2609-005', NULL, 'Trần Minh Khang', '0944556677', 'Tại quầy Store Bà Triệu', 'STORE_POS', 'TRANSFER', 'PAID', 0, 1147000, 'COMPLETED', 2, 'Quẹt mã QR tại quầy thu ngân', NOW() - INTERVAL 2 HOUR);

-- Chi tiết đơn hàng mẫu
INSERT INTO order_details (order_id, product_id, variant_id, size, color, quantity, price, subtotal) VALUES
(1, 1, 1, 'M', 'Trắng', 1, 389000, 389000),
(1, 2, 5, 'L', 'Trắng', 1, 249000, 249000),

(2, 7, 19, 'L', 'Nâu Be', 1, 890000, 890000),

(3, 4, 11, '30', 'Xanh Chàm', 1, 599000, 599000),

(4, 6, 17, 'M', 'Hoa Vàng', 1, 549000, 549000),

(5, 5, 14, '30', 'Đen', 1, 489000, 489000),
(5, 3, 8, 'L', 'Xanh Navy', 2, 329000, 658000);