<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kho Hàng Tập Trung Đa Kênh - FashionStore Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <div class="admin-wrapper">
        <jsp:include page="/common/admin-sidebar.jsp" />

        <main class="admin-main">
            <div class="admin-header">
                <div>
                    <h1 style="font-size: 1.85rem; font-weight: 800; color: var(--primary-dark);">Kho Hàng Tập Trung Đa Kênh</h1>
                    <p style="color: var(--text-muted); font-size: 0.95rem;">Theo dõi tồn kho thời gian thực theo từng biến thể (Size &amp; Màu) dùng chung cho POS, Web, Shopee, TikTok.</p>
                </div>
            </div>

            <!-- Warehouse overview banner -->
            <div style="background: linear-gradient(135deg, #1e293b, #0f172a); color: white; border-radius: var(--radius); padding: 1.75rem; margin-bottom: 2rem; display: flex; justify-content: space-between; align-items: center;">
                <div>
                    <h3 style="font-size: 1.25rem; font-weight: 800; color: #fcd34d; margin-bottom: 0.5rem;">
                        ⚡ Đồng Bộ Tồn Kho Tập Trung (Single-Source-of-Truth)
                    </h3>
                    <p style="font-size: 0.875rem; color: #cbd5e1; max-width: 600px; line-height: 1.6;">
                        Mọi giao dịch bán ra tại quầy POS hay qua Website hoặc Sàn TMĐT đều tự động khấu trừ trực tiếp số lượng của từng biến thể tương ứng, ngăn ngừa triệt để tình trạng bán vượt kho (overselling).
                    </p>
                </div>
                <div style="display: flex; gap: 1rem;">
                    <div style="background: rgba(255,255,255,0.1); padding: 1rem 1.5rem; border-radius: 8px; text-align: center;">
                        <div style="font-size: 1.75rem; font-weight: 800; color: #34d399;">${products.size()}</div>
                        <div style="font-size: 0.75rem; color: #94a3b8;">Mẫu sản phẩm</div>
                    </div>
                </div>
            </div>

            <!-- Low Stock Warnings -->
            <div class="data-card" style="border-left: 4px solid var(--danger);">
                <div class="data-card-header" style="background: #fff1f2;">
                    <h3 style="color: #9f1239;">🚨 Danh Sách Biến Thể Sắp Hết Hàng (&le; 10 cái)</h3>
                    <span style="font-size: 0.8rem; font-weight: 700; color: #9f1239;">${lowStockVariants.size()} biến thể cần nhập gấp</span>
                </div>
                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Mã SKU / Sản phẩm</th>
                                <th>Size</th>
                                <th>Màu sắc</th>
                                <th>Tồn kho hiện tại</th>
                                <th>Nhập thêm hàng</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="lv" items="${lowStockVariants}">
                                <tr>
                                    <td style="font-weight: 700;">${lv.sku}</td>
                                    <td><span style="background: #f1f5f9; padding: 2px 8px; border-radius: 4px; font-weight: 700;">${lv.size}</span></td>
                                    <td>${lv.color}</td>
                                    <td>
                                        <span style="font-weight: 800; color: var(--danger); font-size: 1.05rem;">
                                            ${lv.quantity} cái
                                        </span>
                                    </td>
                                    <td>
                                        <form action="${pageContext.request.contextPath}/admin" method="post" style="display: flex; gap: 0.5rem; align-items: center;">
                                            <input type="hidden" name="action" value="updateStock">
                                            <input type="hidden" name="page" value="inventory">
                                            <input type="hidden" name="variantId" value="${lv.id}">
                                            <input type="number" name="addQuantity" value="20" min="1" style="width: 70px; padding: 0.3rem 0.5rem; border: 1px solid var(--border); border-radius: 4px; font-weight: 700;">
                                            <button type="submit" class="btn btn-dark btn-sm">+ Nhập kho</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- All Inventory Details -->
            <div class="data-card">
                <div class="data-card-header">
                    <h3>Chi Tiết Tồn Kho Toàn Bộ Sản Phẩm</h3>
                </div>
                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Ảnh</th>
                                <th>Sản phẩm</th>
                                <th>Danh mục</th>
                                <th>Tổng kho</th>
                                <th>Chi tiết các biến thể &amp; Thao tác nhập thêm</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="p" items="${products}">
                                <tr>
                                    <td>
                                        <img src="${p.image}" alt="${p.name}" style="width: 45px; height: 55px; object-fit: cover; border-radius: 4px;">
                                    </td>
                                    <td style="font-weight: 700; color: var(--primary-dark);">${p.name}</td>
                                    <td>${p.categoryName}</td>
                                    <td style="font-weight: 800; color: ${p.stock <= 10 ? 'var(--danger)' : 'var(--success)'};">
                                        ${p.stock} cái
                                    </td>
                                    <td>
                                        <div style="display: flex; flex-direction: column; gap: 0.5rem;">
                                            <c:forEach var="v" items="${p.variants}">
                                                <div style="display: flex; align-items: center; justify-content: space-between; background: #f8fafc; padding: 0.4rem 0.75rem; border-radius: 6px; font-size: 0.825rem;">
                                                    <div>
                                                        <b>Size ${v.size}</b> - Màu: <b>${v.color}</b>
                                                        (SKU: <code style="font-size: 0.75rem;">${v.sku}</code>)
                                                    </div>
                                                    <div style="display: flex; align-items: center; gap: 0.75rem;">
                                                        <span style="font-weight: 700; color: ${v.quantity <= 5 ? 'var(--danger)' : 'var(--primary-dark)'};">
                                                            Tồn: ${v.quantity}
                                                        </span>
                                                        <form action="${pageContext.request.contextPath}/admin" method="post" style="display: flex; gap: 0.3rem;">
                                                            <input type="hidden" name="action" value="updateStock">
                                                            <input type="hidden" name="page" value="inventory">
                                                            <input type="hidden" name="variantId" value="${v.id}">
                                                            <input type="number" name="addQuantity" value="10" min="1" style="width: 60px; padding: 2px 4px; border: 1px solid var(--border); border-radius: 4px; font-size: 0.8rem;">
                                                            <button type="submit" class="btn btn-outline-dark btn-sm" style="padding: 2px 6px; font-size: 0.75rem;">+ Nhập</button>
                                                        </form>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

        </main>
    </div>

</body>
</html>
