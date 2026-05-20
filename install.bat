@echo off
echo ====================================
echo      GBS Language Installer
echo ====================================
echo.

if not exist "scripts" mkdir scripts
if not exist "examples" mkdir examples

echo @echo off > gbs.bat
echo setlocal enabledelayedexpansion >> gbs.bat
echo if "%%1"=="" ( >> gbs.bat
echo   echo Usage: gbs script.gbs >> gbs.bat
echo   exit /b 1 >> gbs.bat
echo ) >> gbs.bat
echo if not exist "%%1" ( >> gbs.bat
echo   echo File not found! >> gbs.bat
echo   exit /b 1 >> gbs.bat
echo ) >> gbs.bat
echo for /f "usebackq delims=" %%%%a in ("%%1") do ( >> gbs.bat
echo   set "line=%%%%a" >> gbs.bat
echo   if "!line:~0,5!"=="print" ( >> gbs.bat
echo     echo !line:~6! >> gbs.bat
echo   ) >> gbs.bat
echo   if "!line:~0,3!"=="set" ( >> gbs.bat
echo     echo Setting variable... >> gbs.bat
echo   ) >> gbs.bat
echo   if "!line!"=="io.read()" ( >> gbs.bat
echo     set /p input="^> " >> gbs.bat
echo   ) >> gbs.bat
echo ) >> gbs.bat

echo @echo off > run.bat
echo call gbs.bat %%1 >> run.bat
echo pause >> run.bat

echo print Hello World! > examples\hello.gbs
echo print This is GBS Language >> examples\hello.gbs
echo print ===================== >> examples\hello.gbs
echo io.read() >> examples\hello.gbs

echo.
echo ====================================
echo GBS Installed!
echo ====================================
echo.
echo Commands:
echo   gbs script.gbs
echo   run script.gbs
echo.
echo Example: gbs examples\hello.gbs
echo.
pause
