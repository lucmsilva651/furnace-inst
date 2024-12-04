@echo off
chcp 65001 > nul

echo Removing old installs of Furnace...
rmdir /q /s %LOCALAPPDATA%\Furnace
rmdir /q /s %LOCALAPPDATA%\NirCmd
cls

echo Gathering latest release from GitHub API...
for /f "tokens=*" %%i in ('powershell -Command "Invoke-RestMethod -Uri 'https://api.github.com/repos/tildearrow/furnace/releases/latest' | ForEach-Object { $_.assets | Where-Object { $_.name -match 'furnace-[^-]+-win64\.zip' } | Select-Object -ExpandProperty browser_download_url }"') do (
    set downloadUrl=%%i
)

if not defined downloadUrl (
    echo Error: Unable to find download URL.
    exit /b 1
)

echo Download URL: %downloadUrl%

echo Downloading from GitHub...
curl -L "%downloadUrl%" -o "%LOCALAPPDATA%\Furnace.zip"
if errorlevel 1 (
    echo Error: Failed to download the file.
    exit /b 1
)

echo Extracting from ZIP...
powershell -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('%LOCALAPPDATA%\Furnace.zip', '%LOCALAPPDATA%\Furnace'); }"
if errorlevel 1 (
    echo Error: Failed to extract the ZIP file.
    exit /b 1
)

echo Downloading NirCmd to do shortcuts...
powershell -nologo -noprofile -command "curl https://www.nirsoft.net/utils/nircmd-x64.zip -o %LOCALAPPDATA%\NirCmd.zip"
powershell -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('%LOCALAPPDATA%\NirCmd.zip', '%LOCALAPPDATA%\NirCmd'); }"

echo Doing shortcuts...
%LOCALAPPDATA%\NirCmd\nircmd.exe shortcut "%LOCALAPPDATA%\Furnace\furnace.exe" "~$folder.programs$" "Furnace"
%LOCALAPPDATA%\NirCmd\nircmd.exe shortcut "%LOCALAPPDATA%\Furnace\furnace.exe" "~$folder.desktop$" "Furnace"

echo Removing temp file...
del /f "%LOCALAPPDATA%\NirCmd.zip"
del /f "%LOCALAPPDATA%\Furnace.zip"
rmdir /q /s %LOCALAPPDATA%\NirCmd

echo Starting Furnace...
start %LOCALAPPDATA%\Furnace\furnace.exe
exit
