@echo off
color 0A
title GBS Installer

echo ╔══════════════════════════════════╗
echo ║     GBS Language Installer       ║
echo ╚══════════════════════════════════╝
echo.

:: Добавление в PATH
set "GBS_PATH=%CD%\src"
setx PATH "%PATH%;%GBS_PATH%" /M >nul 2>&1

:: Создание ярлыка на рабочем столе
echo Creating desktop shortcut...
powershell -Command "$WS = New-Object -ComObject WScript.Shell; $SC = $WS.CreateShortcut('%USERPROFILE%\Desktop\GBS.lnk'); $SC.TargetPath = '%CD%\run.bat'; $SC.Save()" >nul 2>&1

:: Создание папки в меню Пуск
if not exist "%APPDATA%\Microsoft\Windows\Start Menu\Programs\GBS" (
    mkdir "%APPDATA%\Microsoft\Windows\Start Menu\Programs\GBS"
    copy "run.bat" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\GBS\" >nul
    copy "README.md" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\GBS\" >nul
)

echo.
echo ✅ GBS успешно установлен!
echo.
echo 📍 Теперь вы можете использовать команду: gbs.bat script.gbs
echo 📁 Примеры находятся в папке examples/
echo 🖥️ Ярлык создан на рабочем столе
echo.
pause
