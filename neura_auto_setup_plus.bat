@echo off
setlocal ENABLEDELAYEDEXPANSION
title Neura Companion — Auto Setup, Push, and Install Preview

REM === CONFIG (edit as needed) ===
set OWNER=Vantiger1
set REPO=Neura-Companion-ver1.0.0-56162d14
set BRANCH=neura-sponsor-system
set ZIP=neura-sponsor-system.zip
set PAGES_DIR=docs
set PREVIEW_HTML=neura_preview.html

echo.
echo === Neura Companion — Setup + Install Preview ===
echo Repo: %OWNER%/%REPO%   Branch: %BRANCH%
echo.

where git >nul 2>&1 || (echo ERROR: git not found. && goto :fail)
if not exist "%ZIP%" (echo ERROR: ZIP not found: %ZIP% && goto :fail)
if not exist "%PREVIEW_HTML%" (echo ERROR: Preview HTML not found: %PREVIEW_HTML% && goto :fail)

if not exist "%REPO%" (
  git clone https://github.com/%OWNER%/%REPO%.git || goto :fail
)

pushd "%REPO%"
git checkout -B %BRANCH% || goto :fail

echo Unzipping package...
tar -xf "..\%ZIP%" -C . 2>nul || powershell -Command "Expand-Archive -LiteralPath '..\%ZIP%' -DestinationPath '.' -Force" || goto :fail_popd

echo Installing Neura preview HTML into /docs/ ...
if not exist "%PAGES_DIR%" mkdir "%PAGES_DIR%"
copy /Y "..\%PREVIEW_HTML%" "%PAGES_DIR%\neura_preview.html" >nul || goto :fail_popd

git add .
git commit -m "feat: add Neura sponsor system + VR + voice + analytics + GUI + bespoke render" || echo (no changes to commit)
git push -u origin %BRANCH% || goto :fail_popd

where gh >nul 2>&1 && (
  echo Setting GitHub Pages source to %BRANCH% / %PAGES_DIR% ...
  gh api -X PUT repos/%OWNER%/%REPO%/pages --silent ^
    -f source[branch]=%BRANCH% -f source[path]=/%PAGES_DIR% ^
    || echo NOTE: Could not set Pages automatically. Set it manually in Settings.
) || echo NOTE: gh not found, set Pages manually if needed.

echo Done! Visit your Pages URL once deployed:
echo   https://%OWNER%.github.io/%REPO%/neura_preview.html
popd
exit /b 0

:fail_popd
popd
:fail
echo Failed. Fix the message above and re-run.
exit /b 1
