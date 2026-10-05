@echo off
chcp 65001 > nul
title FashionStore Launcher
echo ====================================================================
echo   KHOI DONG HE THONG BAN LE THOI TRANG DA KENH FASHIONSTORE
echo ====================================================================
echo.

:: 1. Kiem tra Tomcat port 8080
netstat -ano | findstr :8080 > nul
if %ERRORLEVEL% EQU 0 (
    echo [OK] May chu Tomcat dang hoat dong tren cong 8080.
) else (
    echo [INFO] Dang khoi dong Apache Tomcat Server...
    start "" "D:\apache-tomcat-10.1.59\bin\startup.bat"
    ping 127.0.0.1 -n 4 > nul
)

:: 2. Mo trinh duyet
echo [INFO] Dang mo trinh duyet Web...
start http://localhost:8080/FashionStore/

echo.
echo ====================================================================
echo   DA MO TRINH DUYET VAO TRANG CHU FASHIONSTORE!
echo ====================================================================
echo.
echo Dia chi he thong:
echo   - Trang Web Khach Hang: http://localhost:8080/FashionStore/
echo   - Man hinh Thu Ngan POS: http://localhost:8080/FashionStore/pos
echo   - Quan Tri Admin:        http://localhost:8080/FashionStore/admin?page=dashboard
echo.
echo Tai khoan dang nhap (Mat khau deu la: 123456):
echo   - Admin: admin
echo   - POS:   staff
echo   - User:  user
echo ====================================================================
echo Nhan phim bat ky de dong cua so nay...
pause > nul
