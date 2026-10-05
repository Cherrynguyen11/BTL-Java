# Hệ Thống Quản Lý Bán Lẻ Thời Trang Đa Kênh (FashionStore Omnichannel)

Dự án chuyên đề môn học / đồ án tốt nghiệp xây dựng ứng dụng web thương mại & quản lý bán lẻ thời trang đa kênh (**Omnichannel Fashion Retail Management**) hoàn chỉnh theo chuẩn kiến trúc **MVC (Model - View - Controller)**.

---

## 1. Công Nghệ & Nền Tảng Sử Dụng

- **Ngôn ngữ & Runtime:** Java 17 LTS
- **Web Layer:** Java Servlet 6 (Jakarta EE 10), JSP (JavaServer Pages), JSTL 3.0 (`jakarta.tags.core`, `jakarta.tags.fmt`)
- **Database & Data Access:** MySQL 8.0, JDBC (PreparedStatement, Database Transaction Isolation `setAutoCommit(false)`, `commit()`, `rollback()`)
- **Web Server:** Apache Tomcat 10.1.59
- **Build Tool:** Apache Maven 3.6+
- **Giao diện (Frontend):** Modern Vanilla CSS, Google Fonts Plus Jakarta Sans, CSS Grid, Glassmorphism, Thermal Receipt print formatting (`@media print`)

---

## 2. Bản Chất Nghiệp Vụ Bán Lẻ Đa Kênh (Omnichannel Retail)

### A. Kênh Bán Hàng (Sales Channels)
1. **Kênh Bán Tại Quầy (Store POS - Point of Sale):**
   - Dành riêng cho Thu ngân / Nhân viên Showroom (`/pos`).
   - Màn hình POS 2 cột hiện đại: chọn nhanh danh mục, tìm kiếm mặt hàng, chọn Size / Màu sắc, tính tiền tự động.
   - Nhập chiết khấu, nhập tiền khách đưa, tự tính tiền thừa trả khách.
   - In hóa đơn bán lẻ tại quầy (`receipt thermal`) ngay khi thanh toán.
   - Trừ kho tự động ngay lập tức vào kho hàng trung tâm.
2. **Kênh Website E-Commerce Trực Tuyến:**
   - Khách hàng duyệt sản phẩm theo danh mục, lọc khoảng giá, sắp xếp.
   - Chọn biến thể (Kích thước: S, M, L, XL... & Màu sắc), kiểm tra tình trạng còn hàng.
   - Giỏ hàng thông minh, áp dụng mã khuyến mãi Voucher (`FASHION10`, `VIP20`).
   - Thanh toán COD hoặc **Chuyển khoản QR ngân hàng (Tự động render mã VietQR)**.
   - Theo dõi lịch sử đơn hàng cá nhân và tiến độ giao hàng.
3. **Kênh Đồng Bộ Sàn TMĐT (Shopee Mall & TikTok Shop):**
   - Tiếp nhận và phân loại đơn hàng theo kênh (`STORE_POS`, `WEBSITE`, `SHOPEE`, `TIKTOK`).
   - Hỗ trợ giả lập tạo đơn hàng sàn TMĐT để kiểm thử và báo cáo.

### B. Quản Lý Tồn Kho Tập Trung Real-time
- Tồn kho được quản lý theo từng biến thể sản phẩm (`product_variants`).
- Mọi kênh bán hàng đều tiêu thụ chung nguồn tồn kho này.
- Khi đơn hàng bị hủy (`CANCELLED`), hệ thống tự động hoàn lại số lượng tồn kho tương ứng.
- Cảnh báo tồn kho sắp hết (`<= 10 cái`) và màn hình nhập thêm hàng.

### C. Báo Cáo & Phân Tích Doanh Thu Đa Kênh (Omnichannel BI Dashboard)
- Thống kê doanh thu và tỷ trọng đơn hàng phân rã theo 4 kênh: Tại quầy POS vs Website Online vs Shopee vs TikTok Shop.
- KPI Cards: Doanh thu toàn hệ thống, Tổng đơn hàng, Sản phẩm đang bán, Khách hàng CRM.
- Top 5 sản phẩm thời trang bán chạy nhất.

---

## 3. Danh Sách Tài Khoản Thử Nghiệm

