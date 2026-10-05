<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Ký Tài Khoản - FashionStore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .auth-container {
            min-height: 85vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2.5rem 1.5rem;
        }
        .auth-card {
            background: white;
            border: 1px solid var(--border);
            border-radius: var(--radius);
            box-shadow: var(--shadow-xl);
            width: 100%;
            max-width: 500px;
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
                    Đăng Ký Tài Khoản
                </h1>
                <p style="font-size: 0.875rem; color: var(--text-muted);">
                    Trở thành thành viên để nhận ưu đãi thời trang độc quyền
                </p>
            </div>

            <c:if test="${not empty errorMessage}">
                <div style="background: #fee2e2; border: 1px solid #fca5a5; color: #991b1b; padding: 0.75rem; border-radius: 8px; font-size: 0.85rem; font-weight: 600; margin-bottom: 1.25rem;">
                    ⚠️ ${errorMessage}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/register" method="post">
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-bottom: 1.25rem;">
                    <div>
                        <label style="display: block; font-weight: 700; font-size: 0.85rem; margin-bottom: 0.4rem;">Tên đăng nhập *</label>
                        <input type="text" name="username" required placeholder="username" style="width: 100%; padding: 0.65rem; border: 1px solid var(--border); border-radius: 6px;">
                    </div>
                    <div>
                        <label style="display: block; font-weight: 700; font-size: 0.85rem; margin-bottom: 0.4rem;">Họ và tên *</label>
                        <input type="text" name="fullName" required placeholder="Nguyễn Văn A" style="width: 100%; padding: 0.65rem; border: 1px solid var(--border); border-radius: 6px;">
                    </div>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-bottom: 1.25rem;">
                    <div>
                        <label style="display: block; font-weight: 700; font-size: 0.85rem; margin-bottom: 0.4rem;">Mật khẩu *</label>
                        <input type="password" name="password" required placeholder="••••••••" style="width: 100%; padding: 0.65rem; border: 1px solid var(--border); border-radius: 6px;">
                    </div>
                    <div>
                        <label style="display: block; font-weight: 700; font-size: 0.85rem; margin-bottom: 0.4rem;">Nhập lại mật khẩu *</label>
                        <input type="password" name="confirmPassword" required placeholder="••••••••" style="width: 100%; padding: 0.65rem; border: 1px solid var(--border); border-radius: 6px;">
                    </div>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-bottom: 1.25rem;">
                    <div>
                        <label style="display: block; font-weight: 700; font-size: 0.85rem; margin-bottom: 0.4rem;">Email</label>
                        <input type="email" name="email" placeholder="example@gmail.com" style="width: 100%; padding: 0.65rem; border: 1px solid var(--border); border-radius: 6px;">
                    </div>
                    <div>
                        <label style="display: block; font-weight: 700; font-size: 0.85rem; margin-bottom: 0.4rem;">Số điện thoại *</label>
                        <input type="tel" name="phone" required placeholder="0901234567" style="width: 100%; padding: 0.65rem; border: 1px solid var(--border); border-radius: 6px;">
                    </div>
                </div>

                <div style="margin-bottom: 1.5rem;">
                    <label style="display: block; font-weight: 700; font-size: 0.85rem; margin-bottom: 0.4rem;">Địa chỉ giao hàng mặc định</label>
                    <input type="text" name="address" placeholder="Số nhà, tên đường, quận/huyện, tỉnh/thành..." style="width: 100%; padding: 0.65rem; border: 1px solid var(--border); border-radius: 6px;">
                </div>

                <button type="submit" class="btn btn-primary btn-block" style="padding: 0.8rem; font-size: 1rem;">
                    Đăng Ký Tài Khoản ➔
                </button>
            </form>

            <div style="text-align: center; margin-top: 1.5rem; font-size: 0.875rem; color: var(--text-muted);">
                Đã có tài khoản?
                <a href="${pageContext.request.contextPath}/login" style="color: var(--accent); font-weight: 700;">
                    Đăng nhập tại đây
                </a>
            </div>
        </div>
    </div>

    <jsp:include page="/common/footer.jsp" />

</body>
</html>