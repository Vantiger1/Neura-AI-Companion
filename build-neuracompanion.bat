@echo off
setlocal

REM ──────────────────────────────────────────────────────────────────────────
REM One-Click Release Build Script for Neura Companion (Windows BAT)
REM Place this script in your project root (next to gradlew.bat and settings.gradle)
REM ──────────────────────────────────────────────────────────────────────────

REM 1) Switch to script directory
cd /d "%~dp0"

echo.
echo [INFO] Running release build from %CD%

REM 2) Ensure Gradle wrapper exists
if not exist gradlew.bat (
    echo [ERROR] gradlew.bat not found. Please generate the Gradle wrapper by running 'gradle wrapper' on a machine with Gradle installed and commit it.
    pause
    exit /b 1
)

REM 3) Configure JDK
set "JAVA_HOME=C:\Neura"
set "PATH=%JAVA_HOME%\bin;%PATH%"

REM 4) Write/update local.properties with Android SDK path
>local.properties echo sdk.dir=C\:\\Users\\KD\\AppData\\Local\\Android\\Sdk

REM 5) Clean and assemble release APK
echo.
echo [INFO] Cleaning and building release APK...
call gradlew.bat clean assembleRelease
if errorlevel 1 (
    echo.
    echo [ERROR] Build failed! See output above.
    pause
    exit /b 1
)

REM 6) Copy the APK to release folder
if not exist release mkdir release
copy /Y app\build\outputs\apk\release\app-release.apk release\app-release.apk >nul

echo.
echo [OK] Build succeeded! Release APK located at:
echo    %~dp0release\app-release.apk
pause
endlocal
