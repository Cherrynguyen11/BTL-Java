<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Đơn Hàng Đa Kênh - FashionStore Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <div class="admin-wrapper">
        <jsp:include page="/common/admin-sidebar.jsp" />

        <main class="admin-main">
            <div class="admin-header">
                <div>
                    <h1 style="font-size: 1.85rem; font-weight: 800; color: var(--primary-dark);">Quản Lý Đơn Hàng Đa Kênh</h1>
                    <p style="color: var(--text-muted); font-size: 0.95rem;">Lọc và cập nhật tiến độ đơn hàng từ Showroom POS, Website Online, Shopee và TikTok Shop.</p>
                </div>
                <div style="display: flex; gap: 0.75rem;">
                    <a href="${pageContext.request.contextPath}/pos" class="btn btn-success btn-sm">
                        + Tạo đơn tại quầy POS
                    </a>
                    <button type="button" class="btn btn-primary btn-sm" onclick="toggleSimulateModal()">
                        ⚡ Giả lập đơn Shopee/TikTok
                    </button>
                </div>
            </div>

            <!-- Filter Controls -->
            <div class="data-card" style="padding: 1.25rem 1.5rem; margin-bottom: 1.5rem;">
                <form action="${pageContext.request.contextPath}/admin" method="get" style="display: flex; flex-wrap: wrap; gap: 1rem; align-items: center;">
                    <input type="hidden" name="page" value="orders">

                    <!-- Channel Filter -->
                    <div style="display: flex; align-items: center; gap: 0.5rem;">
                        <span style="font-weight: 700; font-size: 0.85rem;">Kênh bán:</span>
                        <select name="channel" onchange="this.form.submit()" style="padding: 0.45rem 0.75rem; border: 1px solid var(--border); border-radius: 6px; font-size: 0.85rem;">
                            <option value="ALL" ${selectedChannel == 'ALL' || empty selectedChannel ? 'selected' : ''}>Tất cả kênh bán</option>
                            <option value="STORE_POS" ${selectedChannel == 'STORE_POS' ? 'selected' : ''}>Tại quầy Store POS</option>
                            <option value="WEBSITE" ${selectedChannel == 'WEBSITE' ? 'selected' : ''}>Website Online</option>
                            <option value="SHOPEE" ${selectedChannel == 'SHOPEE' ? 'selected' : ''}>Shopee Mall</option>
                            <option value="TIKTOK" ${selectedChannel == 'TIKTOK' ? 'selected' : ''}>TikTok Shop</option>
                        </select>
                    </div>

                    <!-- Status Filter -->
                    <div style="display: flex; align-items: center; gap: 0.5rem;">
                        <span style="font-weight: 700; font-size: 0.85rem;">Trạng thái:</span>
                        <select name="status" onchange="this.form.submit()" style="padding: 0.45rem 0.75rem; border: 1px solid var(--border); border-radius: 6px; font-size: 0.85rem;">
                            <option value="ALL" ${selectedStatus == 'ALL' || empty selectedStatus ? 'selected' : ''}>Tất cả trạng thái</option>
                            <option value="PENDING" ${selectedStatus == 'PENDING' ? 'selected' : ''}>Chờ xử lý</option>
                            <option value="CONFIRMED" ${selectedStatus == 'CONFIRMED' ? 'selected' : ''}>Đã xác nhận</option>
                            <option value="PROCESSING" ${selectedStatus == 'PROCESSING' ? 'selected' : ''}>Đang đóng gói</option>
                            <option value="SHIPPING" ${selectedStatus == 'SHIPPING' ? 'selected' : ''}>Đang giao hàng</option>
                            <option value="COMPLETED" ${selectedStatus == 'COMPLETED' ? 'selected' : ''}>Hoàn thành</option>
                            <option value="CANCELLED" ${selectedStatus == 'CANCELLED' ? 'selected' : ''}>Đã hủy đơn</option>
                        </select>
                    </div>

                    <!-- Search Input -->
                    <div style="flex: 1; min-width: 200px; display: flex; gap: 0.5rem;">
                        <input type="text" name="keyword" placeholder="Tìm theo mã đơn, tên khách, SĐT..." value="${keyword}" style="width: 100%; padding: 0.45rem 0.75rem; border: 1px solid var(--border); border-radius: 6px; font-size: 0.85rem;">
                        <button type="submit" class="btn btn-dark btn-sm">Tìm kiếm</button>
                    </div>

                    <a href="${pageContext.request.contextPath}/admin?page=orders" class="btn btn-outline-dark btn-sm">Reset</a>
                </form>
            </div>

            <!-- Orders Table -->
            <div class="data-card">
                <div class="data-card-header">
                    <h3>Danh Sách Đơn Hàng (${orders.size()} đơn)</h3>
                </div>
                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Mã đơn</th>
                                <th>Kênh bán</th>
                                <th>Khách hàng</th>
                                <th>Ngày lập</th>
                                <th>Địa chỉ giao</th>
                                <th>Tổng tiền</th>
                                <th>Thanh toán</th>
                                <th>Trạng thái &amp; Cập nhật</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="o" items="${orders}">
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
                                    <td style="font-size: 0.8rem; max-width: 180px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;" title="${o.address}">
                                        ${o.address}
                                    </td>
                                    <td style="font-weight: 800; color: var(--danger);">
                                        <fmt:formatNumber value="${o.totalAmount}" pattern="#,###"/> ₫
                                    </td>
                                    <td>
                                        <span style="font-size: 0.8rem; font-weight: 600; color: ${o.paymentStatus == 'PAID' ? 'var(--success)' : 'var(--warning)'};">
                                            ${o.paymentMethod} (${o.paymentStatus == 'PAID' ? 'Đã thu' : 'Chưa thu'})
                                        </span>
                                    </td>
                                    <td>
                                        <form action="${pageContext.request.contextPath}/admin" method="post" style="display: flex; gap: 0.35rem; align-items: center;">
                                            <input type="hidden" name="action" value="orderStatus">
                                            <input type="hidden" name="page" value="orders">
                                            <input type="hidden" name="id" value="${o.id}">
                                            <select name="status" style="font-size: 0.75rem; padding: 2px 6px; border-radius: 4px; border: 1px solid var(--border);">
                                                <option value="PENDING" ${o.status == 'PENDING' ? 'selected' : ''}>Chờ xử lý</option>
                                                <option value="CONFIRMED" ${o.status == 'CONFIRMED' ? 'selected' : ''}>Đã xác nhận</option>
                                                <option value="PROCESSING" ${o.status == 'PROCESSING' ? 'selected' : ''}>Đang đóng gói</option>
                                                <option value="SHIPPING" ${o.status == 'SHIPPING' ? 'selected' : ''}>Đang giao</option>
                                                <option value="COMPLETED" ${o.status == 'COMPLETED' ? 'selected' : ''}>Hoàn thành</option>
                                                <option value="CANCELLED" ${o.status == 'CANCELLED' ? 'selected' : ''}>Hủy (Hoàn kho)</option>
                                            </select>
                                            <button type="submit" class="btn btn-dark btn-sm" style="padding: 2px 6px; font-size: 0.7rem;">Lưu</button>
                                        </form>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/admin?page=order-detail&id=${o.id}" class="btn btn-outline-dark btn-sm">
                                            Xem chi tiết
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Modal Giả Lập Đơn Sàn TMĐT Shopee/TikTok -->
            <div id="simulateModal" style="display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.6); z-index: 9999; align-items: center; justify-content: center;">
                <div style="background: white; border-radius: var(--radius); padding: 2rem; max-width: 500px; width: 100%; box-shadow: var(--shadow-xl);">
                    <h3 style="font-size: 1.25rem; font-weight: 800; color: var(--primary-dark); margin-bottom: 0.5rem;">
                        ⚡ Đồng Bộ Đơn Hàng Sàn TMĐT Mới
                    </h3>
                    <p style="font-size: 0.85rem; color: var(--text-muted); margin-bottom: 1.25rem;">
                        Mô phỏng Webhook đồng bộ đơn hàng tự động từ gian hàng Shopee Mall hoặc TikTok Shop vào hệ thống kho đa kênh.
                    </p>

                    <form action="${pageContext.request.contextPath}/admin" method="post">
                        <input type="hidden" name="action" value="simulateExternalOrder">
                        <input type="hidden" name="page" value="orders">

                        <div style="margin-bottom: 1rem;">
                            <label style="font-weight: 700; font-size: 0.85rem; display: block; margin-bottom: 0.4rem;">Chọn kênh bán sàn:</label>
                            <select name="channel" style="width: 100%; padding: 0.5rem; border: 1px solid var(--border); border-radius: 6px;">
                                <option value="SHOPEE">🛍️ Shopee Mall</option>
                                <option value="TIKTOK">🎵 TikTok Shop</option>
                            </select>
                        </div>

                        <div style="margin-bottom: 1rem;">
                            <label style="font-weight: 700; font-size: 0.85rem; display: block; margin-bottom: 0.4rem;">Tên khách mua trên sàn:</label>
                            <input type="text" name="customerName" required value="Nguyễn Văn A (Shopee User)" style="width: 100%; padding: 0.5rem; border: 1px solid var(--border); border-radius: 6px;">
                        </div>

                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 0.75rem; margin-bottom: 1rem;">
                            <div>
                                <label style="font-weight: 700; font-size: 0.85rem; display: block; margin-bottom: 0.4rem;">Số điện thoại:</label>
                                <input type="tel" name="phone" required value="0988776655" style="width: 100%; padding: 0.5rem; border: 1px solid var(--border); border-radius: 6px;">
                            </div>
                            <div>
                                <label style="font-weight: 700; font-size: 0.85rem; display: block; margin-bottom: 0.4rem;">Địa chỉ giao:</label>
                                <input type="text" name="address" required value="Số 12 Kim Mã, Ba Đình, Hà Nội" style="width: 100%; padding: 0.5rem; border: 1px solid var(--border); border-radius: 6px;">
                            </div>
                        </div>

                        <div style="margin-bottom: 1.5rem;">
                            <label style="font-weight: 700; font-size: 0.85rem; display: block; margin-bottom: 0.4rem;">Mặt hàng &amp; Biến thể kho trừ:</label>
                            <select name="variantId" style="width: 100%; padding: 0.5rem; border: 1px solid var(--border); border-radius: 6px;">
                                <option value="1">Áo Sơ Mi Oxford Slimfit Trắng - Size M - Trắng</option>
                                <option value="2">Áo Sơ Mi Oxford Slimfit Trắng - Size L - Trắng</option>
                                <option value="5">Áo Thun Cotton Compact 280GSM - Size L - Trắng</option>
                                <option value="8">Áo Polo Thể Thao Phối Viền - Size M - Xanh Navy</option>
                                <option value="11">Quần Jeans Selvedge Denim - Size 30 - Xanh Chàm</option>
                            </select>
                        </div>

                        <div style="display: flex; gap: 0.75rem;">
                            <button type="submit" class="btn btn-primary" style="flex: 1;">Xác nhận tạo đơn sàn</button>
                            <button type="button" class="btn btn-outline-dark" onclick="toggleSimulateModal()" style="flex: 1;">Hủy</button>
                        </div>
                    </form>
                </div>
            </div>

            <script>
                function toggleSimulateModal() {
                    const m = document.getElementById('simulateModal');
                    m.style.display = m.style.display === 'flex' ? 'none' : 'flex';
                }
            </script>

        </main>
    </div>

</body>
</html>