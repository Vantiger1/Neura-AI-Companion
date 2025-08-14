@echo off
setlocal ENABLEDELAYEDEXPANSION
set OWNER=Vantiger1
set REPO=Neura-Companion-ver1.0.0-56162d14
set BRANCH=neura-sponsor-system
set WF=.github\workflows\pages-deploy.yml

where git >nul 2>&1 || (echo ERROR: git not found.& exit /b 1)
if not exist "%REPO%" git clone https://github.com/%OWNER%/%REPO%.git

pushd "%REPO%"
git checkout -B %BRANCH%
if not exist ".github\workflows" mkdir ".github\workflows"
copy /Y "..\pages-deploy.yml" "%WF%" >nul || (echo ERROR: could not copy workflow.& popd & exit /b 1)

git add "%WF%"
git commit -m "ci: add GitHub Pages auto-deploy workflow" || echo (no changes)
git push -u origin %BRANCH%

echo.
echo If this is the first time using Actions for Pages, open:
echo   https://github.com/%OWNER%/%REPO%/settings/pages
echo and ensure "Build and deployment -> Source" is set to "GitHub Actions".
echo The workflow will publish on each push to %BRANCH% (docs/ changes).
echo.
popd
