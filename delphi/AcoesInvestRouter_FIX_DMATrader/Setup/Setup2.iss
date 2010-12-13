; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{103FFF86-73F5-46DD-966C-D66D6CC1D1C5}
AppName=A��es Invest Router
AppVerName=A��es Invest Router 1.6  
AppPublisher=A��es Invest
AppPublisherURL=http://www.aifix.com.br
AppSupportURL=http://www.aifix.com.br
AppUpdatesURL=http://www.aifix.com.br
DefaultDirName=C:\A��es Invest Router
DefaultGroupName=A��es Invest Router
AllowNoIcons=yes
LicenseFile=C:\Users\Donda\Documents\RAD Studio\Projects\AcoesInvestRouter_FIX\contrato.txt
;InfoBeforeFile=C:\Users\Donda\Documents\RAD Studio\Projects\AcoesInvestRouter_FIX\requisitos.rtf
InfoAfterFile=C:\Users\Donda\Documents\RAD Studio\Projects\AcoesInvestRouter_FIX\requisitos.rtf
OutputBaseFilename=acoesrouter
Compression=lzma
SolidCompression=yes
WizardImageFile=C:\Users\Donda\Documents\RAD Studio\Projects\AcoesInvestRouter_FIX\Wizard1 copy.bmp

[Languages]
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}";
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "C:\Users\Donda\Documents\RAD Studio\Projects\AcoesInvestRouter_FIX\AcoesRouter.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\Donda\Documents\RAD Studio\Projects\AcoesInvestRouter_FIX\broker.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\Donda\Documents\RAD Studio\Projects\AcoesInvestRouter_FIX\broker.zbd"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\Donda\Documents\RAD Studio\Projects\AcoesInvestRouter_FIX\brokerages.ini"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\Donda\Documents\RAD Studio\Projects\AcoesInvestRouter_FIX\brokerRun.bat"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\Donda\Documents\RAD Studio\Projects\AcoesInvestRouter_FIX\requisitos.rtf"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\Donda\Documents\RAD Studio\Projects\AcoesInvestRouter_FIX\StockChartX.ocx"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\Donda\Documents\RAD Studio\Projects\AcoesInvestRouter_FIX\StockChartX.lic"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\Donda\Documents\RAD Studio\Projects\AcoesInvestRouter_FIX\Registrar.bat"; DestDir: "{app}"; Flags: ignoreversion
;Source: "C:\Users\Donda\Documents\RAD Studio\Projects\AcoesInvestRouter_FIX\data\*"; DestDir: "{app}\data"; Flags: ignoreversion recursesubdirs createallsubdirs
;Source: "C:\Users\Donda\Documents\RAD Studio\Projects\AcoesInvestRouter_FIX\Luma.exe"; DestDir: "{app}"; Flags: ignoreversion
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\A��es Invest Router"; Filename: "{app}\AcoesRouter.exe"
Name: "{group}\{cm:UninstallProgram,A��es Invest Router}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\A��es Invest Router"; Filename: "{app}\AcoesRouter.exe"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\A��es Invest Router"; Filename: "{app}\AcoesRouter.exe"; Tasks: quicklaunchicon

[Run]
Filename: "regsvr32.exe"; Parameters: "-s ""{app}\StockChartX.ocx"; Flags: waituntilterminated skipifsilent
Filename: "{app}\AcoesRouter.exe"; Description: "{cm:LaunchProgram,A��es Invest Router}"; Flags: nowait postinstall skipifsilent

