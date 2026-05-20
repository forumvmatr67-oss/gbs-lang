@echo off
setlocal enabledelayedexpansion

if "%1"=="" (
    echo Usage: gbs script.gbs
    exit /b 1
)

if not exist "%1" (
    echo File not found: %1
    exit /b 1
)

echo.
echo === Running %1 ===
echo.

for /f "usebackq delims=" %%a in ("%1") do (
    set "line=%%a"
    
    REM print command
    echo !line! | findstr /b "print" >nul
    if !errorlevel! equ 0 (
        set "msg=!line:~6!"
        echo !msg!
        goto :next
    )
    
    REM set command
    echo !line! | findstr /b "set" >nul
    if !errorlevel! equ 0 (
        echo [OK] !line!
        goto :next
    )
    
    REM io.read
    echo !line! | findstr "io.read" >nul
    if !errorlevel! equ 0 (
        set /p "input=Enter: "
        echo You entered: !input!
        goto :next
    )
    
    REM if command
    echo !line! | findstr /b "if" >nul
    if !errorlevel! equ 0 (
        echo [IF] !line!
        goto :next
    )
    
    REM endif
    echo !line! | findstr "endif" >nul
    if !errorlevel! equ 0 (
        goto :next
    )
    
    REM for loop
    echo !line! | findstr /b "for" >nul
    if !errorlevel! equ 0 (
        echo [FOR] !line!
        goto :next
    )
    
    REM end
    echo !line! | findstr "end" >nul
    if !errorlevel! equ 0 (
        goto :next
    )
    
    REM ignore comments and empty lines
    echo !line! | findstr /b "#" >nul
    if !errorlevel! equ 0 goto :next
    
    if not "!line!"=="" (
        echo Unknown: !line!
    )
    
    :next
)

echo.
echo === Done ===
