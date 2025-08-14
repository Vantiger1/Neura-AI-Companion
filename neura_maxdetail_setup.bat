@echo off
setlocal ENABLEDELAYEDEXPANSION
set OWNER=Vantiger1
set REPO=Neura-Companion-ver1.0.0-56162d14
set BRANCH=neura-sponsor-system
set ZIP=neura-sponsor-system-max.zip
set PAGES_DIR=docs
where git >nul 2>&1 || (echo ERROR: git not found. Install Git first.& exit /b 1)
if not exist "%ZIP%" (echo ERROR: %ZIP% missing in current folder.& exit /b 1)
if not exist "%REPO%" git clone https://github.com/%OWNER%/%REPO%.git
pushd "%REPO%"
git checkout -B %BRANCH%
tar -xf "..\%ZIP%" -C . 2>nul || powershell -Command "Expand-Archive -LiteralPath '..\%ZIP%' -DestinationPath '.' -Force"
git add .
git commit -m "feat: Neura sponsor system (max detail) bundle" || echo (no changes to commit)
git push -u origin %BRANCH%
popd
echo.
echo Deployment complete. Go to GitHub -> Settings -> Pages and set:
echo   Source: branch '%BRANCH%' folder '/%PAGES_DIR%'
echo.
pause
