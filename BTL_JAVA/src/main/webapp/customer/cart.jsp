<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ Hàng Thời Trang - FashionStore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <jsp:include page="/common/navbar.jsp" />

    <main class="section">
        <div style="margin-bottom: 2rem;">
            <h1 style="font-size: 1.85rem; font-weight: 800; color: var(--primary-dark);">Giỏ Hàng Của Bạn</h1>
            <p style="color: var(--text-muted); font-size: 0.95rem;">Kiểm tra danh sách sản phẩm thời trang và áp dụng mã khuyến mãi trước khi đặt hàng.</p>
        </div>

        <c:choose>
            <c:when test="${empty sessionScope.cart || sessionScope.cart.isEmpty()}">
                <div style="background: white; border: 1px solid var(--border); border-radius: var(--radius); padding: 5rem 2rem; text-align: center; box-shadow: var(--shadow-sm);">
                    <div style="font-size: 4rem; margin-bottom: 1rem;">🛍️</div>
                    <h3 style="font-size: 1.4rem; font-weight: 700; color: var(--primary-dark); margin-bottom: 0.5rem;">Giỏ hàng của bạn đang trống</h3>
                    <p style="color: var(--text-muted); margin-bottom: 2rem;">Hãy chọn những mẫu áo, quần hay váy ưng ý nhất trong bộ sưu tập mới nhé!</p>
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-primary">Khám phá bộ sưu tập ngay</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="cart-layout">
                    <!-- Left: Cart Items Table -->
                    <div class="cart-box">
                        <table class="cart-table">
                            <thead>
                                <tr>
                                    <th>Sản phẩm</th>
                                    <th>Đơn giá</th>
                                    <th>Số lượng</th>
                                    <th>Thành tiền</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="entry" items="${sessionScope.cart}">
                                    <c:set var="item" value="${entry.value}" />
                                    <tr>
                                        <td>
                                            <div class="cart-item-info">
                                                <img src="${item.product.image}" alt="${item.product.name}" class="cart-thumb">
                                                <div>
                                                    <a href="${pageContext.request.contextPath}/product-detail?id=${item.product.id}" style="font-weight: 700; color: var(--primary-dark); font-size: 0.95rem;">
                                                        ${item.product.name}
                                                    </a>
                                                    <div style="font-size: 0.8rem; color: var(--text-muted); margin-top: 0.25rem;">
                                                        Size: <b style="color: var(--primary);">${item.size}</b> | Màu: <b style="color: var(--primary);">${item.color}</b>
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                        <td style="font-weight: 600;">
                                            <fmt:formatNumber value="${item.product.price}" pattern="#,###"/> ₫
                                        </td>
                                        <td>
                                            <form action="${pageContext.request.contextPath}/cart" method="post" style="display: inline;">
                                                <input type="hidden" name="action" value="update">
                                                <input type="hidden" name="itemKey" value="${entry.key}">
                                                <div class="quantity-control">
                                                    <button type="submit" name="quantity" value="${item.quantity - 1}">-</button>
                                                    <input type="text" value="${item.quantity}" readonly>
                                                    <button type="submit" name="quantity" value="${item.quantity + 1}">+</button>
                                                </div>
                                            </form>
                                        </td>
                                        <td style="font-weight: 800; color: var(--danger);">
                                            <fmt:formatNumber value="${item.subtotal}" pattern="#,###"/> ₫
                                        </td>
                                        <td>
                                            <form action="${pageContext.request.contextPath}/cart" method="post" style="display: inline;">
                                                <input type="hidden" name="action" value="remove">
                                                <input type="hidden" name="itemKey" value="${entry.key}">
                                                <button type="submit" style="background: none; border: none; cursor: pointer; font-size: 1.1rem; color: var(--danger);" title="Xóa">
                                                    🗑️
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>

                        <div style="display: flex; justify-content: space-between; margin-top: 1.5rem; align-items: center;">
                            <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-dark btn-sm">
                                ➔ Tiếp tục mua sắm
                            </a>
                            <form action="${pageContext.request.contextPath}/cart" method="post">
                                <input type="hidden" name="action" value="clear">
                                <button type="submit" class="btn btn-outline-dark btn-sm" style="color: var(--danger); border-color: var(--danger);">
                                    Xóa sạch giỏ hàng
                                </button>
                            </form>
                        </div>
                    </div>

                    <!-- Right: Summary & Voucher Box -->
                    <div>
                        <!-- Voucher Card -->
                        <div style="background: white; border: 1px solid var(--border); border-radius: var(--radius); padding: 1.5rem; margin-bottom: 1.5rem; box-shadow: var(--shadow-sm);">
                            <h4 style="font-weight: 700; margin-bottom: 0.75rem; color: var(--primary-dark);">Mã Giảm Giá Khuyến Mãi</h4>
                            <p style="font-size: 0.8rem; color: var(--text-muted); margin-bottom: 0.75rem;">
                                Nhập mã: <code style="background: #f1f5f9; padding: 2px 6px; border-radius: 4px; font-weight: 700; color: var(--accent);">FASHION10</code> (giảm 10%) hoặc <code style="background: #f1f5f9; padding: 2px 6px; border-radius: 4px; font-weight: 700; color: var(--accent);">VIP20</code>
                            </p>

                            <c:if test="${not empty sessionScope.voucherSuccess}">
                                <div style="background: #ecfdf5; color: #065f46; padding: 0.5rem 0.75rem; border-radius: 6px; font-size: 0.825rem; font-weight: 600; margin-bottom: 0.75rem;">
                                    ✓ ${sessionScope.voucherSuccess}
                                </div>
                            </c:if>
                            <c:if test="${not empty sessionScope.voucherError}">
                                <div style="background: #fee2e2; color: #991b1b; padding: 0.5rem 0.75rem; border-radius: 6px; font-size: 0.825rem; font-weight: 600; margin-bottom: 0.75rem;">
                                    ⚠️ ${sessionScope.voucherError}
                                </div>
                            </c:if>

                            <form action="${pageContext.request.contextPath}/cart" method="post" style="display: flex; gap: 0.5rem;">
                                <input type="hidden" name="action" value="applyVoucher">
                                <input type="text" name="voucherCode" placeholder="Mã voucher..." value="${sessionScope.appliedVoucher.code}" style="flex: 1; padding: 0.55rem 0.85rem; border: 1px solid var(--border); border-radius: 6px; font-size: 0.875rem; text-transform: uppercase;">
                                <button type="submit" class="btn btn-dark btn-sm">Áp dụng</button>
                            </form>
                            <c:if test="${not empty sessionScope.appliedVoucher}">
                                <form action="${pageContext.request.contextPath}/cart" method="post" style="margin-top: 0.5rem;">
                                    <input type="hidden" name="action" value="removeVoucher">
                                    <button type="submit" style="background: none; border: none; color: var(--danger); font-size: 0.8rem; cursor: pointer; text-decoration: underline;">
                                        Hủy áp dụng mã
                                    </button>
                                </form>
                            </c:if>
                        </div>

                        <!-- Summary Card -->
                        <div style="background: white; border: 1px solid var(--border); border-radius: var(--radius); padding: 1.75rem; box-shadow: var(--shadow-sm);">
                            <h4 style="font-weight: 700; margin-bottom: 1.25rem; color: var(--primary-dark); font-size: 1.1rem;">Tóm Tắt Đơn Hàng</h4>

                            <div style="display: flex; justify-content: space-between; margin-bottom: 0.75rem; font-size: 0.9rem; color: var(--text-muted);">
                                <span>Tạm tính:</span>
                                <span style="font-weight: 700; color: var(--primary-dark);">
                                    <fmt:formatNumber value="${sessionScope.cartSubtotal}" pattern="#,###"/> ₫
                                </span>
                            </div>

                            <c:if test="${not empty sessionScope.discountAmount && sessionScope.discountAmount > 0}">
                                <div style="display: flex; justify-content: space-between; margin-bottom: 0.75rem; font-size: 0.9rem; color: var(--success);">
                                    <span>Giảm giá voucher:</span>
                                    <span style="font-weight: 700;">
                                        -<fmt:formatNumber value="${sessionScope.discountAmount}" pattern="#,###"/> ₫
                                    </span>
                                </div>
                            </c:if>

                            <div style="display: flex; justify-content: space-between; margin-bottom: 1rem; font-size: 0.9rem; color: var(--text-muted);">
                                <span>Phí vận chuyển:</span>
                                <span style="font-weight: 600; color: var(--success);">Miễn phí</span>
                            </div>

                            <div style="border-top: 1px solid var(--border); padding-top: 1rem; margin-top: 1rem; display: flex; justify-content: space-between; align-items: baseline;">
                                <span style="font-weight: 800; font-size: 1.1rem; color: var(--primary-dark);">Tổng thanh toán:</span>
                                <span style="font-weight: 800; font-size: 1.5rem; color: var(--danger);">
                                    <fmt:formatNumber value="${sessionScope.cartFinalTotal}" pattern="#,###"/> ₫
                                </span>
                            </div>

                            <a href="${pageContext.request.contextPath}/checkout" class="btn btn-primary btn-block" style="margin-top: 1.5rem; padding: 0.85rem; font-size: 1rem;">
                                Tiến Hành Thanh Toán ➔
                            </a>
                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </main>

    <jsp:include page="/common/footer.jsp" />

</body>
</html>