@echo off
setlocal enabledelayedexpansion

if "%1"=="" (
    echo Usage: gpys file.gpys
    exit /b
)

if not exist "%1" (
    echo File not found!
    exit /b
)

for /f "usebackq delims=" %%a in ("%1") do (
    set "line=%%a"
    
    echo !line! | findstr /b "print" >nul
    if !errorlevel! equ 0 (
        set "msg=!line:~6!"
        set "msg=!msg:"=!"
        echo !msg!
    )
    
    echo !line! | findstr /b "set" >nul
    if !errorlevel! equ 0 (
        set "cmd=!line:~4!"
        for /f "tokens=1,* delims==" %%x in ("!cmd!") do (
            set "var=%%x"
            set "var=!var: =!"
            set "val=%%y"
            set "val=!val: =!"
            set "!var!=!val!"
        )
    )
    
    echo !line! | findstr "io.read" >nul
    if !errorlevel! equ 0 (
        set /p "input=> "
        set "last_input=!input!"
    )
    
    echo !line! | findstr /b "print $" >nul
    if !errorlevel! equ 0 (
        set "varname=!line:~7!"
        call echo %%!varname!%%
    )
)
