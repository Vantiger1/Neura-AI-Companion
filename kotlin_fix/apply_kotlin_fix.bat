@echo off
REM Batch script to patch Gradle files for Kotlin Android plugin support.
REM Run this from your project root directory.

REM 1. Patch settings.gradle
if not exist settings.gradle (
    echo pluginManagement {>>settings.gradle
    echo     repositories {>>settings.gradle
    echo         gradlePluginPortal()>>settings.gradle
    echo         google()>>settings.gradle
    echo         mavenCentral()>>settings.gradle
    echo     }>>settings.gradle
    echo }>>settings.gradle
    echo Created settings.gradle with pluginManagement block.
) else (
    findstr /C:"pluginManagement" settings.gradle >nul || (
        echo pluginManagement block missing; appending...
        echo.>>settings.gradle
        echo pluginManagement {>>settings.gradle
        echo     repositories {>>settings.gradle
        echo         gradlePluginPortal()>>settings.gradle
        echo         google()>>settings.gradle
        echo         mavenCentral()>>settings.gradle
        echo     }>>settings.gradle
        echo }>>settings.gradle
    )
)

REM 2. Patch root build.gradle
setlocal enabledelayedexpansion
set "KOTLIN_VERSION=1.9.10"
if exist build.gradle (
    findstr /C:"ext.kotlin_version" build.gradle >nul || (
        echo >> build.gradle
        echo buildscript {>> build.gradle
        echo     ext.kotlin_version = "!KOTLIN_VERSION!">> build.gradle
        echo     repositories {>> build.gradle
        echo         google()>> build.gradle
        echo         mavenCentral()>> build.gradle
        echo     }>> build.gradle
        echo     dependencies {>> build.gradle
        echo         classpath "com.android.tools.build:gradle:8.1.0">> build.gradle
        echo         classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:!KOTLIN_VERSION!">> build.gradle
        echo     }>> build.gradle
        echo }>> build.gradle
        echo Patched root build.gradle.
    ) || echo Root build.gradle already patched.
) else (
    echo ERROR: root build.gradle not found!
    exit /b 1
)

REM 3. Patch app/build.gradle
if exist app\build.gradle (
    pushd app
    findstr /C:"apply plugin: 'kotlin-android'" build.gradle >nul || (
        echo apply plugin: 'kotlin-android'>> build.gradle
        echo Added kotlin-android plugin to app/build.gradle.
    ) || echo app/build.gradle already has kotlin-android plugin.
    findstr /C:"kotlin-stdlib" build.gradle >nul || (
        echo dependencies {>> build.gradle
        echo     implementation "org.jetbrains.kotlin:kotlin-stdlib:!KOTLIN_VERSION!">> build.gradle
        echo }>> build.gradle
        echo Added kotlin-stdlib dependency.
    ) || echo app/build.gradle already has kotlin-stdlib.
    popd
) else (
    echo ERROR: app/build.gradle not found!
    exit /b 1
)
endlocal

echo.
echo Patch complete. Please sync your project.
