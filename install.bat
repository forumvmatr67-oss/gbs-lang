@echo off
chcp 65001 >nul
color 0A
title GBS Installer

echo ====================================
echo      GBS Language Installer
echo ====================================
echo.

:: Создание папок
if not exist "src" mkdir src
if not exist "examples" mkdir examples
if not exist "scripts" mkdir scripts

:: Создание интерпретатора
echo Creating interpreter...

:: Создаем gbs.bat
echo @echo off > gbs.bat
echo chcp 65001 ^>nul >> gbs.bat
echo python gbs.py %%1 >> gbs.bat

:: Создаем run.bat
echo @echo off > run.bat
echo chcp 65001 ^>nul >> run.bat
echo python gbs.py %%1 >> run.bat
echo pause >> run.bat

:: Создаем тестовый скрипт
echo print "Hello from GBS!" > examples\test.gbs
echo set name = "GBS User" >> examples\test.gbs
echo print "Welcome, " >> examples\test.gbs
echo print name >> examples\test.gbs

echo.
echo ====================================
echo GBS successfully installed!
echo ====================================
echo.
echo Commands:
echo   gbs.bat script.gbs  - run script
echo   python gbs.py --find - find all .gbs files
echo   python gbs.py --create NAME - create new script
echo.
echo Examples in 'examples\' folder
echo.
pause
