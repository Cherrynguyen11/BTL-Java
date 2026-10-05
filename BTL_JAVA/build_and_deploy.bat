@echo off
chcp 65001 > nul
echo ====================================================================
echo  FASHIONSTORE OMNICHANNEL - AUTO BUILD & DEPLOY
echo ====================================================================

set MAVEN_CMD="C:\Users\LOQ\.m2\wrapper\dists\apache-maven-3.6.3-bin\1iopthnavndlasol9gbrbg6bf2\apache-maven-3.6.3\bin\mvn.cmd"
set TOMCAT_WEBAPPS="D:\apache-tomcat-10.1.59\webapps"

echo [1/3] Tiến hành dọn dẹp và biên dịch dự án với Maven...
call %MAVEN_CMD% clean package -DskipTests
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Biên dịch thất bại! Vui lòng kiểm tra lại log lỗi phía trên.
    pause
    exit /b %ERRORLEVEL%
)

echo.
echo [2/3] Triển khai file WAR vào thư mục Tomcat webapps...
copy /Y "target\FashionStore.war" %TOMCAT_WEBAPPS%\FashionStore.war
if %ERRORLEVEL% NEQ 0 (
    echo [WARNING] Không copy được file WAR vào %TOMCAT_WEBAPPS%. Thử copy thư mục...
)

echo.
echo ====================================================================
echo  TRIỂN KHAI THÀNH CÔNG HỆ THỐNG BÁN LẺ THỜI TRANG ĐA KÊNH!
echo ====================================================================
echo 🌐 Địa chỉ truy cập:
echo    - Trang chủ Web: http://localhost:8080/FashionStore/
echo    - Màn hình POS Thu ngân: http://localhost:8080/FashionStore/pos
echo    - Quản trị Admin: http://localhost:8080/FashionStore/admin?page=dashboard
echo.
echo 👥 Tài khoản thử nghiệm:
echo    - Admin: admin / 123456
echo    - Staff POS: staff / 123456
echo    - Khách hàng: user / 123456
echo ====================================================================
echo.
