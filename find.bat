@echo off
title GBS Finder

echo.
echo ====================================
echo Searching for .gbs files...
echo ====================================
echo.

set count=0

:: Поиск в текущей папке
for %%f in (*.gbs) do (
    echo [SCRIPT] %%f
    set /a count+=1
)

:: Поиск в папке examples
if exist "examples\*.gbs" (
    echo.
    echo [Examples folder]
    for %%f in (examples\*.gbs) do (
        echo   %%f
        set /a count+=1
    )
)

:: Поиск в папке scripts
if exist "scripts\*.gbs" (
    echo.
    echo [Scripts folder]
    for %%f in (scripts\*.gbs) do (
        echo   %%f
        set /a count+=1
    )
)

:: Рекурсивный поиск
echo.
echo [All .gbs files in subfolders]
for /r %%f in (*.gbs) do (
    echo   %%f
    set /a count+=1
)

echo.
echo ====================================
echo Total found: %count% file(s)
echo ====================================
pause
