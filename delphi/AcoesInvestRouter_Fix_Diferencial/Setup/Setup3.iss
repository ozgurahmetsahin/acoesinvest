; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{8D6EFD94-82F9-4006-8C3B-76BA86E8E2C5}
AppName=DMA Trader
AppVersion=1.6
;AppVerName=DMA Trader 1.6
AppPublisher=Invest Software
AppPublisherURL=http://www.diferencial.com.br
AppSupportURL=http://www.diferencial.com.br
AppUpdatesURL=http://www.diferencial.com.br
DefaultDirName=C:\DMATrader
DefaultGroupName=DMA Trader
LicenseFile=C:\Documents and Settings\Anderson\My Documents\Donda\Projetos\AcoesInvestRouter_FIX_Diferencial\contrato.txt
InfoAfterFile=C:\Documents and Settings\Anderson\My Documents\Donda\Projetos\AcoesInvestRouter_FIX_Diferencial\requisitos.rtf
OutputBaseFilename=dmatrader
Compression=lzma
SolidCompression=yes

[Languages]
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 0,6.1

[Files]
Source: "C:\Documents and Settings\Anderson\My Documents\Donda\Projetos\AcoesInvestRouter_FIX_Diferencial\DMATrader.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Documents and Settings\Anderson\My Documents\Donda\Projetos\AcoesInvestRouter_FIX_Diferencial\broker.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Documents and Settings\Anderson\My Documents\Donda\Projetos\AcoesInvestRouter_FIX_Diferencial\broker.zbd"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Documents and Settings\Anderson\My Documents\Donda\Projetos\AcoesInvestRouter_FIX_Diferencial\brokerages.ini"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Documents and Settings\Anderson\My Documents\Donda\Projetos\AcoesInvestRouter_FIX_Diferencial\brokerRun.bat"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Documents and Settings\Anderson\My Documents\Donda\Projetos\AcoesInvestRouter_FIX_Diferencial\requisitos.rtf"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Documents and Settings\Anderson\My Documents\Donda\Projetos\AcoesInvestRouter_FIX_Diferencial\JGrafix\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\DMA Trader"; Filename: "{app}\DMATrader.exe"
Name: "{group}\{cm:ProgramOnTheWeb,DMA Trader}"; Filename: "http://www.diferencial.com.br"
Name: "{group}\{cm:UninstallProgram,DMA Trader}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\DMA Trader"; Filename: "{app}\DMATrader.exe"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\DMA Trader"; Filename: "{app}\DMATrader.exe"; Tasks: quicklaunchicon

[Run]
Filename: "{app}\DMATrader.exe"; Description: "{cm:LaunchProgram,DMA Trader}"; Flags: nowait postinstall skipifsilent
