@echo off
setlocal ENABLEDELAYEDEXPANSION
title Neura Companion — Auto Setup & Push

REM === CONFIG: change these if needed ===
set OWNER=Vantiger1
set REPO=Neura-Companion-ver1.0.0-56162d14
set BRANCH=neura-sponsor-system
set ZIP=neura-sponsor-system.zip
set PAGES_DIR=docs

echo.
echo [96m=== Neura Companion — Auto Setup & Push ===[0m
echo Owner: %OWNER%   Repo: %REPO%   Branch: %BRANCH%   Pages Dir: %PAGES_DIR%
echo.

REM 1) Pre-flight checks
where git >nul 2>&1 || (echo [91mERROR: git not found. Install Git and re-run.[0m & goto :fail)
where gh  >nul 2>&1 || (echo [93mWARN: GitHub CLI (gh) not found. Some steps (Pages) may require manual action.[0m)

REM 2) Auth check for gh (optional but recommended)
if exist "%USERPROFILE%\.config\gh\hosts.yml" (
  echo gh CLI appears to be configured.
) else (
  echo [93mNOTE: If you want this script to set GitHub Pages automatically, run: gh auth login[0m
)

REM 3) Clone or pull repo
if not exist "%REPO%" (
  echo Cloning repo...
  git clone https://github.com/%OWNER%/%REPO%.git || goto :fail
) else (
  echo Repo folder already exists. Pulling latest...
  pushd "%REPO%"
  git pull || (popd & goto :fail)
  popd
)

REM 4) Create working branch
pushd "%REPO%"
git checkout -B %BRANCH% || goto :fail

REM 5) Ensure ZIP is available
if not exist "..\%ZIP%" (
  echo [93mZIP not found at ..\%ZIP%. Place the ZIP next to this BAT or set ZIP= to a full path.[0m
  echo Aborting.
  goto :fail_popd
)

REM 6) Unzip package into repo root
echo Unzipping package...
tar -xf "..\%ZIP%" -C . 2>nul || powershell -Command "Expand-Archive -LiteralPath '..\%ZIP%' -DestinationPath '.' -Force" || goto :fail_popd

REM 7) Commit & push
git add .
git commit -m "feat: Neura sponsor system + VR + voice + analytics + GUI" || echo (no changes to commit)
git push -u origin %BRANCH% || goto :fail_popd

REM 8) Enable GitHub Pages for this branch (requires gh)
where gh >nul 2>&1 && (
  echo Configuring GitHub Pages source to %BRANCH% / %PAGES_DIR% ...
  gh api -X PUT repos/%OWNER%/%REPO%/pages --silent ^
    -f source[branch]=%BRANCH% -f source[path]=/%PAGES_DIR% ^
    || echo [93mNOTE: Could not set Pages automatically. Set it manually in GitHub Settings.[0m
) || echo [93mSkipping Pages config (gh not found).[0m

echo.
echo [92mAll done![0m Open your GitHub Pages URL once deploy finishes:
echo   https://%OWNER%.github.io/%REPO%/
echo.
echo Testing guide: TESTING_GUIDE.md
echo.

popd
exit /b 0

:fail_popd
popd
:fail
echo [91mSetup failed. See messages above.[0m
exit /b 1
