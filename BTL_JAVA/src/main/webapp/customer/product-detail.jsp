<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${product.name} - FashionStore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <jsp:include page="/common/navbar.jsp" />

    <main class="section">
        <!-- Breadcrumb -->
        <div style="font-size: 0.85rem; color: var(--text-muted); margin-bottom: 1.5rem;">
            <a href="${pageContext.request.contextPath}/home">Trang chủ</a> ➔
            <a href="${pageContext.request.contextPath}/products?category=${product.categoryId}">${product.categoryName}</a> ➔
            <span style="color: var(--primary-dark); font-weight: 600;">${product.name}</span>
        </div>

        <!-- Detail Layout -->
        <div class="detail-layout">
            <!-- Product Image -->
            <div>
                <img src="${product.image}" alt="${product.name}" class="detail-img">
            </div>

            <!-- Product Purchase Form -->
            <div class="detail-content">
                <span class="badge badge-web" style="margin-bottom: 0.5rem;">Bộ sưu tập chính hãng</span>
                <h1>${product.name}</h1>
                <div style="font-size: 0.875rem; color: var(--text-muted); margin-bottom: 1rem;">
                    Mã sản phẩm: <b>FS-${product.id}</b> | Tình trạng:
                    <c:choose>
                        <c:when test="${product.stock > 0}">
                            <span style="color: var(--success); font-weight: 700;">Còn hàng (${product.stock} sản phẩm trong kho)</span>
                        </c:when>
                        <c:otherwise>
                            <span style="color: var(--danger); font-weight: 700;">Tạm hết hàng</span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Price Box -->
                <div class="detail-price-box">
                    <span class="detail-current-price">
                        <fmt:formatNumber value="${product.price}" pattern="#,###"/> ₫
                    </span>
                    <c:if test="${product.originalPrice > product.price}">
                        <span class="detail-orig-price">
                            <fmt:formatNumber value="${product.originalPrice}" pattern="#,###"/> ₫
                        </span>
                        <span class="badge-discount" style="position: static;">
                            Tiết kiệm ${product.discountPercent}%
                        </span>
                    </c:if>
                </div>

                <!-- Add to Cart Form -->
                <form action="${pageContext.request.contextPath}/cart" method="post">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="productId" value="${product.id}">

                    <!-- Size Selector -->
                    <div class="variant-group">
                        <label class="variant-label">Chọn Kích Thước (Size):</label>
                        <div class="variant-options">
                            <c:forEach var="v" items="${product.variants}" varStatus="status">
                                <label style="cursor: pointer;">
                                    <input type="radio" name="size" value="${v.size}" ${status.first ? 'checked' : ''} style="display: none;">
                                    <div class="variant-pill ${status.first ? 'active' : ''}" onclick="selectVariantPill(this)">
                                        ${v.size}
                                    </div>
                                </label>
                            </c:forEach>
                            <c:if test="${empty product.variants}">
                                <label><input type="radio" name="size" value="Freesize" checked style="display: none;"><div class="variant-pill active">Freesize</div></label>
                            </c:if>
                        </div>
                    </div>

                    <!-- Color Selector -->
                    <div class="variant-group">
                        <label class="variant-label">Màu Sắc:</label>
                        <div class="variant-options">
                            <c:forEach var="v" items="${product.variants}" varStatus="status">
                                <label style="cursor: pointer;">
                                    <input type="radio" name="color" value="${v.color}" ${status.first ? 'checked' : ''} style="display: none;">
                                    <div class="variant-pill ${status.first ? 'active' : ''}" onclick="selectVariantPill(this)">
                                        🎨 ${v.color}
                                    </div>
                                </label>
                            </c:forEach>
                            <c:if test="${empty product.variants}">
                                <label><input type="radio" name="color" value="Tiêu chuẩn" checked style="display: none;"><div class="variant-pill active">Tiêu chuẩn</div></label>
                            </c:if>
                        </div>
                    </div>

                    <!-- Quantity -->
                    <div class="variant-group">
                        <label class="variant-label">Số Lượng:</label>
                        <div class="quantity-control">
                            <button type="button" onclick="adjustQty(-1)">-</button>
                            <input type="number" id="detailQty" name="quantity" value="1" min="1" max="50">
                            <button type="button" onclick="adjustQty(1)">+</button>
                        </div>
                    </div>

                    <!-- CTA Buttons -->
                    <div style="display: flex; gap: 1rem; margin-top: 2rem;">
                        <button type="submit" class="btn btn-primary" style="flex: 1; padding: 0.85rem;">
                            🛒 Thêm Vào Giỏ Hàng
                        </button>
                        <button type="submit" name="redirect" value="checkout" class="btn btn-dark" style="flex: 1; padding: 0.85rem;">
                            ⚡ Mua Ngay
                        </button>
                    </div>
                </form>

                <!-- Product Description & Guarantees -->
                <div style="margin-top: 2.5rem; border-top: 1px solid var(--border); padding-top: 1.5rem;">
                    <h4 style="font-weight: 700; margin-bottom: 0.5rem; color: var(--primary-dark);">Mô Tả Sản Phẩm</h4>
                    <p style="color: var(--text-muted); font-size: 0.95rem; line-height: 1.7;">
                        ${product.description}
                    </p>
                </div>
            </div>
        </div>

        <!-- Related Products -->
        <c:if test="${not empty relatedProducts}">
            <div style="margin-top: 4rem;">
                <div class="section-header">
                    <h2>Sản Phẩm Cùng Danh Mục</h2>
                    <a href="${pageContext.request.contextPath}/products?category=${product.categoryId}" class="btn btn-outline-dark btn-sm">Xem tất cả</a>
                </div>
                <div class="product-grid">
                    <c:forEach var="rp" items="${relatedProducts}">
                        <c:if test="${rp.id != product.id}">
                            <div class="product-card">
                                <div class="product-img-wrap">
                                    <img src="${rp.image}" alt="${rp.name}">
                                </div>
                                <div class="product-info">
                                    <span class="product-category">${rp.categoryName}</span>
                                    <h3 class="product-name">
                                        <a href="${pageContext.request.contextPath}/product-detail?id=${rp.id}">${rp.name}</a>
                                    </h3>
                                    <div class="product-price-row">
                                        <span class="current-price">
                                            <fmt:formatNumber value="${rp.price}" pattern="#,###"/> ₫
                                        </span>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/product-detail?id=${rp.id}" class="btn btn-dark btn-sm btn-block">Xem chi tiết</a>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>
                </div>
            </div>
        </c:if>
    </main>

    <script>
        function selectVariantPill(el) {
            const container = el.closest('.variant-options');
            container.querySelectorAll('.variant-pill').forEach(p => p.classList.remove('active'));
            el.classList.add('active');
            const radio = el.closest('label').querySelector('input[type="radio"]');
            if (radio) radio.checked = true;
        }

        function adjustQty(delta) {
            const input = document.getElementById('detailQty');
            let val = parseInt(input.value) || 1;
            val = Math.max(1, Math.min(50, val + delta));
            input.value = val;
        }
    </script>

    <jsp:include page="/common/footer.jsp" />

</body>
</html>