@echo off
title GBS Runner

if "%1"=="" (
    echo Usage: run script.gbs
    echo.
    echo Available scripts:
    echo.
    dir *.gbs /b 2>nul
    if exist "examples\*.gbs" (
        echo Examples:
        dir examples\*.gbs /b
    )
    if exist "scripts\*.gbs" (
        echo Scripts:
        dir scripts\*.gbs /b
    )
    pause
    exit /b 1
)

if not exist "%1" (
    echo Error: File '%1' not found!
    pause
    exit /b 1
)

call gbs.bat "%1"
pause
