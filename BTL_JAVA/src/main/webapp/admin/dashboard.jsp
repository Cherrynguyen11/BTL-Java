<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Báo Cáo Bán Lẻ Đa Kênh (Omnichannel Dashboard) - FashionStore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <div class="admin-wrapper">
        <!-- Sidebar -->
        <jsp:include page="/common/admin-sidebar.jsp" />

        <!-- Main Dashboard Area -->
        <main class="admin-main">
            <!-- Header -->
            <div class="admin-header">
                <div>
                    <h1 style="font-size: 1.85rem; font-weight: 800; color: var(--primary-dark); letter-spacing: -0.5px;">
                        Báo Cáo Quản Trị Bán Lẻ Đa Kênh
                    </h1>
                    <p style="color: var(--text-muted); font-size: 0.95rem;">
                        Số liệu thời gian thực đồng bộ từ Showroom POS, Website Online, Shopee Mall và TikTok Shop.
                    </p>
                </div>
                <div style="display: flex; gap: 0.75rem;">
                    <a href="${pageContext.request.contextPath}/pos" class="btn btn-success">
                        🏪 Mở Màn Hình POS
                    </a>
                </div>
            </div>

            <!-- KPI Cards Grid -->
            <div class="kpi-grid">
                <div class="kpi-card">
                    <div class="kpi-icon-wrap kpi-icon-blue">💰</div>
                    <div>
                        <div class="kpi-label">DOANH THU TOÀN HỆ THỐNG</div>
                        <div class="kpi-value">
                            <fmt:formatNumber value="${stats.totalRevenue}" pattern="#,###"/> ₫
                        </div>
                    </div>
                </div>

                <div class="kpi-card">
                    <div class="kpi-icon-wrap kpi-icon-green">📦</div>
                    <div>
                        <div class="kpi-label">TỔNG ĐƠN HÀNG ĐA KÊNH</div>
                        <div class="kpi-value">${stats.totalOrders} đơn</div>
                    </div>
                </div>

                <div class="kpi-card">
                    <div class="kpi-icon-wrap kpi-icon-amber">👗</div>
                    <div>
                        <div class="kpi-label">SẢN PHẨM ĐANG BÁN</div>
                        <div class="kpi-value">${stats.totalProducts} mã</div>
                    </div>
                </div>

                <div class="kpi-card">
                    <div class="kpi-icon-wrap kpi-icon-purple">👥</div>
                    <div>
                        <div class="kpi-label">KHÁCH HÀNG CRM</div>
                        <div class="kpi-value">${stats.totalCustomers} tài khoản</div>
                    </div>
                </div>
            </div>

            <!-- Omnichannel Distribution Section -->
            <div style="display: grid; grid-template-columns: 1.2fr 1fr; gap: 1.75rem; margin-bottom: 2rem;">

                <!-- Channel Revenue Breakdown -->
                <div class="data-card" style="margin-bottom: 0;">
                    <div class="data-card-header">
                        <h3>📊 Phân Bổ Doanh Thu Theo Kênh Bán Hàng</h3>
                        <span style="font-size: 0.8rem; color: var(--text-muted); font-weight: 600;">Tổng hợp Real-time</span>
                    </div>
                    <div style="padding: 1.5rem;">
                        <!-- Store POS -->
                        <div class="channel-bar-group">
                            <div class="channel-bar-header">
                                <span style="display: flex; align-items: center; gap: 0.4rem;">
                                    <span class="badge badge-pos">Tại quầy POS</span>
                                    <span>${stats.getOrderCount('STORE_POS')} đơn</span>
                                </span>
                                <span style="color: var(--pos-color);">
                                    <fmt:formatNumber value="${stats.getRevenue('STORE_POS')}" pattern="#,###"/> ₫
                                </span>
                            </div>
                            <div class="progress-track">
                                <c:set var="posRatio" value="${stats.totalRevenue > 0 ? (stats.getRevenue('STORE_POS') / stats.totalRevenue * 100) : 0}" />
                                <div class="progress-fill progress-pos" style="width: ${posRatio > 0 ? posRatio : 5}%;"></div>
                            </div>
                        </div>

                        <!-- Website Online -->
                        <div class="channel-bar-group">
                            <div class="channel-bar-header">
                                <span style="display: flex; align-items: center; gap: 0.4rem;">
                                    <span class="badge badge-web">Website Online</span>
                                    <span>${stats.getOrderCount('WEBSITE')} đơn</span>
                                </span>
                                <span style="color: var(--web-color);">
                                    <fmt:formatNumber value="${stats.getRevenue('WEBSITE')}" pattern="#,###"/> ₫
                                </span>
                            </div>
                            <div class="progress-track">
                                <c:set var="webRatio" value="${stats.totalRevenue > 0 ? (stats.getRevenue('WEBSITE') / stats.totalRevenue * 100) : 0}" />
                                <div class="progress-fill progress-web" style="width: ${webRatio > 0 ? webRatio : 5}%;"></div>
                            </div>
                        </div>

                        <!-- Shopee Mall -->
                        <div class="channel-bar-group">
                            <div class="channel-bar-header">
                                <span style="display: flex; align-items: center; gap: 0.4rem;">
                                    <span class="badge badge-shopee">Shopee Mall</span>
                                    <span>${stats.getOrderCount('SHOPEE')} đơn</span>
                                </span>
                                <span style="color: var(--shopee-color);">
                                    <fmt:formatNumber value="${stats.getRevenue('SHOPEE')}" pattern="#,###"/> ₫
                                </span>
                            </div>
                            <div class="progress-track">
                                <c:set var="spRatio" value="${stats.totalRevenue > 0 ? (stats.getRevenue('SHOPEE') / stats.totalRevenue * 100) : 0}" />
                                <div class="progress-fill progress-shopee" style="width: ${spRatio > 0 ? spRatio : 5}%;"></div>
                            </div>
                        </div>

                        <!-- TikTok Shop -->
                        <div class="channel-bar-group">
                            <div class="channel-bar-header">
                                <span style="display: flex; align-items: center; gap: 0.4rem;">
                                    <span class="badge badge-tiktok">TikTok Shop</span>
                                    <span>${stats.getOrderCount('TIKTOK')} đơn</span>
                                </span>
                                <span style="color: var(--tiktok-color);">
                                    <fmt:formatNumber value="${stats.getRevenue('TIKTOK')}" pattern="#,###"/> ₫
                                </span>
                            </div>
                            <div class="progress-track">
                                <c:set var="ttRatio" value="${stats.totalRevenue > 0 ? (stats.getRevenue('TIKTOK') / stats.totalRevenue * 100) : 0}" />
                                <div class="progress-fill progress-tiktok" style="width: ${ttRatio > 0 ? ttRatio : 5}%;"></div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Top 5 Best Sellers -->
                <div class="data-card" style="margin-bottom: 0;">
                    <div class="data-card-header">
                        <h3>🔥 Top Sản Phẩm Bán Chạy Nhất</h3>
                        <a href="${pageContext.request.contextPath}/admin?page=products" class="btn btn-outline-dark btn-sm">Xem tất cả</a>
                    </div>
                    <div style="padding: 1rem 1.5rem;">
                        <c:forEach var="tp" items="${stats.topSellingProducts}">
                            <div style="display: flex; gap: 1rem; align-items: center; padding: 0.65rem 0; border-bottom: 1px dashed var(--border);">
                                <img src="${tp.image}" alt="${tp.name}" style="width: 45px; height: 55px; object-fit: cover; border-radius: 6px;">
                                <div style="flex: 1;">
                                    <div style="font-weight: 700; font-size: 0.85rem; color: var(--primary-dark);">${tp.name}</div>
                                    <div style="font-size: 0.75rem; color: var(--text-muted);">${tp.categoryName}</div>
                                </div>
                                <div style="text-align: right;">
                                    <div style="font-weight: 800; color: var(--accent); font-size: 0.9rem;">
                                        ${tp.stock} đã bán
                                    </div>
                                    <div style="font-size: 0.75rem; color: var(--text-muted);">
                                        <fmt:formatNumber value="${tp.price}" pattern="#,###"/> ₫
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <!-- Recent Orders Table -->
            <div class="data-card">
                <div class="data-card-header">
                    <h3>📦 Đơn Hàng Đa Kênh Mới Nhất</h3>
                    <a href="${pageContext.request.contextPath}/admin?page=orders" class="btn btn-dark btn-sm">
                        Quản lý toàn bộ đơn ➔
                    </a>
                </div>
                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Mã đơn hàng</th>
                                <th>Kênh bán</th>
                                <th>Khách hàng</th>
                                <th>Ngày tạo</th>
                                <th>Thanh toán</th>
                                <th>Tổng tiền</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="o" items="${recentOrders}" end="7">
                                <tr>
                                    <td style="font-family: monospace; font-weight: 700; color: var(--primary-dark);">
                                        ${o.orderCode}
                                    </td>
                                    <td>
                                        <span class="badge ${o.channelBadgeClass}">${o.channelLabel}</span>
                                    </td>
                                    <td>
                                        <div style="font-weight: 700;">${o.customerName}</div>
                                        <div style="font-size: 0.75rem; color: var(--text-muted);">${o.phone}</div>
                                    </td>
                                    <td style="font-size: 0.8rem; color: var(--text-muted);">
                                        <fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                    </td>
                                    <td>
                                        <span style="font-size: 0.8rem; font-weight: 600; color: ${o.paymentStatus == 'PAID' ? 'var(--success)' : 'var(--warning)'};">
                                            ${o.paymentMethod} (${o.paymentStatus == 'PAID' ? 'Đã thu' : 'Chưa thu'})
                                        </span>
                                    </td>
                                    <td style="font-weight: 800; color: var(--danger);">
                                        <fmt:formatNumber value="${o.totalAmount}" pattern="#,###"/> ₫
                                    </td>
                                    <td>
                                        <span class="status-badge ${o.statusBadgeClass}">
                                            ${o.statusLabel}
                                        </span>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/admin?page=order-detail&id=${o.id}" class="btn btn-outline-dark btn-sm">
                                            Chi tiết
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Low Stock Warnings -->
            <c:if test="${not empty stats.lowStockVariants}">
                <div class="data-card" style="border-left: 4px solid var(--danger);">
                    <div class="data-card-header" style="background: #fff1f2;">
                        <h3 style="color: #9f1239;">⚠️ Cảnh Báo Tồn Kho Sắp Hết (Cần Nhập Hàng)</h3>
                        <a href="${pageContext.request.contextPath}/admin?page=inventory" class="btn btn-danger btn-sm">Nhập thêm kho</a>
                    </div>
                    <div class="table-responsive">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Mã SKU / Sản phẩm</th>
                                    <th>Kích thước (Size)</th>
                                    <th>Màu sắc</th>
                                    <th>Số lượng tồn hiện tại</th>
                                    <th>Tình trạng</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="lv" items="${stats.lowStockVariants}">
                                    <tr>
                                        <td style="font-weight: 700;">${lv.sku}</td>
                                        <td><span class="variant-pill" style="padding: 2px 8px; font-size: 0.75rem;">${lv.size}</span></td>
                                        <td>${lv.color}</td>
                                        <td style="font-weight: 800; color: var(--danger); font-size: 1rem;">
                                            ${lv.quantity} cái
                                        </td>
                                        <td>
                                            <span class="badge" style="background: #fee2e2; color: #b91c1c;">Sắp hết hàng</span>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:if>

        </main>
    </div>

</body>
</html>