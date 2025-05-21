; Neura Companion Windows Installer Script (for Inno Setup)

[Setup]
AppName=Neura Companion
AppVersion=1.0
DefaultDirName={pf}\NeuraCompanion
DefaultGroupName=Neura Companion
OutputDir=.
OutputBaseFilename=neura_companion_installer
Compression=lzma
SolidCompression=yes

[Files]
Source: "build\windows\runner\Release\*"; DestDir: "{app}"; Flags: recursesubdirs

[Icons]
Name: "{group}\Neura Companion"; Filename: "{app}\NeuraCompanion.exe"
