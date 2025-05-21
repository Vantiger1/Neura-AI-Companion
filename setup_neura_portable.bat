@echo off
REM === Neura Companion Portable Build Script (Using C:\Neura Paths) ===

echo Setting local JDK and Flutter paths...
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

echo [4] Building APK...
flutter build apk --debug >> portable_log.txt

echo === Build Complete! Check build\app\outputs\flutter-apk\app-debug.apk ===
pause
