@echo off
REM --------------------------------------------------
REM scaffold_neuracompanion.bat
REM Automatically builds and packages the full Neura Companion source
REM --------------------------------------------------

setlocal

set PROJECT=NeuraCompanion_Full_Source

REM 1. Clean up any existing folder
if exist "%PROJECT%" (
    echo Removing existing "%PROJECT%"...
    rmdir /s /q "%PROJECT%"
)

REM 2. Create project directory
echo Creating project directory "%PROJECT%"...
mkdir "%PROJECT%"

REM 3. Scaffold Flutter project
echo Running flutter create...
pushd "%PROJECT%"
flutter create . || (
    echo ERROR: 'flutter create' failed. Make sure Flutter is in your PATH.
    pause
    exit /b 1
)
popd

REM 4. Copy all template files and folders
echo Copying all template files and directories...
xcopy "%~dp0*" "%PROJECT%\" /E /I /Y

REM 5. Remove any unwanted directories if necessary (e.g., not copying itself)
echo Removing scaffolding artifacts...
if exist "%PROJECT%\scaffold_neuracompanion.bat" (
    del "%PROJECT%\scaffold_neuracompanion.bat"
)

REM 6. Package into ZIP
echo Packaging project into "%PROJECT%.zip"...
powershell -NoProfile -Command "Compress-Archive -Path '%PROJECT%' -DestinationPath '%PROJECT%.zip' -Force"

if exist "%PROJECT%.zip" (
    echo.
    echo Success!  "%PROJECT%.zip" has been created.
) else (
    echo.
    echo ERROR: ZIP creation failed.
)

pause
