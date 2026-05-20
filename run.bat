@echo off
chcp 65001 >nul
title GBS Runner

if "%1"=="" (
    echo Usage: run.bat script.gbs
    echo.
    echo Available scripts:
    dir *.gbs /b 2>nul
    if exist "examples\*.gbs" (
        echo.
        echo Examples:
        dir examples\*.gbs /b
    )
    pause
    exit /b 1
)

if not exist "%1" (
    echo Error: File '%1' not found!
    pause
    exit /b 1
)

echo.
echo Running %1...
echo ====================================
python gbs.py "%1"
echo ====================================
pause
