@echo off
setlocal enabledelayedexpansion

if "%1"=="" (
    echo Usage: gbs script.gbs
    exit /b 1
)

if not exist "%1" (
    echo Error: File '%1' not found!
    exit /b 1
)

echo.
echo === Running %1 ===
echo.

:: Сброс переменных
for /f "delims==" %%a in ('set var_ 2^>nul') do set %%a=
set line_num=0

:: Чтение и выполнение файла
for /f "usebackq delims=" %%a in ("%1") do (
    set /a line_num+=1
    set "line=%%a"
    call :execute_line
)

echo.
echo === Done ===
exit /b 0

:execute_line
set "cmd=!line!"
if "!cmd!"=="" exit /b
if "!cmd:~0,1!"=="#" exit /b

:: print command
echo !cmd! | findstr /b /c:"print " >nul
if !errorlevel! equ 0 (
    set "msg=!cmd:~6!"
    if "!msg:~0,1!"=="""" if "!msg:~-1!"=="""" (
        set "msg=!msg:~1,-1!"
    )
    echo !msg!
    exit /b
)

:: set command
echo !cmd! | findstr /b /c:"set " >nul
if !errorlevel! equ 0 (
    set "rest=!cmd:~4!"
    for /f "tokens=1,* delims==" %%x in ("!rest!") do (
        set "var_name=%%x"
        set "var_name=!var_name: =!"
        set "var_value=%%y"
        set "var_value=!var_value: =!"
        set "var_value=!var_value:"=!"
        set "var_!var_name!=!var_value!"
    )
    exit /b
)

:: io.read()
echo !cmd! | findstr /c:"io.read()" >nul
if !errorlevel! equ 0 (
    set /p "user_input="
    set "var_last_input=!user_input!"
    exit /b
)

:: print variable
echo !cmd! | findstr /b /c:"print $" >nul
if !errorlevel! equ 0 (
    set "varname=!cmd:~7!"
    set "varname=!varname: =!"
    call set "val=%%var_!varname!%%"
    echo !val!
    exit /b
)

:: variable assignment without set (x = 5)
echo !cmd! | findstr "=" >nul
if !errorlevel! equ 0 (
    for /f "tokens=1,* delims==" %%x in ("!cmd!") do (
        set "var_name=%%x"
        set "var_name=!var_name: =!"
        set "var_value=%%y"
        set "var_value=!var_value: =!"
        set "var_value=!var_value:"=!"
        set "var_!var_name!=!var_value!"
    )
    exit /b
)

:: if command
echo !cmd! | findstr /b /c:"if " >nul
if !errorlevel! equ 0 (
    set "condition=!cmd:~3!"
    call :check_condition
    if !cond_result! equ 0 (
        call :skip_to_endif
    )
    exit /b
)

:: endif
if "!cmd!"=="endif" (
    exit /b
)

:: for loop
echo !cmd! | findstr /b /c:"for " >nul
if !errorlevel! equ 0 (
    call :parse_for
    exit /b
)

:: end
if "!cmd!"=="end" (
    exit /b
)

echo [Line !line_num!] Unknown: !cmd!
exit /b

:check_condition
set cond_result=0
:: simple condition: x < y
for /f "tokens=1,2,3" %%a in ("!condition!") do (
    set "left=%%a"
    set "op=%%b"
    set "right=%%c"
    
    call set "left_val=%%var_!left!%%"
    if "!left_val!"=="" set "left_val=!left!"
    
    call set "right_val=%%var_!right!%%"
    if "!right_val!"=="" set "right_val=!right!"
    
    if "!op!"=="<" (
        if !left_val! lss !right_val! set cond_result=1
    )
    if "!op!"==">" (
        if !left_val! gtr !right_val! set cond_result=1
    )
    if "!op!"=="=" (
        if !left_val! equ !right_val! set cond_result=1
    )
)
exit /b

:skip_to_endif
set depth=1
:skip_loop
set /a line_num+=1
if !line_num! geq %line_count% exit /b
set "skip_line=!lines[%line_num%]!"
if "!skip_line!"=="endif" (
    set /a depth-=1
    if !depth! equ 0 exit /b
)
if "!skip_line:~0,3!"=="if " set /a depth+=1
goto skip_loop

:parse_for
:: for i = 1 to 10
for /f "tokens=2,4,6" %%a in ("!cmd!") do (
    set "for_var=%%a"
    set "for_start=%%b"
    set "for_end=%%c"
)
call set "start_val=%%var_!for_start!%%"
if "!start_val!"=="" set "start_val=!for_start!"
call set "end_val=%%var_!for_end!%%"
if "!end_val!"=="" set "end_val=!for_end!"

for /l %%i in (!start_val!,1,!end_val!) do (
    set "var_!for_var!=%%i"
    call :execute_for_body
)
exit /b

:execute_for_body
set "saved_pc=!line_num!"
set /a line_num+=1
:body_loop
if !line_num! geq %line_count% exit /b
set "body_line=!lines[%line_num%]!"
if "!body_line!"=="end" (
    set "line_num=!saved_pc!"
    exit /b
)
set "cmd=!body_line!"
call :execute_line
set /a line_num+=1
goto body_loop
