@echo off
setlocal

REM ──────────────────────────────────────────────────────────────────────────
REM Build Script: One-click release APK builder for Neura Companion
REM Automatically locates project root (where settings.gradle lives)
REM ──────────────────────────────────────────────────────────────────────────

REM Determine script directory
set "SCRIPT_DIR=%~dp0"
REM Remove trailing backslash if present
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

REM Find project root by searching for settings.gradle(.kts)
set "ROOT=%SCRIPT_DIR%"
:find_root
if exist "%ROOT%\settings.gradle" goto root_found
if exist "%ROOT%\settings.gradle.kts" goto root_found
REM If at drive root, stop searching
if "%ROOT:~-2%"==":\" goto root_not_found
REM Move up one level
for %%F in ("%ROOT%") do set "ROOT=%%~dpF"
REM Remove trailing backslash
if "%ROOT:~-1%"=="\" set "ROOT=%ROOT:~0,-1%"
goto find_root

:root_found
cd /d "%ROOT%"
goto continue

:root_not_found
echo [ERROR] Could not locate settings.gradle in any parent directories.
pause
exit /b 1

:continue
echo [INFO] Project root located at %CD%

REM 1) Configure JDK and update PATH
set "JAVA_HOME=C:\Neura"
set "PATH=%JAVA_HOME%\bin;%PATH%"

REM 2) Write/update local.properties
echo sdk.dir=C\:\\Users\\KD\\AppData\\Local\\Android\\Sdk>local.properties

REM 3) Clean & build release APK
echo.
echo [INFO] Cleaning and building release APK...
call gradlew.bat clean assembleRelease
if errorlevel 1 (
    echo.
    echo [ERROR] Build failed! Review errors above.
    pause
    exit /b 1
)

REM 4) Copy APK to release folder
if not exist release mkdir release
copy /Y app\build\outputs\apk\release\app-release.apk release\app-release.apk >nul

echo.
echo [OK] Build succeeded! APK at: %~dp0release\app-release.apk
pause
endlocal
