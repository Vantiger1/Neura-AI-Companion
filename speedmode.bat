@echo off
REM ───────────────────────────────────────────────────────────────
REM Neura Companion Speed Mode: auto-builds, zips & deploys daily
REM ───────────────────────────────────────────────────────────────

REM Set base paths
set REPO_ROOT=%~dp0..
set BUILD_DIR=%REPO_ROOT%\build
set INSTALLERS_DIR=%REPO_ROOT%\installers
set RELEASE_DIR=%REPO_ROOT%\release
set SRC_FLUTTER=%REPO_ROOT%\src\flutter
set SRC_FASTAPI=%REPO_ROOT%\src\fastapi-web
set SRC_ELECTRON=%REPO_ROOT%\src\electron
set TOOLS_DIR=%REPO_ROOT%\tools

REM 1. Clean previous builds
echo [1/7] Cleaning old builds...
if exist "%BUILD_DIR%" rd /s /q "%BUILD_DIR%"
mkdir "%BUILD_DIR%"

REM 2. Flutter build (Android, Windows, macOS, Linux)
echo [2/7] Building Flutter modules...
pushd "%SRC_FLUTTER%"
flutter clean
flutter pub get
flutter build apk --release --target-platform android-arm64 --build-dir "%BUILD_DIR%\flutter\android"
flutter build windows --release --build-dir "%BUILD_DIR%\flutter\windows"
flutter build macos --release --build-dir "%BUILD_DIR%\flutter\macos"
flutter build linux --release --build-dir "%BUILD_DIR%\flutter\linux"
popd

REM 3. Python web build
echo [3/7] Packaging FastAPI web module...
pushd "%SRC_FASTAPI%"
pip install -r requirements.txt
pyinstaller --onefile main.py --distpath "%BUILD_DIR%\fastapi"
popd

REM 4. Electron wrapper build
echo [4/7] Building Electron desktop wrapper...
pushd "%SRC_ELECTRON%"
npm install
npm run build
xcopy /E /I "%SRC_ELECTRON%\dist" "%BUILD_DIR%\electron"
popd

REM 5. Assemble installers
echo [5/7] Creating installers...
call "%TOOLS_DIR%\build-installers.bat"

REM 6. Zip everything
echo [6/7] Zipping final bundle...
if not exist "%RELEASE_DIR%" mkdir "%RELEASE_DIR%"
set ZIP_NAME=Neura-Companion-%date:~10,4%%date:~4,2%%date:~7,2%.zip
7z a "%RELEASE_DIR%\%ZIP_NAME%" "%BUILD_DIR%\*" "%INSTALLERS_DIR%\*" "%REPO_ROOT%\README.md" "%REPO_ROOT%\CHANGELOG.md"

REM 7. Git push & deploy
echo [7/7] Pushing to GitHub and deploying Firebase...
pushd "%REPO_ROOT%"
git add .
git commit -m "Auto-build: %date% %time%"
git push origin main
firebase deploy --only hosting
popd

echo ================================
echo Speed Mode run complete!
echo Release: %RELEASE_DIR%\%ZIP_NAME%
pause
