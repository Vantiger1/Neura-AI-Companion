@echo off
setlocal enabledelayedexpansion

REM Source and destination folders
set "SRC=Z:\NEURA-COMPANION"
set "DEST=Z:\ALLCODE"

REM Create destination folder if it doesn't exist
if not exist "%DEST%" mkdir "%DEST%"

REM Go to source directory
pushd "%SRC%"

REM For each file in source (recursively)
for /r %%F in (*) do (
    set "FILENAME=%%~nxF"
    set "DESTFILE=%DEST%\!FILENAME!"

    REM If the file doesn't exist in destination, copy it
    if not exist "!DESTFILE!" (
        copy "%%F" "!DESTFILE!" >nul
    ) else (
        REM If it exists, compare dates and keep the newest
        for %%A in ("%%F") do set "SRC_DATE=%%~tA"
        for %%B in ("!DESTFILE!") do set "DEST_DATE=%%~tB"
        
        REM Compare the file dates (YYYY-MM-DD HH:MM)
        if "!SRC_DATE!" GTR "!DEST_DATE!" (
            copy /Y "%%F" "!DESTFILE!" >nul
        )
    )
)
popd

echo All files have been gathered into %DEST% with the newest versions kept.
pause