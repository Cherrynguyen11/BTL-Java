<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>


<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FashionStore - Hệ Thống Bán Lẻ Thời Trang Đa Kênh Cao Cấp</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <!-- Header & Navigation -->
    <jsp:include page="/common/navbar.jsp" />

    <!-- Hero Banner -->
    <section class="hero">
        <div class="hero-container">
            <div>
                <span class="hero-tag">BỘ SƯU TẬP MÙA HÈ 2026</span>
                <h1>Thời Trang Đa Kênh<br><span style="color: #fcd34d;">Phong Cách Hiện Đại</span></h1>
                <p>
                    Trải nghiệm mua sắm đồng bộ thông minh: Thử đồ trực tiếp tại hệ thống Showroom POS hoặc đặt online nhận hàng hỏa tốc trong 2 giờ.
                </p>
                <div class="hero-btns">
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-primary">
                        Khám phá sản phẩm ➔
                    </a>
                    <a href="#omnichannel-section" class="btn btn-outline">
                        Tìm hiểu giải pháp đa kênh
                    </a>
                </div>
            </div>

            <!-- Hero Stats Box -->
            <div class="hero-stats">
                <div class="hero-stat-box">
                    <h3>100%</h3>
                    <p>Cotton tự nhiên cao cấp</p>
                </div>
                <div class="hero-stat-box">
                    <h3>4 Kênh</h3>
                    <p>POS, Web, Shopee, TikTok</p>
                </div>
                <div class="hero-stat-box">
                    <h3>2 Giờ</h3>
                    <p>Giao hàng hỏa tốc nội thành</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Omnichannel Pillars -->
    <section id="omnichannel-section" class="section" style="margin-top: 2rem;">
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap: 1.5rem;">
            <div style="background: white; border: 1px solid var(--border); border-radius: var(--radius); padding: 1.5rem; display: flex; gap: 1rem; align-items: flex-start; box-shadow: var(--shadow-sm);">
                <div style="font-size: 2rem; background: #ecfdf5; padding: 0.75rem; border-radius: 12px; color: var(--pos-color);">🏪</div>
                <div>
                    <h4 style="font-weight: 700; color: var(--primary-dark); margin-bottom: 0.25rem;">Tại Quầy Store POS</h4>
                    <p style="font-size: 0.85rem; color: var(--text-muted);">Trải nghiệm thử đồ thực tế, thanh toán nhanh và in hóa đơn tức thì.</p>
                </div>
            </div>

            <div style="background: white; border: 1px solid var(--border); border-radius: var(--radius); padding: 1.5rem; display: flex; gap: 1rem; align-items: flex-start; box-shadow: var(--shadow-sm);">
                <div style="font-size: 2rem; background: #eff6ff; padding: 0.75rem; border-radius: 12px; color: var(--web-color);">🌐</div>
                <div>
                    <h4 style="font-weight: 700; color: var(--primary-dark); margin-bottom: 0.25rem;">Website E-Commerce</h4>
                    <p style="font-size: 0.85rem; color: var(--text-muted);">Duyệt trọn bộ mẫu mã, lọc theo size/màu, thanh toán VietQR tiện lợi.</p>
                </div>
            </div>

            <div style="background: white; border: 1px solid var(--border); border-radius: var(--radius); padding: 1.5rem; display: flex; gap: 1rem; align-items: flex-start; box-shadow: var(--shadow-sm);">
                <div style="font-size: 2rem; background: #fff7ed; padding: 0.75rem; border-radius: 12px; color: var(--shopee-color);">🛍️</div>
                <div>
                    <h4 style="font-weight: 700; color: var(--primary-dark); margin-bottom: 0.25rem;">Sàn TMĐT Đồng Bộ</h4>
                    <p style="font-size: 0.85rem; color: var(--text-muted);">Tồn kho tự động khấu trừ real-time từ Shopee Mall và TikTok Shop.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Categories Section -->
    <section class="section">
        <div class="section-header">
            <div>
                <h2>Danh Mục Thời Trang</h2>
                <p>Khám phá các dòng sản phẩm chọn lọc cho phong cách của bạn</p>
            </div>
            <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-dark btn-sm">Xem tất cả ➔</a>
        </div>

        <div class="category-cards">
            <c:forEach var="c" items="${categories}">
                <a href="${pageContext.request.contextPath}/products?category=${c.id}" class="cat-card">
                    <span class="cat-icon">${c.icon}</span>
                    <span class="cat-title">${c.name}</span>
                    <span class="cat-count">${c.productCount} sản phẩm</span>
                </a>
            </c:forEach>
        </div>
    </section>

    <!-- New Arrivals Section -->
    <section class="section">
        <div class="section-header">
            <div>
                <h2>Sản Phẩm Mới Nhất</h2>
                <p>Những thiết kế vừa ra mắt trong bộ sưu tập mới nhất</p>
            </div>
            <a href="${pageContext.request.contextPath}/products?sort=price_desc" class="btn btn-outline-dark btn-sm">Xem bộ sưu tập</a>
        </div>

        <div class="product-grid">
            <c:forEach var="p" items="${featuredProducts}">
                <div class="product-card">
                    <div class="product-img-wrap">
                        <img src="${p.image}" alt="${p.name}" loading="lazy">
                        <c:if test="${p.discountPercent > 0}">
                            <span class="badge-discount">-${p.discountPercent}%</span>
                        </c:if>
                        <span class="badge-stock">
                            ${p.stock > 0 ? 'Còn hàng' : 'Tạm hết'}
                        </span>
                    </div>

                    <div class="product-info">
                        <span class="product-category">${p.categoryName}</span>
                        <h3 class="product-name">
                            <a href="${pageContext.request.contextPath}/product-detail?id=${p.id}">${p.name}</a>
                        </h3>

                        <div class="product-price-row">
                            <span class="current-price">
                                <fmt:formatNumber value="${p.price}" pattern="#,###"/> ₫
                            </span>
                            <c:if test="${p.originalPrice > p.price}">
                                <span class="orig-price">
                                    <fmt:formatNumber value="${p.originalPrice}" pattern="#,###"/> ₫
                                </span>
                            </c:if>
                        </div>

                        <a href="${pageContext.request.contextPath}/product-detail?id=${p.id}" class="btn btn-dark btn-sm btn-block">
                            Chọn Size &amp; Mua Ngay
                        </a>
                    </div>
                </div>
            </c:forEach>
        </div>
    </section>

    <!-- Footer -->
    <jsp:include page="/common/footer.jsp" />

</body>
</html>