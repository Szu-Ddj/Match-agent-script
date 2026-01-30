@echo off
:: 1. 核心修复：先设置代码页+强制脚本编码为UTF-8（解决乱码）
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion
title 启动HTTP服务器 (dist目录 - 8080端口)

:: 2. 输出当前工作目录（方便排查路径问题）
echo 当前脚本运行目录：%cd%
echo.

:: ===================== 第一步：检查dist目录是否存在 =====================
:: echo [1/3] 检查dist目录...
:: if not exist "%cd%\dist" (
::     echo ❌ 错误：当前目录下未找到dist文件夹！
::     echo    当前目录：%cd%
::     echo    请确保脚本放在dist目录的同级目录下运行。
::     pause
::     exit /b 1
:: )
:: echo ✅ dist目录存在（路径：%cd%\dist）
:: 
:: ===================== 第二步：检查Python是否安装 =====================
echo [2/3] 检查Python环境...
where python >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ 错误：未找到Python环境！
    echo    请先安装Python并添加到系统环境变量中。
    echo    Python下载地址：https://www.python.org/downloads/
    pause
    exit /b 1
)
:: 验证Python命令是否可用（避免where检测到但python命令执行失败）
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ 错误：Python环境异常，无法执行python命令！
    pause
    exit /b 1
)
echo ✅ Python环境已安装

:: ===================== 第三步：进入dist目录并启动服务器 =====================
echo [3/3] 进入dist目录并启动HTTP服务器...
:: 强制切换到dist绝对路径（彻底解决路径找不到问题）
:: pushd "%cd%\dist"
:: if %errorlevel% neq 0 (
::     echo ❌ 错误：无法进入dist目录！
::     echo    目标路径：%cd%\dist
::     pause
::     exit /b 1
:: )

:: 启动服务器时强制绑定IPv4（避免显示IPv6的[::]地址）
python -m http.server 8899 --bind 127.0.0.1
echo.
echo 🚀 HTTP服务器已启动：
echo    访问地址：http://localhost:8080 （推荐）
echo    备用地址：http://127.0.0.1:8080
echo    停止服务器：按 Ctrl + C
echo.

:: ===================== 异常处理 =====================
if %errorlevel% neq 0 (
    echo.
    echo ❌ 服务器启动失败！
    pause
    exit /b 1
)

:: 恢复原始目录（可选，不影响核心功能）
popd
endlocal