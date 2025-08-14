param(
  [string]$OutDir = "$PSScriptRoot/../../build/ci_artifacts",
  [switch]$NoBuild,
  [ValidateSet('apk','appbundle','windows','web')]
  [string[]]$BuildTargets = @('apk'),
  [switch]$Strict,
  [switch]$SkipTests,
  [switch]$SkipFix,
  [switch]$SkipFormat
)

$ErrorActionPreference = 'Stop'
$PSStyle.OutputRendering = 'Host'

function Write-Step([string]$msg) { Write-Host "==> $msg" -ForegroundColor Cyan }
function TimeIt([scriptblock]$Block) {
  $sw = [System.Diagnostics.Stopwatch]::StartNew()
  & $Block
  $sw.Stop()
  Write-Host ("   (took {0:0.0}s)" -f ($sw.Elapsed.TotalSeconds)) -ForegroundColor DarkGray
}

$root = (Resolve-Path "$PSScriptRoot/../..").Path
Push-Location $root
try {
  New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
  $log = Join-Path $OutDir "run_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
  Start-Transcript -Path $log -Force | Out-Null

  TimeIt { Write-Step "Snapshotting environment (Flutter/Dart/doctor)" }
  TimeIt { flutter --version | Tee-Object -FilePath "$OutDir/flutter_version.txt" }
  TimeIt { dart --version    | Tee-Object -FilePath "$OutDir/dart_version.txt" }
  TimeIt { flutter doctor -v | Tee-Object -FilePath "$OutDir/flutter_doctor.txt" }

  TimeIt { Write-Step "Cleaning project" ; flutter clean }
  TimeIt { Write-Step "Fetching packages" ; flutter pub get }
  TimeIt { Write-Step "Pub upgrade (safe resolution)" ; flutter pub upgrade | Tee-Object -FilePath "$OutDir/pub_upgrade.txt" }
  TimeIt { Write-Step "Pub outdated (report only)" ; flutter pub outdated  | Tee-Object -FilePath "$OutDir/pub_outdated.txt" }

  if (-not $SkipFix) {
    TimeIt { Write-Step "Applying automated Dart fixes" ; dart fix --apply | Tee-Object -FilePath "$OutDir/dart_fix.txt" }
  } else { Write-Host "Skipping dart fix (--SkipFix)" -ForegroundColor DarkGray }

  if (-not $SkipFormat) {
    TimeIt { Write-Step "Formatting Dart code" ; dart format . | Tee-Object -FilePath "$OutDir/dart_format.txt" }
  } else { Write-Host "Skipping dart format (--SkipFormat)" -ForegroundColor DarkGray }

  $analyzeArgs = @()
  if ($Strict) { $analyzeArgs = @('--fatal-warnings','--fatal-infos') } else { $analyzeArgs = @('--no-fatal-warnings','--fatal-infos') }
  TimeIt { Write-Step "Running analyzer" ; flutter analyze @analyzeArgs | Tee-Object -FilePath "$OutDir/analyze.txt" }

  if ((Test-Path 'test') -and (-not $SkipTests)) {
    TimeIt { Write-Step "Running tests" ; flutter test --reporter expanded | Tee-Object -FilePath "$OutDir/tests.txt" }
  } else {
    Write-Host "Skipping tests (no /test or --SkipTests)" -ForegroundColor DarkGray
  }

  if (-not $NoBuild) {
    foreach ($t in $BuildTargets) {
      switch ($t) {
        'apk' {
          TimeIt {
            Write-Step "Building release APK"
            flutter build apk --release | Tee-Object -FilePath "$OutDir/build_apk.txt"
            $apk = "build/app/outputs/flutter-apk/app-release.apk"
            if (Test-Path $apk) { Copy-Item $apk (Join-Path $OutDir 'neura_companion-release.apk') -Force }
          }
        }
        'appbundle' {
          TimeIt {
            Write-Step "Building Android App Bundle (.aab)"
            flutter build appbundle --release | Tee-Object -FilePath "$OutDir/build_aab.txt"
            $aab = "build/app/outputs/bundle/release/app-release.aab"
            if (Test-Path $aab) { Copy-Item $aab (Join-Path $OutDir 'neura_companion-release.aab') -Force }
          }
        }
        'windows' {
          TimeIt {
            Write-Step "Building Windows desktop"
            flutter build windows --release | Tee-Object -FilePath "$OutDir/build_windows.txt"
            if (Test-Path "build/windows/x64/runner/Release") {
              Copy-Item "build/windows/x64/runner/Release" (Join-Path $OutDir 'windows_release') -Recurse -Force
            }
          }
        }
        'web' {
          TimeIt {
            Write-Step "Building Web"
            flutter build web --release | Tee-Object -FilePath "$OutDir/build_web.txt"
            if (Test-Path "build/web") {
              Copy-Item "build/web" (Join-Path $OutDir 'web_release') -Recurse -Force
            }
          }
        }
      }
    }
  } else {
    Write-Host "Skipping builds (--NoBuild)" -ForegroundColor DarkGray
  }

  TimeIt { Write-Step "Creating slim project zip (excludes .git, build, .dart_tool, .idea, .gradle, node_modules, coverage, ios/Pods)" }
  $zipPath = Join-Path $OutDir 'neura_companion_project.zip'
  if (Test-Path $zipPath) { Remove-Item $zipPath -Force }

  Add-Type -AssemblyName 'System.IO.Compression.FileSystem'
  $tempStage = Join-Path $OutDir 'stage_zip'
  if (Test-Path $tempStage) { Remove-Item $tempStage -Recurse -Force }
  New-Item -ItemType Directory -Force -Path $tempStage | Out-Null

  $exclude = @('.git','build','.dart_tool','.idea','.gradle','node_modules','build_ci','coverage','ios/Pods')
  $rootPath = (Resolve-Path ".").Path
  Get-ChildItem -LiteralPath $rootPath -Recurse -File |
    Where-Object {
      $rel = $_.FullName.Substring($rootPath.Length).TrimStart('\','/')
      -not ($exclude | ForEach-Object { $rel -like ("$_*") })
    } |
    ForEach-Object {
      $dest = Join-Path $tempStage ($_.FullName.Substring($rootPath.Length).TrimStart('\','/'))
      New-Item -ItemType Directory -Force -Path (Split-Path $dest) | Out-Null
      Copy-Item $_.FullName $dest -Force
    }

  [System.IO.Compression.ZipFile]::CreateFromDirectory($tempStage, $zipPath)
  Remove-Item $tempStage -Recurse -Force

  Write-Host "==> Done."
  Write-Host "Artifacts:"
  if (Test-Path (Join-Path $OutDir 'neura_companion-release.apk')) { Write-Host " • $OutDir/neura_companion-release.apk" -ForegroundColor Green }
  if (Test-Path (Join-Path $OutDir 'neura_companion-release.aab')) { Write-Host " • $OutDir/neura_companion-release.aab" -ForegroundColor Green }
  if (Test-Path (Join-Path $OutDir 'windows_release'))           { Write-Host " • $OutDir/windows_release/" -ForegroundColor Green }
  if (Test-Path (Join-Path $OutDir 'web_release'))               { Write-Host " • $OutDir/web_release/" -ForegroundColor Green }
  Write-Host " • $zipPath" -ForegroundColor Green
  Write-Host " • Full log: $log" -ForegroundColor DarkGray
}
catch {
  Write-Host "❌ FAILED: $($_.Exception.Message)" -ForegroundColor Red
  Write-Host "See transcript: $log" -ForegroundColor Yellow
  throw
}
finally {
  Stop-Transcript | Out-Null
  Pop-Location
}
