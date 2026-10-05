<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bộ Sưu Tập Thời Trang - FashionStore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <jsp:include page="/common/navbar.jsp" />

    <main class="section">
        <div style="display: grid; grid-template-columns: 260px 1fr; gap: 2.5rem; align-items: start;">

            <!-- Left Filter Sidebar -->
            <aside style="background: white; border: 1px solid var(--border); border-radius: var(--radius); padding: 1.5rem; box-shadow: var(--shadow-sm);">
                <h3 style="font-size: 1.1rem; font-weight: 800; color: var(--primary-dark); margin-bottom: 1.25rem; border-bottom: 1px solid var(--border); padding-bottom: 0.75rem;">
                    Bộ Lọc Sản Phẩm
                </h3>

                <form action="${pageContext.request.contextPath}/products" method="get">
                    <c:if test="${not empty keyword}">
                        <input type="hidden" name="keyword" value="${keyword}">
                    </c:if>

                    <!-- Danh mục -->
                    <div style="margin-bottom: 1.5rem;">
                        <label style="font-weight: 700; font-size: 0.875rem; color: var(--primary); display: block; margin-bottom: 0.75rem;">
                            Danh mục thời trang
                        </label>
                        <div style="display: flex; flex-direction: column; gap: 0.5rem; font-size: 0.875rem;">
                            <label style="display: flex; align-items: center; gap: 0.5rem; cursor: pointer;">
                                <input type="radio" name="category" value="" ${empty selectedCategory ? 'checked' : ''} onchange="this.form.submit()">
                                <span>Tất cả danh mục</span>
                            </label>
                            <c:forEach var="c" items="${categories}">
                                <label style="display: flex; align-items: center; gap: 0.5rem; cursor: pointer;">
                                    <input type="radio" name="category" value="${c.id}" ${selectedCategory == c.id ? 'checked' : ''} onchange="this.form.submit()">
                                    <span>${c.name} (${c.productCount})</span>
                                </label>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- Khoảng giá -->
                    <div style="margin-bottom: 1.5rem;">
                        <label style="font-weight: 700; font-size: 0.875rem; color: var(--primary); display: block; margin-bottom: 0.75rem;">
                            Khoảng giá (VNĐ)
                        </label>
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 0.5rem; margin-bottom: 0.75rem;">
                            <input type="number" name="minPrice" placeholder="Từ" value="${minPrice}" style="width: 100%; padding: 0.4rem 0.6rem; border: 1px solid var(--border); border-radius: 6px; font-size: 0.8rem;">
                            <input type="number" name="maxPrice" placeholder="Đến" value="${maxPrice}" style="width: 100%; padding: 0.4rem 0.6rem; border: 1px solid var(--border); border-radius: 6px; font-size: 0.8rem;">
                        </div>
                        <button type="submit" class="btn btn-dark btn-sm btn-block">Áp dụng giá</button>
                    </div>

                    <!-- Nút reset -->
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-dark btn-sm btn-block" style="text-align: center;">
                        Xóa tất cả bộ lọc
                    </a>
                </form>
            </aside>

            <!-- Main Content Area -->
            <div>
                <!-- Top Toolbar -->
                <div style="background: white; border: 1px solid var(--border); border-radius: var(--radius); padding: 1rem 1.5rem; margin-bottom: 1.75rem; display: flex; justify-content: space-between; align-items: center; box-shadow: var(--shadow-sm);">
                    <div>
                        <span style="font-weight: 700; color: var(--primary-dark);">
                            ${products.size()}
                        </span>
                        <span style="color: var(--text-muted); font-size: 0.9rem;">sản phẩm phù hợp</span>
                        <c:if test="${not empty keyword}">
                            <span style="background: var(--accent-light); color: var(--accent-hover); padding: 2px 8px; border-radius: 4px; font-size: 0.8rem; font-weight: 600; margin-left: 0.5rem;">
                                Từ khóa: "${keyword}"
                            </span>
                        </c:if>
                    </div>

                    <!-- Sort -->
                    <form action="${pageContext.request.contextPath}/products" method="get" style="display: flex; align-items: center; gap: 0.5rem;">
                        <c:if test="${not empty keyword}"><input type="hidden" name="keyword" value="${keyword}"></c:if>
                        <c:if test="${not empty selectedCategory}"><input type="hidden" name="category" value="${selectedCategory}"></c:if>
                        <c:if test="${not empty minPrice}"><input type="hidden" name="minPrice" value="${minPrice}"></c:if>
                        <c:if test="${not empty maxPrice}"><input type="hidden" name="maxPrice" value="${maxPrice}"></c:if>

                        <span style="font-size: 0.85rem; color: var(--text-muted); font-weight: 600;">Sắp xếp:</span>
                        <select name="sort" onchange="this.form.submit()" style="padding: 0.4rem 0.8rem; border: 1px solid var(--border); border-radius: 6px; font-size: 0.85rem; font-family: inherit; outline: none;">
                            <option value="" ${empty sort ? 'selected' : ''}>Mới nhất</option>
                            <option value="price_asc" ${sort == 'price_asc' ? 'selected' : ''}>Giá tăng dần</option>
                            <option value="price_desc" ${sort == 'price_desc' ? 'selected' : ''}>Giá giảm dần</option>
                        </select>
                    </form>
                </div>

                <!-- Product Grid -->
                <c:choose>
                    <c:when test="${empty products}">
                        <div style="background: white; border: 1px solid var(--border); border-radius: var(--radius); padding: 4rem 2rem; text-align: center;">
                            <div style="font-size: 3rem; margin-bottom: 1rem;">🔍</div>
                            <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--primary-dark); margin-bottom: 0.5rem;">
                                Không tìm thấy sản phẩm nào
                            </h3>
                            <p style="color: var(--text-muted); font-size: 0.9rem; margin-bottom: 1.5rem;">
                                Hãy thử thay đổi từ khóa tìm kiếm hoặc bỏ bớt các tiêu chí lọc giá/danh mục.
                            </p>
                            <a href="${pageContext.request.contextPath}/products" class="btn btn-primary btn-sm">Xem toàn bộ sản phẩm</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="product-grid">
                            <c:forEach var="p" items="${products}">
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
                                            Xem chi tiết &amp; Chọn Size
                                        </a>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>

    <jsp:include page="/common/footer.jsp" />

</body>
</html>