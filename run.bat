@echo off
color 0A
title GBS Launcher

if "%1"=="" (
    echo Usage: run.bat script.gbs
    echo.
    echo Available scripts:
    echo.
    dir /b examples\*.gbs 2>nul
    echo.
    echo Example: run.bat examples\hello.gbs
    exit /b 1
)

if not exist "%1" (
    echo Error: File %1 not found
    exit /b 1
)

call src\gbs.bat %1
