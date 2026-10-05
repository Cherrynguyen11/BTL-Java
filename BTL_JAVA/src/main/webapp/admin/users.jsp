<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Người Dùng &amp; Phân Quyền - FashionStore Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <div class="admin-wrapper">
        <jsp:include page="/common/admin-sidebar.jsp" />

        <main class="admin-main">
            <div class="admin-header">
                <div>
                    <h1 style="font-size: 1.85rem; font-weight: 800; color: var(--primary-dark);">Quản Lý Người Dùng &amp; Phân Quyền</h1>
                    <p style="color: var(--text-muted); font-size: 0.95rem;">Quản lý tài khoản quản trị viên (Admin), nhân viên thu ngân (Staff) và khách hàng CRM.</p>
                </div>
            </div>

            <div class="data-card">
                <div class="data-card-header">
                    <h3>Danh Sách Tài Khoản (${users.size()} người dùng)</h3>
                </div>
                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Tên đăng nhập</th>
                                <th>Họ và tên</th>
                                <th>Email</th>
                                <th>Số điện thoại</th>
                                <th>Địa chỉ</th>
                                <th>Vai trò (Phân quyền)</th>
                                <th>Trạng thái</th>
                                <th>Ngày tạo</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="u" items="${users}">
                                <tr>
                                    <td style="font-weight: 700; color: var(--primary-dark); font-family: monospace;">
                                        ${u.username}
                                    </td>
                                    <td><b>${u.fullName}</b></td>
                                    <td style="font-size: 0.825rem; color: var(--text-muted);">${u.email}</td>
                                    <td style="font-size: 0.825rem;">${u.phone}</td>
                                    <td style="font-size: 0.8rem; max-width: 150px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                        ${u.address}
                                    </td>
                                    <td>
                                        <form action="${pageContext.request.contextPath}/admin" method="post" style="display: flex; gap: 0.3rem; align-items: center;">
                                            <input type="hidden" name="action" value="userRole">
                                            <input type="hidden" name="page" value="users">
                                            <input type="hidden" name="userId" value="${u.id}">
                                            <select name="role" style="font-size: 0.75rem; padding: 2px 6px; border-radius: 4px; border: 1px solid var(--border); font-weight: 700;">
                                                <option value="ADMIN" ${u.role == 'ADMIN' ? 'selected' : ''}>ADMIN</option>
                                                <option value="STAFF" ${u.role == 'STAFF' ? 'selected' : ''}>STAFF</option>
                                                <option value="CUSTOMER" ${u.role == 'CUSTOMER' ? 'selected' : ''}>CUSTOMER</option>
                                            </select>
                                            <button type="submit" class="btn btn-dark btn-sm" style="padding: 2px 6px; font-size: 0.7rem;">Lưu</button>
                                        </form>
                                    </td>
                                    <td>
                                        <span class="status-badge ${u.status == 1 ? 'status-completed' : 'status-cancelled'}">
                                            ${u.status == 1 ? 'Hoạt động' : 'Bị khóa'}
                                        </span>
                                    </td>
                                    <td style="font-size: 0.8rem; color: var(--text-muted);">
                                        <fmt:formatDate value="${u.createdAt}" pattern="dd/MM/yyyy"/>
                                    </td>
                                    <td>
                                        <form action="${pageContext.request.contextPath}/admin" method="post">
                                            <input type="hidden" name="action" value="userToggleStatus">
                                            <input type="hidden" name="page" value="users">
                                            <input type="hidden" name="userId" value="${u.id}">
                                            <button type="submit" class="btn btn-outline-dark btn-sm" style="font-size: 0.75rem; padding: 2px 6px;">
                                                ${u.status == 1 ? 'Khóa TK' : 'Mở khóa'}
                                            </button>
                                        </form>
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