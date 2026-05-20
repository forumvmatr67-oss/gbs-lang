@echo off
title GBS Installer
color 0A

echo ====================================
echo      GBS Language Installer
echo ====================================
echo.

:: Создание папок
if not exist "src" mkdir src
if not exist "examples" mkdir examples
if not exist "scripts" mkdir scripts

:: Копирование интерпретатора
copy nul gbs.bat >nul

:: Создание тестового скрипта в examples
(
echo # Example GBS Script
echo print "Hello from GBS!"
echo print "================="
echo set name = "GBS User"
echo print "Welcome, "
echo print name
echo.
echo print "Enter your name:"
echo io.read()
echo print "Hello, "
echo print last_input
) > examples\test.gbs

:: Создание демо скрипта
(
echo # Demo Script
echo print "=== GBS Demo ==="
echo set x = 10
echo set y = 20
echo set sum = x + y
echo print "Sum: "
echo print sum
echo.
echo if x ^< y
echo     print "x is less than y"
echo endif
echo.
echo for i = 1 to 3
echo     print "Count: "
echo     print i
echo end
) > scripts\demo.gbs

echo.
echo ====================================
echo GBS successfully installed!
echo ====================================
echo.
echo Commands:
echo   gbs script.gbs     - run script
echo   find               - find all .gbs files
echo   new name           - create new script
echo   run script.gbs     - run with pause
echo.
echo Examples in 'examples\' and 'scripts\'
echo.
pause
