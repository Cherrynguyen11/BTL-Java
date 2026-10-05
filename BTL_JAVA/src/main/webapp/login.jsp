<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập - FashionStore Omnichannel</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .auth-container {
            min-height: 85vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem 1.5rem;
        }
        .auth-card {
            background: white;
            border: 1px solid var(--border);
            border-radius: var(--radius);
            box-shadow: var(--shadow-xl);
            width: 100%;
            max-width: 440px;
            padding: 2.5rem;
        }
    </style>
</head>
<body>

    <jsp:include page="/common/navbar.jsp" />

    <div class="auth-container">
        <div class="auth-card">
            <div style="text-align: center; margin-bottom: 2rem;">
                <span style="font-size: 2rem;">✦</span>
                <h1 style="font-size: 1.65rem; font-weight: 800; color: var(--primary-dark); margin-top: 0.25rem;">
                    Đăng Nhập
                </h1>
                <p style="font-size: 0.875rem; color: var(--text-muted);">
                    Hệ thống bán lẻ thời trang đa kênh FashionStore
                </p>
            </div>

            <c:if test="${not empty errorMessage}">
                <div style="background: #fee2e2; border: 1px solid #fca5a5; color: #991b1b; padding: 0.75rem; border-radius: 8px; font-size: 0.85rem; font-weight: 600; margin-bottom: 1.25rem;">
                    ⚠️ ${errorMessage}
                </div>
            </c:if>

            <c:if test="${param.error == 'unauthorized'}">
                <div style="background: #fffbeb; border: 1px solid #fde68a; color: #92400e; padding: 0.75rem; border-radius: 8px; font-size: 0.85rem; font-weight: 600; margin-bottom: 1.25rem;">
                    🔒 Vui lòng đăng nhập với tài khoản có quyền truy cập!
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="post">
                <c:if test="${not empty param.redirect}">
                    <input type="hidden" name="redirect" value="${param.redirect}">
                </c:if>

                <div style="margin-bottom: 1.25rem;">
                    <label style="display: block; font-weight: 700; font-size: 0.85rem; margin-bottom: 0.4rem;">Tên đăng nhập</label>
                    <input type="text" name="username" id="loginUsername" required value="${username}" placeholder="Nhập username..." style="width: 100%; padding: 0.65rem 0.85rem; border: 1px solid var(--border); border-radius: 8px; font-size: 0.9rem;">
                </div>

                <div style="margin-bottom: 1.5rem;">
                    <label style="display: block; font-weight: 700; font-size: 0.85rem; margin-bottom: 0.4rem;">Mật khẩu</label>
                    <input type="password" name="password" id="loginPassword" required placeholder="Nhập mật khẩu..." style="width: 100%; padding: 0.65rem 0.85rem; border: 1px solid var(--border); border-radius: 8px; font-size: 0.9rem;">
                </div>

                <button type="submit" class="btn btn-primary btn-block" style="padding: 0.8rem; font-size: 1rem;">
                    Đăng Nhập ➔
                </button>
            </form>

            <!-- Quick fill helper box -->
            <div style="background: #f8fafc; border: 1px solid var(--border); border-radius: 8px; padding: 1rem; margin-top: 1.5rem; font-size: 0.8rem;">
                <div style="font-weight: 700; color: var(--primary-dark); margin-bottom: 0.5rem;">⚡ Tài khoản mẫu có sẵn (Click để điền nhanh):</div>
                <div style="display: flex; flex-direction: column; gap: 0.35rem;">
                    <a href="javascript:void(0)" onclick="quickFill('admin','123456')" style="color: var(--accent); font-weight: 600;">
                        👑 Quản trị viên (Admin): <b>admin</b> / 123456
                    </a>
                    <a href="javascript:void(0)" onclick="quickFill('staff','123456')" style="color: var(--pos-color); font-weight: 600;">
                        🏪 Thu ngân tại quầy (Staff POS): <b>staff</b> / 123456
                    </a>
                    <a href="javascript:void(0)" onclick="quickFill('user','123456')" style="color: var(--web-color); font-weight: 600;">
                        👤 Khách hàng mua sắm: <b>user</b> / 123456
                    </a>
                </div>
            </div>

            <div style="text-align: center; margin-top: 1.5rem; font-size: 0.875rem; color: var(--text-muted);">
                Chưa có tài khoản?
                <a href="${pageContext.request.contextPath}/register" style="color: var(--accent); font-weight: 700;">
                    Đăng ký ngay
                </a>
            </div>
        </div>
    </div>

    <script>
        function quickFill(u, p) {
            document.getElementById('loginUsername').value = u;
            document.getElementById('loginPassword').value = p;
        }
    </script>

    <jsp:include page="/common/footer.jsp" />

</body>
</html>