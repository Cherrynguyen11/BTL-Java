<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh Toán Đơn Hàng - FashionStore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <jsp:include page="/common/navbar.jsp" />

    <main class="section">
        <div style="margin-bottom: 2rem;">
            <h1 style="font-size: 1.85rem; font-weight: 800; color: var(--primary-dark);">Thanh Toán Đơn Hàng</h1>
            <p style="color: var(--text-muted); font-size: 0.95rem;">Điền thông tin nhận hàng và lựa chọn phương thức thanh toán an toàn tiện lợi.</p>
        </div>

        <c:if test="${not empty errorMessage}">
            <div style="background: #fee2e2; color: #991b1b; padding: 1rem; border-radius: 8px; margin-bottom: 1.5rem; font-weight: 600;">
                ⚠️ ${errorMessage}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/checkout" method="post">
            <div style="display: grid; grid-template-columns: 1.5fr 1fr; gap: 2.5rem; align-items: start;">

                <!-- Left: Shipping and Payment Form -->
                <div>
                    <!-- Shipping Info Card -->
                    <div style="background: white; border: 1px solid var(--border); border-radius: var(--radius); padding: 2rem; margin-bottom: 2rem; box-shadow: var(--shadow-sm);">
                        <h3 style="font-size: 1.2rem; font-weight: 800; color: var(--primary-dark); margin-bottom: 1.5rem; border-bottom: 1px solid var(--border); padding-bottom: 0.75rem;">
                            1. Địa Chỉ Nhận Hàng
                        </h3>

                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-bottom: 1rem;">
                            <div>
                                <label style="display: block; font-weight: 700; font-size: 0.85rem; margin-bottom: 0.4rem;">Họ và tên người nhận *</label>
                                <input type="text" name="customerName" required value="${currentUser.fullName}" style="width: 100%; padding: 0.65rem 0.85rem; border: 1px solid var(--border); border-radius: 6px; font-family: inherit;">
                            </div>
                            <div>
                                <label style="display: block; font-weight: 700; font-size: 0.85rem; margin-bottom: 0.4rem;">Số điện thoại nhận hàng *</label>
                                <input type="tel" name="phone" required value="${currentUser.phone}" style="width: 100%; padding: 0.65rem 0.85rem; border: 1px solid var(--border); border-radius: 6px; font-family: inherit;">
                            </div>
                        </div>

                        <div style="margin-bottom: 1rem;">
                            <label style="display: block; font-weight: 700; font-size: 0.85rem; margin-bottom: 0.4rem;">Địa chỉ chi tiết (Số nhà, đường, phường/xã, quận/huyện, tỉnh/thành) *</label>
                            <input type="text" name="address" required value="${currentUser.address}" placeholder="Ví dụ: Số 88 Cầu Giấy, Phường Quan Hoa, Quận Cầu Giấy, Hà Nội" style="width: 100%; padding: 0.65rem 0.85rem; border: 1px solid var(--border); border-radius: 6px; font-family: inherit;">
                        </div>

                        <div>
                            <label style="display: block; font-weight: 700; font-size: 0.85rem; margin-bottom: 0.4rem;">Ghi chú đơn hàng (Tùy chọn)</label>
                            <textarea name="notes" rows="2" placeholder="Ghi chú thêm về thời gian giao hàng, chỉ dẫn đường đi..." style="width: 100%; padding: 0.65rem 0.85rem; border: 1px solid var(--border); border-radius: 6px; font-family: inherit; resize: vertical;"></textarea>
                        </div>
                    </div>

                    <!-- Payment Method Card -->
                    <div style="background: white; border: 1px solid var(--border); border-radius: var(--radius); padding: 2rem; box-shadow: var(--shadow-sm);">
                        <h3 style="font-size: 1.2rem; font-weight: 800; color: var(--primary-dark); margin-bottom: 1.5rem; border-bottom: 1px solid var(--border); padding-bottom: 0.75rem;">
                            2. Phương Thức Thanh Toán
                        </h3>

                        <div style="display: flex; flex-direction: column; gap: 1rem;">
                            <!-- COD Option -->
                            <label style="display: flex; align-items: flex-start; gap: 1rem; padding: 1rem; border: 1.5px solid var(--border); border-radius: 8px; cursor: pointer; transition: all 0.2s;" id="codLabel">
                                <input type="radio" name="paymentMethod" value="COD" checked onchange="togglePaymentView('COD')" style="margin-top: 3px;">
                                <div>
                                    <div style="font-weight: 700; color: var(--primary-dark);">💵 Thanh toán khi nhận hàng (COD)</div>
                                    <div style="font-size: 0.85rem; color: var(--text-muted);">Khách hàng kiểm tra đúng mẫu mã, kích thước rồi mới thanh toán tiền mặt cho shipper.</div>
                                </div>
                            </label>

                            <!-- QR Bank Transfer Option -->
                            <label style="display: flex; align-items: flex-start; gap: 1rem; padding: 1rem; border: 1.5px solid var(--border); border-radius: 8px; cursor: pointer; transition: all 0.2s;" id="transferLabel">
                                <input type="radio" name="paymentMethod" value="TRANSFER" onchange="togglePaymentView('TRANSFER')" style="margin-top: 3px;">
                                <div>
                                    <div style="font-weight: 700; color: var(--primary-dark); display: flex; align-items: center; gap: 0.5rem;">
                                        📱 Chuyển khoản QR Ngân hàng (VietQR Tự Động)
                                        <span class="badge badge-pos" style="font-size: 0.65rem;">Khuyên dùng</span>
                                    </div>
                                    <div style="font-size: 0.85rem; color: var(--text-muted);">Quét mã QR qua bất kỳ App ngân hàng nào (Vietcombank, MB, Techcombank...). Tự động điền số tiền và nội dung.</div>
                                </div>
                            </label>

                            <!-- VietQR Preview Box (Hidden by default) -->
                            <div id="qrPreviewBox" style="display: none; background: #f8fafc; border: 1px dashed var(--accent); border-radius: 8px; padding: 1.5rem; text-align: center;">
                                <h4 style="font-weight: 700; color: var(--primary-dark); margin-bottom: 0.5rem;">Quét Mã VietQR Để Thanh Toán Nhanh</h4>
                                <p style="font-size: 0.825rem; color: var(--text-muted); margin-bottom: 1rem;">Mở ứng dụng ngân hàng bất kỳ và chọn "Quét QR"</p>
                                <img src="${qrUrl}" alt="VietQR" style="max-width: 200px; border-radius: 8px; box-shadow: var(--shadow-sm); margin-bottom: 1rem;">
                                <div style="font-size: 0.85rem; line-height: 1.7; text-align: left; background: white; padding: 1rem; border-radius: 6px; border: 1px solid var(--border);">
                                    <div>Ngân hàng: <b>${bankName}</b></div>
                                    <div>Số tài khoản: <b style="color: var(--accent);">${accountNo}</b></div>
                                    <div>Chủ tài khoản: <b>${accountName}</b></div>
                                    <div>Số tiền: <b style="color: var(--danger);"><fmt:formatNumber value="${sessionScope.cartFinalTotal}" pattern="#,###"/> ₫</b></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right: Order Items Summary -->
                <div style="background: white; border: 1px solid var(--border); border-radius: var(--radius); padding: 1.75rem; box-shadow: var(--shadow-sm); position: sticky; top: 90px;">
                    <h3 style="font-size: 1.15rem; font-weight: 800; color: var(--primary-dark); margin-bottom: 1.25rem; border-bottom: 1px solid var(--border); padding-bottom: 0.75rem;">
                        Đơn Hàng (${sessionScope.cartTotalItems} sản phẩm)
                    </h3>

                    <div style="max-height: 260px; overflow-y: auto; margin-bottom: 1rem;">
                        <c:forEach var="entry" items="${sessionScope.cart}">
                            <c:set var="item" value="${entry.value}" />
                            <div style="display: flex; gap: 0.75rem; align-items: center; margin-bottom: 0.75rem; padding-bottom: 0.75rem; border-bottom: 1px dashed var(--border);">
                                <img src="${item.product.image}" alt="${item.product.name}" style="width: 45px; height: 55px; object-fit: cover; border-radius: 4px;">
                                <div style="flex: 1; font-size: 0.85rem;">
                                    <div style="font-weight: 700; color: var(--primary-dark);">${item.product.name}</div>
                                    <div style="color: var(--text-muted); font-size: 0.75rem;">Size: ${item.size} | Màu: ${item.color} | x${item.quantity}</div>
                                </div>
                                <div style="font-weight: 700; font-size: 0.85rem; color: var(--danger);">
                                    <fmt:formatNumber value="${item.subtotal}" pattern="#,###"/> ₫
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Price breakdown -->
                    <div style="font-size: 0.875rem; line-height: 2; color: var(--text-muted); border-top: 1px solid var(--border); padding-top: 0.75rem;">
                        <div style="display: flex; justify-content: space-between;">
                            <span>Tạm tính:</span>
                            <span style="font-weight: 700; color: var(--primary-dark);"><fmt:formatNumber value="${sessionScope.cartSubtotal}" pattern="#,###"/> ₫</span>
                        </div>
                        <c:if test="${not empty sessionScope.discountAmount && sessionScope.discountAmount > 0}">
                            <div style="display: flex; justify-content: space-between; color: var(--success);">
                                <span>Giảm giá (Voucher):</span>
                                <span style="font-weight: 700;">-<fmt:formatNumber value="${sessionScope.discountAmount}" pattern="#,###"/> ₫</span>
                            </div>
                        </c:if>
                        <div style="display: flex; justify-content: space-between;">
                            <span>Phí giao hàng:</span>
                            <span style="font-weight: 600; color: var(--success);">0 ₫ (Miễn phí)</span>
                        </div>
                    </div>

                    <div style="border-top: 2px solid var(--border); margin-top: 1rem; padding-top: 1rem; display: flex; justify-content: space-between; align-items: baseline;">
                        <span style="font-size: 1.1rem; font-weight: 800; color: var(--primary-dark);">Tổng thanh toán:</span>
                        <span style="font-size: 1.6rem; font-weight: 800; color: var(--danger);">
                            <fmt:formatNumber value="${sessionScope.cartFinalTotal}" pattern="#,###"/> ₫
                        </span>
                    </div>

                    <button type="submit" class="btn btn-primary btn-block" style="margin-top: 1.5rem; padding: 0.85rem; font-size: 1.05rem;">
                        Xác Nhận Đặt Hàng ➔
                    </button>
                </div>

            </div>
        </form>
    </main>

    <script>
        function togglePaymentView(method) {
            const qrBox = document.getElementById('qrPreviewBox');
            if (method === 'TRANSFER') {
                qrBox.style.display = 'block';
            } else {
                qrBox.style.display = 'none';
            }
        }
    </script>

    <jsp:include page="/common/footer.jsp" />

</body>
</html>