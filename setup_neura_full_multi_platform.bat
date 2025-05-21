@echo off
REM === Neura Companion Full Portable Build Script ===

cd /d C:\Neura\NeuraCompanion

echo Setting local Java and Flutter paths...
set "JAVA_HOME=C:\Neura\jdk24"
set "PATH=C:\Neura\jdk24\bin;C:\Neura\flutter\bin;%PATH%"

echo Java version:
"%JAVA_HOME%\bin\java.exe" -version

echo Flutter version:
flutter --version

echo [1] Cleaning project...
flutter clean

echo [2] Installing dependencies...
flutter pub get

echo [3] Running tests...
flutter test > portable_log.txt

echo [4] Building Android APK...
flutter build apk --debug >> portable_log.txt

echo [5] Building Web...
flutter build web >> portable_log.txt

echo [6] Building Windows executable...
flutter build windows >> portable_log.txt

echo [7] Launching Android Studio...
start "" "C:\Program Files\Android\Android Studio\bin\studio64.exe" .

echo === ALL BUILDS COMPLETE ===
echo Check portable_log.txt for output logs.
pause
