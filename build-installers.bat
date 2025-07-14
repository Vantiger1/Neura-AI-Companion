@echo off
REM ───────────────────────────────────────────────────────────────
REM Build all platform installers for Neura Companion
REM ───────────────────────────────────────────────────────────────

set INSTALLERS_DIR=%~dp0\..\installers
set BUILD_DIR=%~dp0\..\build
set TOOLS_DIR=%~dp0

REM 1. Windows (Inno Setup)
echo Building Windows installer...
if not exist "%INSTALLERS_DIR%\Windows" mkdir "%INSTALLERS_DIR%\Windows"
"C:\Program Files (x86)\Inno Setup 6\ISCC.exe" "%TOOLS_DIR%\NeuraInstaller.iss"

REM 2. macOS (.dmg)
echo Building macOS DMG...
if not exist "%INSTALLERS_DIR%\macOS" mkdir "%INSTALLERS_DIR%\macOS"
hdiutil create -volname "Neura Companion" -srcfolder "%BUILD_DIR%\flutter\macos\build\macos\Release\Neura Companion.app" -ov -format UDZO "%INSTALLERS_DIR%\macOS\NeuraInstaller.dmg"

REM 3. Linux (makeself)
echo Building Linux installer...
if not exist "%INSTALLERS_DIR%\Linux" mkdir "%INSTALLERS_DIR%\Linux"
"%TOOLS_DIR%\makeself.sh" "%BUILD_DIR%\flutter\linux\build\linux\release" "%INSTALLERS_DIR%\Linux\NeuraInstaller.sh" "Neura Companion Linux Installer" ./start-neura.sh

REM 4. Android APK (already built)
echo Copying Android APK...
if not exist "%INSTALLERS_DIR%\Android" mkdir "%INSTALLERS_DIR%\Android"
copy "%BUILD_DIR%\flutter\android\app-release.apk" "%INSTALLERS_DIR%\Android\Neura.apk"

echo All installers created.
