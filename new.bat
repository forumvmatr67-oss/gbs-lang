@echo off
title Create GBS Script

if "%1"=="" (
    echo Usage: new script_name
    echo.
    echo Creates: script_name.gbs
    exit /b 1
)

set "script_name=%1"
if not "%script_name%"==".gbs" set "script_name=%script_name%.gbs"

(
echo # %script_name%
echo # Created by GBS Language
echo.
echo print "=== %script_name% ==="
echo print "Hello from GBS!"
echo print "================="
echo.
echo set name = "User"
echo set age = 25
echo.
echo print "Name: "
echo print name
echo print "Age: "
echo print age
echo.
echo print "Enter something:"
echo io.read()
echo print "You entered: "
echo print last_input
echo.
echo set x = 10
echo set y = 20
echo.
echo if x ^< y
echo     print "x is less than y"
echo endif
echo.
echo print "Done!"
) > "%script_name%"

echo.
echo [OK] Created: %script_name%
echo.
echo To run: gbs %script_name%
pause
