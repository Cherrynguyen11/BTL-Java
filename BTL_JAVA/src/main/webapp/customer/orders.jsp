<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch Sử Đơn Hàng Của Tôi - FashionStore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <jsp:include page="/common/navbar.jsp" />

    <main class="section">
        <!-- Success Alert on New Order -->
        <c:if test="${param.success == 1}">
            <div style="background: #ecfdf5; border: 1.5px solid #a7f3d0; color: #065f46; padding: 1.5rem; border-radius: var(--radius); margin-bottom: 2rem; display: flex; align-items: center; gap: 1rem; box-shadow: var(--shadow-sm);">
                <div style="font-size: 2.5rem;">🎉</div>
                <div>
                    <h3 style="font-size: 1.15rem; font-weight: 800; margin-bottom: 0.25rem;">Đặt hàng thành công!</h3>
                    <p style="font-size: 0.9rem;">
                        Mã đơn hàng của bạn là <b style="color: var(--accent); font-family: monospace; font-size: 1rem;">${param.code}</b>. Hệ thống đang tiến hành đóng gói và xuất kho giao đến bạn sớm nhất!
                    </p>
                </div>
            </div>
        </c:if>

        <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 2rem;">
            <div>
                <h1 style="font-size: 1.85rem; font-weight: 800; color: var(--primary-dark);">Lịch Sử Đơn Hàng Của Tôi</h1>
                <p style="color: var(--text-muted); font-size: 0.95rem;">Theo dõi trạng thái xử lý, vận chuyển và chi tiết các mặt hàng thời trang đã đặt mua.</p>
            </div>
            <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-dark btn-sm">Mua thêm sản phẩm</a>
        </div>

        <c:choose>
            <c:when test="${empty orders}">
                <div style="background: white; border: 1px solid var(--border); border-radius: var(--radius); padding: 5rem 2rem; text-align: center; box-shadow: var(--shadow-sm);">
                    <div style="font-size: 4rem; margin-bottom: 1rem;">📦</div>
                    <h3 style="font-size: 1.3rem; font-weight: 700; color: var(--primary-dark); margin-bottom: 0.5rem;">Bạn chưa có đơn hàng nào</h3>
                    <p style="color: var(--text-muted); margin-bottom: 1.5rem;">Duyệt ngay bộ sưu tập áo sơ mi, polo, jeans và váy mùa hè của chúng tôi nhé.</p>
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-primary">Mua sắm ngay</a>
                </div>
            </c:when>
            <c:otherwise>
                <div style="display: flex; flex-direction: column; gap: 1.75rem;">
                    <c:forEach var="o" items="${orders}">
                        <div style="background: white; border: 1px solid var(--border); border-radius: var(--radius); box-shadow: var(--shadow-sm); overflow: hidden;">
                            <!-- Header of Order -->
                            <div style="background: #f8fafc; padding: 1.25rem 1.5rem; border-bottom: 1px solid var(--border); display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1rem;">
                                <div>
                                    <span style="font-size: 0.8rem; color: var(--text-muted);">Mã đơn hàng:</span>
                                    <span style="font-weight: 800; color: var(--primary-dark); font-family: monospace; font-size: 1rem; margin-right: 0.75rem;">
                                        ${o.orderCode}
                                    </span>
                                    <span class="badge ${o.channelBadgeClass}">${o.channelLabel}</span>
                                </div>
                                <div style="display: flex; align-items: center; gap: 1rem;">
                                    <span style="font-size: 0.825rem; color: var(--text-muted);">
                                        Ngày đặt: <fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                    </span>
                                    <span class="status-badge ${o.statusBadgeClass}">
                                        ${o.statusLabel}
                                    </span>
                                </div>
                            </div>

                            <!-- Order Items -->
                            <div style="padding: 1.5rem;">
                                <div style="display: flex; flex-direction: column; gap: 1rem; margin-bottom: 1.5rem;">
                                    <c:forEach var="item" items="${o.items}">
                                        <div style="display: flex; gap: 1rem; align-items: center;">
                                            <img src="${item.productImage}" alt="${item.productName}" style="width: 60px; height: 75px; object-fit: cover; border-radius: 6px;">
                                            <div style="flex: 1;">
                                                <h4 style="font-size: 0.95rem; font-weight: 700; color: var(--primary-dark); margin-bottom: 0.25rem;">
                                                    ${item.productName}
                                                </h4>
                                                <div style="font-size: 0.8rem; color: var(--text-muted);">
                                                    Phân loại: <span style="background: #f1f5f9; padding: 2px 6px; border-radius: 4px; font-weight: 600; color: var(--primary);">Size ${item.size} - Màu ${item.color}</span>
                                                    <span style="margin-left: 0.5rem;">Số lượng: <b>x${item.quantity}</b></span>
                                                </div>
                                            </div>
                                            <div style="font-weight: 700; color: var(--danger); font-size: 0.95rem;">
                                                <fmt:formatNumber value="${item.subtotal}" pattern="#,###"/> ₫
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>

                                <!-- Shipping & Total summary footer -->
                                <div style="background: #f8fafc; border-radius: 8px; padding: 1rem 1.25rem; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1rem;">
                                    <div style="font-size: 0.85rem; color: var(--text-muted); line-height: 1.6;">
                                        <div>📍 Giao đến: <b>${o.customerName}</b> (${o.phone}) - ${o.address}</div>
                                        <div>💳 Thanh toán: <b>${o.paymentMethod}</b> | Trạng thái tiền: <b style="color: ${o.paymentStatus == 'PAID' ? 'var(--success)' : 'var(--warning)'};">${o.paymentStatus == 'PAID' ? 'Đã thanh toán' : 'Chưa thanh toán'}</b></div>
                                    </div>

                                    <div style="display: flex; align-items: center; gap: 1.5rem;">
                                        <div>
                                            <div style="font-size: 0.8rem; color: var(--text-muted); text-align: right;">Tổng thanh toán:</div>
                                            <div style="font-size: 1.35rem; font-weight: 800; color: var(--danger);">
                                                <fmt:formatNumber value="${o.totalAmount}" pattern="#,###"/> ₫
                                            </div>
                                        </div>

                                        <!-- Cancel button if pending -->
                                        <c:if test="${o.status == 'PENDING'}">
                                            <form action="${pageContext.request.contextPath}/order" method="post" onsubmit="return confirm('Bạn có chắc chắn muốn hủy đơn hàng này? Tồn kho sản phẩm sẽ được tự động hoàn lại.')">
                                                <input type="hidden" name="action" value="cancel">
                                                <input type="hidden" name="orderId" value="${o.id}">
                                                <button type="submit" class="btn btn-outline-dark btn-sm" style="color: var(--danger); border-color: var(--danger);">
                                                    Hủy đơn hàng
                                                </button>
                                            </form>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </main>

    <jsp:include page="/common/footer.jsp" />

</body>
</html>