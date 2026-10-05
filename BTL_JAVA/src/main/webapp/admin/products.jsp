<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Sản Phẩm Thời Trang - FashionStore Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <div class="admin-wrapper">
        <jsp:include page="/common/admin-sidebar.jsp" />

        <main class="admin-main">
            <div class="admin-header">
                <div>
                    <h1 style="font-size: 1.85rem; font-weight: 800; color: var(--primary-dark);">Quản Lý Sản Phẩm Thời Trang</h1>
                    <p style="color: var(--text-muted); font-size: 0.95rem;">Quản lý danh mục mẫu mã, định giá, hình ảnh và các biến thể kích thước / màu sắc.</p>
                </div>
                <button type="button" class="btn btn-primary" onclick="toggleAddProductModal()">
                    + Thêm Sản Phẩm Mới
                </button>
            </div>

            <!-- Products Table -->
            <div class="data-card">
                <div class="data-card-header">
                    <h3>Danh Sách Mẫu Thời Trang (${products.size()} sản phẩm)</h3>
                </div>
                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Ảnh</th>
                                <th>Tên sản phẩm</th>
                                <th>Danh mục</th>
                                <th>Giá bán lẻ</th>
                                <th>Giá gốc</th>
                                <th>Tồn kho</th>
                                <th>Biến thể (Size / Màu / Tồn)</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="p" items="${products}">
                                <tr>
                                    <td>
                                        <img src="${p.image}" alt="${p.name}" style="width: 50px; height: 60px; object-fit: cover; border-radius: 6px;">
                                    </td>
                                    <td>
                                        <div style="font-weight: 700; color: var(--primary-dark);">${p.name}</div>
                                        <div style="font-size: 0.75rem; color: var(--text-muted);">Mã: FS-${p.id}</div>
                                    </td>
                                    <td>${p.categoryName}</td>
                                    <td style="font-weight: 700; color: var(--danger);">
                                        <fmt:formatNumber value="${p.price}" pattern="#,###"/> ₫
                                    </td>
                                    <td style="color: var(--text-muted); text-decoration: line-through;">
                                        <fmt:formatNumber value="${p.originalPrice}" pattern="#,###"/> ₫
                                    </td>
                                    <td>
                                        <span style="font-weight: 800; color: ${p.stock <= 10 ? 'var(--danger)' : 'var(--success)'};">
                                            ${p.stock} cái
                                        </span>
                                    </td>
                                    <td>
                                        <div style="display: flex; flex-wrap: wrap; gap: 0.35rem; max-width: 250px;">
                                            <c:forEach var="v" items="${p.variants}">
                                                <span style="background: #f1f5f9; border: 1px solid var(--border); padding: 2px 6px; border-radius: 4px; font-size: 0.75rem;">
                                                    <b>${v.size}</b>-${v.color}: <b style="color: ${v.quantity <= 5 ? 'var(--danger)' : 'var(--primary)'};">${v.quantity}</b>
                                                </span>
                                            </c:forEach>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="status-badge ${p.status == 1 ? 'status-completed' : 'status-cancelled'}">
                                            ${p.status == 1 ? 'Đang bán' : 'Tạm ẩn'}
                                        </span>
                                    </td>
                                    <td>
                                        <div style="display: flex; gap: 0.35rem;">
                                            <button type="button" class="btn btn-outline-dark btn-sm" onclick="openAddVariantModal(${p.id}, '${p.name}')" title="Thêm biến thể size/màu">
                                                + Biến thể
                                            </button>
                                            <form action="${pageContext.request.contextPath}/admin" method="post" onsubmit="return confirm('Bạn có chắc chắn muốn xóa sản phẩm này?')">
                                                <input type="hidden" name="action" value="productDelete">
                                                <input type="hidden" name="page" value="products">
                                                <input type="hidden" name="id" value="${p.id}">
                                                <button type="submit" class="btn btn-outline-dark btn-sm" style="color: var(--danger); border-color: var(--danger);" title="Xóa">
                                                    🗑️
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Modal Thêm Sản Phẩm Mới -->
            <div id="addProductModal" style="display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.6); z-index: 9999; align-items: center; justify-content: center;">
                <div style="background: white; border-radius: var(--radius); padding: 2rem; max-width: 600px; width: 100%; box-shadow: var(--shadow-xl); max-height: 90vh; overflow-y: auto;">
                    <h3 style="font-size: 1.3rem; font-weight: 800; color: var(--primary-dark); margin-bottom: 1.25rem;">
                        + Thêm Mới Sản Phẩm Thời Trang
                    </h3>

                    <form action="${pageContext.request.contextPath}/admin" method="post">
                        <input type="hidden" name="action" value="productAdd">
                        <input type="hidden" name="page" value="products">

                        <div style="margin-bottom: 1rem;">
                            <label style="font-weight: 700; font-size: 0.85rem; display: block; margin-bottom: 0.35rem;">Tên sản phẩm *</label>
                            <input type="text" name="name" required placeholder="Ví dụ: Áo Sơ Mi Linen Cổ Tàu" style="width: 100%; padding: 0.5rem; border: 1px solid var(--border); border-radius: 6px;">
                        </div>

                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-bottom: 1rem;">
                            <div>
                                <label style="font-weight: 700; font-size: 0.85rem; display: block; margin-bottom: 0.35rem;">Danh mục *</label>
                                <select name="categoryId" required style="width: 100%; padding: 0.5rem; border: 1px solid var(--border); border-radius: 6px;">
                                    <c:forEach var="c" items="${categories}">
                                        <option value="${c.id}">${c.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div>
                                <label style="font-weight: 700; font-size: 0.85rem; display: block; margin-bottom: 0.35rem;">URL Hình ảnh (Chất lượng cao) *</label>
                                <input type="url" name="image" required value="https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=800" style="width: 100%; padding: 0.5rem; border: 1px solid var(--border); border-radius: 6px;">
                            </div>
                        </div>

                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-bottom: 1rem;">
                            <div>
                                <label style="font-weight: 700; font-size: 0.85rem; display: block; margin-bottom: 0.35rem;">Giá bán lẻ (VNĐ) *</label>
                                <input type="number" name="price" required placeholder="350000" style="width: 100%; padding: 0.5rem; border: 1px solid var(--border); border-radius: 6px;">
                            </div>
                            <div>
                                <label style="font-weight: 700; font-size: 0.85rem; display: block; margin-bottom: 0.35rem;">Giá niêm yết gốc (VNĐ)</label>
                                <input type="number" name="originalPrice" placeholder="450000" style="width: 100%; padding: 0.5rem; border: 1px solid var(--border); border-radius: 6px;">
                            </div>
                        </div>

                        <div style="margin-bottom: 1rem;">
                            <label style="font-weight: 700; font-size: 0.85rem; display: block; margin-bottom: 0.35rem;">Mô tả chi tiết sản phẩm</label>
                            <textarea name="description" rows="2" placeholder="Chất vải, kiểu dáng, hướng dẫn phối đồ..." style="width: 100%; padding: 0.5rem; border: 1px solid var(--border); border-radius: 6px;"></textarea>
                        </div>

                        <!-- Khởi tạo biến thể ban đầu -->
                        <div style="background: #f8fafc; border: 1px solid var(--border); border-radius: 8px; padding: 1rem; margin-bottom: 1.5rem;">
                            <label style="font-weight: 700; font-size: 0.85rem; display: block; margin-bottom: 0.5rem;">Tạo các biến thể ban đầu:</label>
                            <div style="display: flex; gap: 1rem; align-items: center; margin-bottom: 0.5rem;">
                                <span style="font-size: 0.8rem; font-weight: 600;">Size:</span>
                                <label><input type="checkbox" name="sizes" value="S" checked> S</label>
                                <label><input type="checkbox" name="sizes" value="M" checked> M</label>
                                <label><input type="checkbox" name="sizes" value="L" checked> L</label>
                                <label><input type="checkbox" name="sizes" value="XL"> XL</label>
                            </div>
                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 0.75rem;">
                                <div>
                                    <label style="font-size: 0.8rem; font-weight: 600;">Màu sắc ban đầu:</label>
                                    <input type="text" name="color" value="Trắng" style="width: 100%; padding: 0.35rem; border: 1px solid var(--border); border-radius: 4px; font-size: 0.85rem;">
                                </div>
                                <div>
                                    <label style="font-size: 0.8rem; font-weight: 600;">Số lượng tồn mỗi size:</label>
                                    <input type="number" name="initialQuantity" value="20" style="width: 100%; padding: 0.35rem; border: 1px solid var(--border); border-radius: 4px; font-size: 0.85rem;">
                                </div>
                            </div>
                        </div>

                        <div style="display: flex; gap: 0.75rem;">
                            <button type="submit" class="btn btn-primary" style="flex: 1;">Lưu Sản Phẩm</button>
                            <button type="button" class="btn btn-outline-dark" onclick="toggleAddProductModal()" style="flex: 1;">Hủy</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Modal Thêm Biến Thể Size/Màu Riêng -->
            <div id="addVariantModal" style="display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.6); z-index: 9999; align-items: center; justify-content: center;">
                <div style="background: white; border-radius: var(--radius); padding: 2rem; max-width: 420px; width: 100%; box-shadow: var(--shadow-xl);">
                    <h3 style="font-size: 1.2rem; font-weight: 800; color: var(--primary-dark); margin-bottom: 0.5rem;">
                        + Thêm Biến Thể Sản Phẩm
                    </h3>
                    <p id="variantProductName" style="font-size: 0.85rem; color: var(--text-muted); margin-bottom: 1.25rem;"></p>

                    <form action="${pageContext.request.contextPath}/admin" method="post">
                        <input type="hidden" name="action" value="addVariant">
                        <input type="hidden" name="page" value="products">
                        <input type="hidden" name="productId" id="variantProductId">

                        <div style="margin-bottom: 1rem;">
                            <label style="font-weight: 700; font-size: 0.85rem; display: block; margin-bottom: 0.35rem;">Kích thước (Size):</label>
                            <input type="text" name="size" required placeholder="Ví dụ: S, M, L, XL, 30, 31, 32" style="width: 100%; padding: 0.5rem; border: 1px solid var(--border); border-radius: 6px;">
                        </div>

                        <div style="margin-bottom: 1rem;">
                            <label style="font-weight: 700; font-size: 0.85rem; display: block; margin-bottom: 0.35rem;">Màu sắc:</label>
                            <input type="text" name="color" required placeholder="Ví dụ: Đen, Trắng, Xanh Navy, Be..." style="width: 100%; padding: 0.5rem; border: 1px solid var(--border); border-radius: 6px;">
                        </div>

                        <div style="margin-bottom: 1.5rem;">
                            <label style="font-weight: 700; font-size: 0.85rem; display: block; margin-bottom: 0.35rem;">Số lượng tồn kho ban đầu:</label>
                            <input type="number" name="quantity" required value="15" min="0" style="width: 100%; padding: 0.5rem; border: 1px solid var(--border); border-radius: 6px;">
                        </div>

                        <div style="display: flex; gap: 0.75rem;">
                            <button type="submit" class="btn btn-primary" style="flex: 1;">Thêm Biến Thể</button>
                            <button type="button" class="btn btn-outline-dark" onclick="closeAddVariantModal()" style="flex: 1;">Hủy</button>
                        </div>
                    </form>
                </div>
            </div>

            <script>
                function toggleAddProductModal() {
                    const m = document.getElementById('addProductModal');
                    m.style.display = m.style.display === 'flex' ? 'none' : 'flex';
                }

                function openAddVariantModal(pId, pName) {
                    document.getElementById('variantProductId').value = pId;
                    document.getElementById('variantProductName').innerText = 'Sản phẩm: ' + pName;
                    document.getElementById('addVariantModal').style.display = 'flex';
                }

                function closeAddVariantModal() {
                    document.getElementById('addVariantModal').style.display = 'none';
                }
            </script>

        </main>
    </div>

</body>
</html>