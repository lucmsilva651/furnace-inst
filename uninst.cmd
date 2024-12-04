@echo off
chcp 65001 > nul

echo Uninstalling Furnace and temp files...
rmdir /q /s %LOCALAPPDATA%\Furnace
rmdir /q /s %LOCALAPPDATA%\NirCmd

echo Removing shortcuts...
del /f "%APPDATA%\Roaming\Microsoft\Windows\Start Menu\Programs\Furnace.lnk"
del /f "%USERPROFILE%\Desktop\Furnace.lnk"

pause