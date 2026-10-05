<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Danh Mục - FashionStore Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <div class="admin-wrapper">
        <jsp:include page="/common/admin-sidebar.jsp" />

        <main class="admin-main">
            <div class="admin-header">
                <div>
                    <h1 style="font-size: 1.85rem; font-weight: 800; color: var(--primary-dark);">Danh Mục Thời Trang</h1>
                    <p style="color: var(--text-muted); font-size: 0.95rem;">Quản lý các nhóm ngành hàng thời trang phục vụ trưng bày trên web và quầy POS.</p>
                </div>
                <button type="button" class="btn btn-primary" onclick="toggleAddCategoryModal()">
                    + Thêm Danh Mục
                </button>
            </div>

            <div class="data-card">
                <div class="data-card-header">
                    <h3>Danh Sách Danh Mục (${categories.size()} nhóm hàng)</h3>
                </div>
                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Icon</th>
                                <th>Tên danh mục</th>
                                <th>Mô tả</th>
                                <th>Số lượng sản phẩm</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="c" items="${categories}">
                                <tr>
                                    <td style="font-size: 1.5rem; width: 60px; text-align: center;">${c.icon}</td>
                                    <td style="font-weight: 700; color: var(--primary-dark); font-size: 0.95rem;">${c.name}</td>
                                    <td style="color: var(--text-muted);">${c.description}</td>
                                    <td>
                                        <span class="badge badge-web">${c.productCount} sản phẩm</span>
                                    </td>
                                    <td>
                                        <form action="${pageContext.request.contextPath}/admin" method="post" onsubmit="return confirm('Bạn có chắc chắn muốn xóa danh mục này?')">
                                            <input type="hidden" name="action" value="categoryDelete">
                                            <input type="hidden" name="page" value="categories">
                                            <input type="hidden" name="id" value="${c.id}">
                                            <button type="submit" class="btn btn-outline-dark btn-sm" style="color: var(--danger); border-color: var(--danger);">
                                                🗑️ Xóa
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Modal Thêm Danh Mục -->
            <div id="addCategoryModal" style="display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.6); z-index: 9999; align-items: center; justify-content: center;">
                <div style="background: white; border-radius: var(--radius); padding: 2rem; max-width: 450px; width: 100%; box-shadow: var(--shadow-xl);">
                    <h3 style="font-size: 1.25rem; font-weight: 800; color: var(--primary-dark); margin-bottom: 1rem;">
                        + Thêm Danh Mục Thời Trang
                    </h3>

                    <form action="${pageContext.request.contextPath}/admin" method="post">
                        <input type="hidden" name="action" value="categoryAdd">
                        <input type="hidden" name="page" value="categories">

                        <div style="margin-bottom: 1rem;">
                            <label style="font-weight: 700; font-size: 0.85rem; display: block; margin-bottom: 0.35rem;">Tên danh mục *</label>
                            <input type="text" name="name" required placeholder="Ví dụ: Đồ Thể Thao Activewear" style="width: 100%; padding: 0.5rem; border: 1px solid var(--border); border-radius: 6px;">
                        </div>

                        <div style="margin-bottom: 1rem;">
                            <label style="font-weight: 700; font-size: 0.85rem; display: block; margin-bottom: 0.35rem;">Biểu tượng Icon (Emoji) *</label>
                            <input type="text" name="icon" required value="👕" style="width: 100%; padding: 0.5rem; border: 1px solid var(--border); border-radius: 6px;">
                        </div>

                        <div style="margin-bottom: 1.5rem;">
                            <label style="font-weight: 700; font-size: 0.85rem; display: block; margin-bottom: 0.35rem;">Mô tả danh mục</label>
                            <textarea name="description" rows="2" placeholder="Mô tả phong cách và chất liệu..." style="width: 100%; padding: 0.5rem; border: 1px solid var(--border); border-radius: 6px;"></textarea>
                        </div>

                        <div style="display: flex; gap: 0.75rem;">
                            <button type="submit" class="btn btn-primary" style="flex: 1;">Lưu Danh Mục</button>
                            <button type="button" class="btn btn-outline-dark" onclick="toggleAddCategoryModal()" style="flex: 1;">Hủy</button>
                        </div>
                    </form>
                </div>
            </div>

            <script>
                function toggleAddCategoryModal() {
                    const m = document.getElementById('addCategoryModal');
                    m.style.display = m.style.display === 'flex' ? 'none' : 'flex';
                }
            </script>

        </main>
    </div>

</body>
</html>