| Vai trò (Role) | Tên đăng nhập | Mật khẩu | Chức năng chính |
| :--- | :--- | :--- | :--- |
| **Quản Trị Viên (Admin)** | `admin` | `123456` | Toàn quyền quản trị, xem Dashboard BI đa kênh, quản lý sản phẩm, kho hàng, danh mục, đơn hàng và phân quyền người dùng. |
| **Thu Ngân Tại Quầy (Staff)** | `staff` | `123456` | Sử dụng màn hình POS bán hàng tại quầy, xuất hóa đơn, xử lý đơn hàng và nhập thêm kho. |
| **Khách Hàng (Customer)** | `user` | `123456` | Mua sắm online trên website, chọn size/màu, áp voucher, thanh toán VietQR và theo dõi đơn hàng cá nhân. |

---

## 4. Hướng Dẫn Cài Đặt & Triển Khai

### Bước 1: Khởi tạo Cơ sở dữ liệu MySQL
1. Mở MySQL Workbench hoặc MySQL CLI:
   ```powershell
   mysql -u root -p < database.sql
   ```
2. Mật khẩu kết nối MySQL mặc định đã được cấu hình trong `src/main/java/utils/DBConnection.java` (hỗ trợ các mật khẩu phổ biến: `dungnv060505`, `123456`, `root`, rỗng).

### Bước 2: Biên dịch và Triển khai tự động
Chỉ cần nhấp đúp file **`build_and_deploy.bat`** tại thư mục gốc dự án:
```powershell
.\build_and_deploy.bat
```
Script sẽ tự động:
1. Chạy `mvn clean package -DskipTests` để biên dịch toàn bộ source code thành `target/FashionStore.war`.
2. Copy `FashionStore.war` vào thư mục `webapps` của Apache Tomcat.

