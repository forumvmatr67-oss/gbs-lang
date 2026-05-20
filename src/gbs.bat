@echo off
setlocal enabledelayedexpansion

title GBS Interpreter
color 0A

if "%1"=="" (
    echo Usage: gbs.bat file.gbs
    exit /b 1
)

if not exist "%1" (
    echo Error: File %1 not found
    exit /b 1
)

set "IF_ACTIVE=0"
echo [GBS] Running %1...
echo.

for /f "usebackq delims=" %%a in ("%1") do (
    set "line=%%a"
    
    if "!line:~0,1!" neq "#" (
        
        if "!line:~0,5!"=="print" (
            set "text=!line:~6!"
            set "text=!text:"=!"
            echo !text!
        )
        
        if "!line!"=="io.read()" (
            set /p GBS_INPUT="> "
        )
        
        if "!line:~0,3!"=="set" (
            set "cmd=!line:~4!"
            for /f "tokens=1,* delims==" %%b in ("!cmd!") do (
                set "var=%%b"
                set "var=!var: =!"
                set "val=%%c"
                set "val=!val: =!"
                set "!var!=!val!"
            )
        )
        
        if "!line:~0,2!"=="if" (
            set "IF_ACTIVE=1"
        )
        
        if "!line!"=="else" (
            if !IF_ACTIVE!==1 (set IF_ACTIVE=0) else (set IF_ACTIVE=1)
        )
        
        if "!line!"=="end" (
            set "IF_ACTIVE=0"
        )
    )
)

echo.
echo [GBS] Execution finished
pause
