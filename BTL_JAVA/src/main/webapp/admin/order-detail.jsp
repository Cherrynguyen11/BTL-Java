<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết Đơn Hàng ${order.orderCode} - FashionStore Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <div class="admin-wrapper">
        <jsp:include page="/common/admin-sidebar.jsp" />

        <main class="admin-main">
            <!-- Header -->
            <div class="admin-header">
                <div>
                    <a href="${pageContext.request.contextPath}/admin?page=orders" style="color: var(--text-muted); font-size: 0.85rem; font-weight: 600;">
                        ← Quay lại danh sách đơn hàng
                    </a>
                    <h1 style="font-size: 1.85rem; font-weight: 800; color: var(--primary-dark); margin-top: 0.25rem;">
                        Chi Tiết Đơn Hàng: <span style="font-family: monospace; color: var(--accent);">${order.orderCode}</span>
                    </h1>
                </div>
                <div style="display: flex; gap: 0.75rem;">
                    <button type="button" onclick="window.print()" class="btn btn-outline-dark btn-sm">
                        🖨️ In Phiếu Đơn Hàng
                    </button>
                </div>
            </div>

            <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 2rem; align-items: start;">

                <!-- Left: Order Items Table -->
                <div class="data-card">
                    <div class="data-card-header">
                        <h3>Danh Sách Mặt Hàng (${order.items.size()} mặt hàng)</h3>
                        <span class="badge ${order.channelBadgeClass}">${order.channelLabel}</span>
                    </div>

                    <div style="padding: 1.5rem;">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Sản phẩm</th>
                                    <th>Phân loại</th>
                                    <th>Đơn giá</th>
                                    <th>SL</th>
                                    <th>Thành tiền</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${order.items}">
                                    <tr>
                                        <td>
                                            <div style="display: flex; align-items: center; gap: 0.75rem;">
                                                <img src="${item.productImage}" alt="${item.productName}" style="width: 50px; height: 60px; object-fit: cover; border-radius: 4px;">
                                                <div style="font-weight: 700; color: var(--primary-dark);">${item.productName}</div>
                                            </div>
                                        </td>
                                        <td>
                                            <span style="background: #f1f5f9; padding: 2px 8px; border-radius: 4px; font-weight: 600; font-size: 0.8rem;">
                                                Size ${item.size} - ${item.color}
                                            </span>
                                        </td>
                                        <td><fmt:formatNumber value="${item.price}" pattern="#,###"/> ₫</td>
                                        <td style="font-weight: 700;">x${item.quantity}</td>
                                        <td style="font-weight: 800; color: var(--danger);">
                                            <fmt:formatNumber value="${item.subtotal}" pattern="#,###"/> ₫
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>

                        <!-- Summary footer -->
                        <div style="border-top: 1px solid var(--border); margin-top: 1.5rem; padding-top: 1rem; line-height: 2; font-size: 0.9rem; text-align: right;">
                            <div>Chiết khấu: <b>-<fmt:formatNumber value="${order.discountAmount}" pattern="#,###"/> ₫</b></div>
                            <div style="font-size: 1.25rem; font-weight: 800; color: var(--danger); margin-top: 0.5rem;">
                                Tổng thanh toán: <fmt:formatNumber value="${order.totalAmount}" pattern="#,###"/> ₫
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right: Customer & Fulfillment Status Card -->
                <div>
                    <!-- Status update form -->
                    <div class="data-card" style="padding: 1.5rem; margin-bottom: 1.5rem;">
                        <h3 style="font-size: 1.1rem; font-weight: 800; margin-bottom: 1rem;">Trạng Thái Đơn Hàng</h3>

                        <form action="${pageContext.request.contextPath}/admin" method="post">
                            <input type="hidden" name="action" value="orderStatus">
                            <input type="hidden" name="page" value="order-detail">
                            <input type="hidden" name="id" value="${order.id}">

                            <div style="margin-bottom: 1rem;">
                                <label style="font-weight: 700; font-size: 0.85rem; display: block; margin-bottom: 0.4rem;">Cập nhật trạng thái:</label>
                                <select name="status" style="width: 100%; padding: 0.55rem; border: 1px solid var(--border); border-radius: 6px; font-weight: 600;">
                                    <option value="PENDING" ${order.status == 'PENDING' ? 'selected' : ''}>Chờ xử lý</option>
                                    <option value="CONFIRMED" ${order.status == 'CONFIRMED' ? 'selected' : ''}>Đã xác nhận</option>
                                    <option value="PROCESSING" ${order.status == 'PROCESSING' ? 'selected' : ''}>Đang đóng gói xuất kho</option>
                                    <option value="SHIPPING" ${order.status == 'SHIPPING' ? 'selected' : ''}>Đang giao hàng</option>
                                    <option value="COMPLETED" ${order.status == 'COMPLETED' ? 'selected' : ''}>Đã hoàn thành</option>
                                    <option value="CANCELLED" ${order.status == 'CANCELLED' ? 'selected' : ''}>Hủy đơn (Tự động hoàn kho)</option>
                                </select>
                            </div>

                            <button type="submit" class="btn btn-primary btn-block btn-sm">Cập nhật ngay</button>
                        </form>
                    </div>

                    <!-- Customer Info -->
                    <div class="data-card" style="padding: 1.5rem;">
                        <h3 style="font-size: 1.1rem; font-weight: 800; margin-bottom: 1rem;">Thông Tin Giao Nhận</h3>
                        <div style="font-size: 0.875rem; line-height: 1.8; color: var(--text-main);">
                            <div>Khách hàng: <b>${order.customerName}</b></div>
                            <div>Số điện thoại: <b>${order.phone}</b></div>
                            <div>Địa chỉ giao: <b>${order.address}</b></div>
                            <div>Kênh đặt: <span class="badge ${order.channelBadgeClass}">${order.channelLabel}</span></div>
                            <div>Thanh toán: <b>${order.paymentMethod}</b> (${order.paymentStatus == 'PAID' ? 'Đã thanh toán' : 'Chưa thanh toán'})</div>
                            <div>Ngày đặt: <b><fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/></b></div>
                            <c:if test="${not empty order.staffName}">
                                <div>Nhân viên phụ trách: <b>${order.staffName}</b></div>
                            </c:if>
                            <c:if test="${not empty order.notes}">
                                <div style="background: #f8fafc; padding: 0.5rem; border-radius: 4px; margin-top: 0.5rem; font-style: italic;">
                                    "${order.notes}"
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>

            </div>
        </main>
    </div>

</body>
</html>
