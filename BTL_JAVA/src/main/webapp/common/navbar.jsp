<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<header class="site-header">
    <div class="nav-container">
        <!-- Logo -->
        <a href="${pageContext.request.contextPath}/home" class="brand-logo">
            <span style="font-size: 1.5rem;">✦</span> FASHIONSTORE
            <span class="brand-badge">Omnichannel</span>
        </a>

        <!-- Search Bar -->
        <form action="${pageContext.request.contextPath}/products" method="get" class="nav-search">
            <span class="nav-search-icon">🔍</span>
            <input type="text" name="keyword" placeholder="Tìm kiếm áo sơ mi, jeans, blazer..." value="${param.keyword}">
        </form>

        <!-- Navigation Links -->
        <nav class="nav-links">
            <a href="${pageContext.request.contextPath}/home">Trang chủ</a>
            <a href="${pageContext.request.contextPath}/products">Bộ sưu tập</a>

            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <a href="${pageContext.request.contextPath}/order">📦 Đơn của tôi</a>
                    <c:if test="${sessionScope.user.role == 'ADMIN' || sessionScope.user.role == 'STAFF'}">
                        <a href="${pageContext.request.contextPath}/pos" style="color: #059669; font-weight: 700;">🏪 Thu ngân POS</a>
                        <a href="${pageContext.request.contextPath}/admin?page=dashboard" style="color: #2563eb; font-weight: 700;">⚙️ Quản trị</a>
                    </c:if>
                </c:when>
            </c:choose>
        </nav>

        <!-- Actions -->
        <div class="nav-actions">
            <!-- Cart Button -->
            <a href="${pageContext.request.contextPath}/cart" class="cart-btn">
                🛒 Giỏ hàng
                <c:if test="${not empty sessionScope.cartTotalItems && sessionScope.cartTotalItems > 0}">
                    <span class="cart-count">${sessionScope.cartTotalItems}</span>
                </c:if>
            </a>

            <!-- User Menu -->
            <c:choose>
                <c:when test="${empty sessionScope.user}">
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-dark btn-sm">Đăng nhập</a>
                    <a href="${pageContext.request.contextPath}/register" class="btn btn-primary btn-sm">Đăng ký</a>
                </c:when>
                <c:otherwise>
                    <div style="display: flex; align-items: center; gap: 0.65rem;">
                        <span style="font-size: 0.85rem; font-weight: 600; color: var(--primary);">
                            👋 ${sessionScope.user.fullName}
                        </span>
                        <a href="${pageContext.request.contextPath}/logout" class="btn btn-sm btn-outline-dark" title="Đăng xuất">Đăng xuất</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</header>
