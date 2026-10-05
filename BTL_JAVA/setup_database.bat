@echo off
chcp 65001 > nul
echo ====================================================================
echo  FASHIONSTORE - NẠP CƠ SỞ DỮ LIỆU MYSQL CHUẨN TIẾNG VIỆT UTF-8
echo ====================================================================

set MYSQL_EXE="C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe"
set DB_PASS="dungnv060505"

echo Đang nạp schema và dữ liệu mẫu vào MySQL (database: fashion_store)...
%MYSQL_EXE% -u root -p%DB_PASS% --default-character-set=utf8mb4 -e "source d:/BTL_JAVA/database.sql;"
if %ERRORLEVEL% EQU 0 (
    echo.
    echo [THÀNH CÔNG] Dữ liệu tiếng Việt UTF-8 đã được nạp chuẩn 100%% vào MySQL!
) else (
    echo.
    echo [LỖI] Không kết nối được MySQL với mật khẩu cấu hình. Vui lòng kiểm tra lại mật khẩu root.
)

echo.
pause
