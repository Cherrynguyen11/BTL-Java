<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<aside class="admin-sidebar">
    <div class="admin-sidebar-brand">
        <span>✦</span> FASHIONSTORE
        <span class="brand-badge" style="background: var(--accent); color: white; font-size: 0.65rem; padding: 2px 6px; border-radius: 4px;">ADMIN</span>
    </div>

    <div style="padding: 1rem 1.25rem; border-bottom: 1px solid #1e293b; display: flex; align-items: center; gap: 0.75rem;">
        <div style="width: 36px; height: 36px; border-radius: 50%; background: var(--accent); color: white; display: flex; align-items: center; justify-content: center; font-weight: 700;">
            ${sessionScope.user.fullName.substring(0, 1)}
        </div>
        <div style="overflow: hidden;">
            <div style="font-weight: 700; font-size: 0.875rem; color: white; white-space: nowrap; text-overflow: ellipsis; overflow: hidden;">
                ${sessionScope.user.fullName}
            </div>
            <div style="font-size: 0.725rem; color: #94a3b8;">
                Vai trò: <b style="color: #fcd34d;">${sessionScope.user.role}</b>
            </div>
        </div>
    </div>

    <ul class="admin-menu">
        <li>
            <a href="${pageContext.request.contextPath}/admin?page=dashboard" class="${param.page == 'dashboard' || empty param.page ? 'active' : ''}">
                <span>📊</span> Tổng quan Dashboard
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/pos" style="color: #34d399; font-weight: 700;">
                <span>🏪</span> Thu ngân Bán Tại Quầy (POS)
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin?page=orders" class="${param.page == 'orders' || param.page == 'order-detail' ? 'active' : ''}">
                <span>📦</span> Đơn hàng Đa Kênh
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin?page=products" class="${param.page == 'products' ? 'active' : ''}">
                <span>👗</span> Quản lý Sản phẩm
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin?page=inventory" class="${param.page == 'inventory' ? 'active' : ''}">
                <span>🏭</span> Kho hàng Tập trung
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin?page=categories" class="${param.page == 'categories' ? 'active' : ''}">
                <span>🏷️</span> Danh mục Thời trang
            </a>
        </li>
        <c:if test="${sessionScope.user.role == 'ADMIN'}">
            <li>
                <a href="${pageContext.request.contextPath}/admin?page=users" class="${param.page == 'users' ? 'active' : ''}">
                    <span>👥</span> Quản lý Người dùng
                </a>
            </li>
        </c:if>
    </ul>

    <div style="padding: 1rem 0.75rem; border-top: 1px solid #1e293b;">
        <a href="${pageContext.request.contextPath}/home" style="display: flex; align-items: center; gap: 0.5rem; color: #94a3b8; font-size: 0.85rem; padding: 0.5rem; border-radius: 6px; margin-bottom: 0.5rem;">
            <span>🌐</span> Xem trang Web bán lẻ
        </a>
        <a href="${pageContext.request.contextPath}/logout" style="display: flex; align-items: center; gap: 0.5rem; color: #f87171; font-size: 0.85rem; padding: 0.5rem; border-radius: 6px;">
            <span>🚪</span> Đăng xuất
        </a>
    </div>
</aside>