### Bước 3: Truy cập ứng dụng trên trình duyệt
- 🌐 **Trang chủ Web Bán lẻ:** [http://localhost:8080/FashionStore/](http://localhost:8080/FashionStore/)
- 🏪 **Màn hình Thu ngân Bán Tại Quầy (POS):** [http://localhost:8080/FashionStore/pos](http://localhost:8080/FashionStore/pos)
- 📊 **Báo cáo Quản trị Đa kênh (Admin Dashboard):** [http://localhost:8080/FashionStore/admin?page=dashboard](http://localhost:8080/FashionStore/admin?page=dashboard)
- 📦 **Quản lý Đơn hàng Đa kênh:** [http://localhost:8080/FashionStore/admin?page=orders](http://localhost:8080/FashionStore/admin?page=orders)
- 👗 **Quản lý Sản phẩm & Biến thể:** [http://localhost:8080/FashionStore/admin?page=products](http://localhost:8080/FashionStore/admin?page=products)
- 🏭 **Quản lý Kho tập trung:** [http://localhost:8080/FashionStore/admin?page=inventory](http://localhost:8080/FashionStore/admin?page=inventory)

---

## 5. Cấu Trúc Mã Nguồn (Directory Structure)

```
d:\BTL_JAVA\
├── pom.xml                                      # Maven config (Java 17, Jakarta EE 10, MySQL Connector 9.4)
├── database.sql                                 # Schema CSDL đa kênh & dữ liệu mẫu thời trang
├── build_and_deploy.bat                         # Script tự động build Maven & deploy Tomcat
├── README.md                                    # Tài liệu hướng dẫn sử dụng toàn diện
├── src/main/java/
│   ├── utils/
│   │   ├── DBConnection.java                    # Quản lý kết nối JDBC MySQL UTF-8
│   │   └── FormatUtils.java                     # Định dạng tiền tệ VNĐ và thời gian
│   ├── model/
│   │   ├── User.java                            # Model người dùng & phân quyền
│   │   ├── Category.java                        # Model danh mục thời trang
│   │   ├── Product.java                         # Model sản phẩm thời trang
│   │   ├── ProductVariant.java                  # Model biến thể (Size, Màu sắc, SKU, Tồn kho)
│   │   ├── CartItem.java                        # Model mục giỏ hàng chọn size/màu
│   │   ├── Order.java                           # Model đơn hàng đa kênh (POS, Web, Shopee, TikTok)
│   │   ├── OrderDetail.java                     # Model chi tiết đơn hàng
│   │   ├── Voucher.java                         # Model mã giảm giá khuyến mãi
│   │   └── OmniStats.java                       # Model số liệu phân tích đa kênh Dashboard
│   ├── dao/
│   │   ├── UserDAO.java                         # Đăng nhập, đăng ký, đổi quyền, quản lý user
│   │   ├── CategoryDAO.java                     # CRUD danh mục thời trang
│   │   ├── ProductDAO.java                      # Tìm kiếm, lọc đa tiêu chí, CRUD sản phẩm & biến thể, kho
│   │   ├── OrderDAO.java                        # Tạo đơn Web, tạo đơn POS, đồng bộ sàn, hoàn kho, thống kê BI
│   │   └── VoucherDAO.java                      # Kiểm tra và áp dụng mã khuyến mãi
│   ├── filter/
│   │   ├── EncodingFilter.java                  # Ép mã hóa UTF-8 toàn diện
│   │   ├── AuthFilter.java                      # Bảo vệ route đặt hàng & đơn cá nhân
│   │   └── AdminFilter.java                     # Bảo vệ route quản trị /admin/* và /pos
│   └── controller/
│       ├── HomeController.java                  # Trang chủ thời trang (/home, /)
│       ├── ProductServlet.java                  # Bộ sưu tập & bộ lọc sản phẩm (/products)
│       ├── ProductDetailServlet.java            # Chi tiết sản phẩm & chọn size/màu (/product-detail)
│       ├── CartServlet.java                     # Giỏ hàng & áp dụng voucher (/cart)
│       ├── CheckoutServlet.java                 # Thanh toán trực tuyến & VietQR động (/checkout)
│       ├── OrderServlet.java                    # Đơn hàng cá nhân & hủy đơn hoàn kho (/order, /orders)
│       ├── POSServlet.java                      # Thu ngân bán tại quầy & in hóa đơn (/pos)
│       ├── AdminServlet.java                    # Điều phối Dashboard, Orders, Products, Inventory, Users
│       ├── LoginServlet.java                    # Đăng nhập phân quyền thông minh (/login)
│       ├── RegisterServlet.java                 # Đăng ký tài khoản khách (/register)
│       └── LogoutServlet.java                   # Đăng xuất (/logout)
└── src/main/webapp/
    ├── css/style.css                            # CSS cao cấp, responsive, POS split view, @media print
    ├── common/
    │   ├── navbar.jsp                           # Header & thanh điều hướng khách hàng
    │   ├── footer.jsp                           # Chân trang giới thiệu showroom và kỹ thuật
    │   └── admin-sidebar.jsp                    # Menu sidebar quản trị hiện đại
    ├── customer/
    │   ├── products.jsp                         # Trang danh mục & bộ lọc
    │   ├── product-detail.jsp                   # Trang chi tiết sản phẩm & chọn size/màu
    │   ├── cart.jsp                             # Trang giỏ hàng & khuyến mãi
    │   ├── checkout.jsp                         # Trang thanh toán & mã VietQR
    │   └── orders.jsp                           # Trang lịch sử đơn hàng của tôi
    ├── admin/
    │   ├── pos.jsp                              # Màn hình bán hàng tại quầy POS & in bill
    │   ├── dashboard.jsp                        # Báo cáo BI phân bổ doanh thu đa kênh
    │   ├── orders.jsp                           # Quản lý đơn hàng đa kênh & giả lập đơn sàn
    │   ├── order-detail.jsp                     # Chi tiết đơn hàng đa kênh
    │   ├── products.jsp                         # Quản lý sản phẩm & biến thể
    │   ├── inventory.jsp                        # Quản lý kho tập trung & cảnh báo hết hàng
    │   ├── categories.jsp                       # Quản lý danh mục thời trang
    │   └── users.jsp                            # Quản lý người dùng & phân quyền
    ├── index.jsp                                # Trang chủ thời trang sang trọng
    ├── login.jsp                                # Trang đăng nhập & quick-fill
    ├── register.jsp                             # Trang đăng ký thành viên
    └── WEB-INF/web.xml                          # Khai báo cấu hình ứng dụng Jakarta EE 10
```
