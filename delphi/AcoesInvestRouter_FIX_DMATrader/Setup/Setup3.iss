; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{D729EE96-4254-4B29-9480-EAEED2344972}
AppName=A��es Invest Router
AppVersion=1.3.5.4
;AppVerName=A��es Invest Router 1.5
AppPublisher=A��es Invest
AppPublisherURL=http://www.aifix.com.br
AppSupportURL=http://www.aifix.com.br
AppUpdatesURL=http://www.aifix.com.br
DefaultDirName=C:\A��es Invest Router
DefaultGroupName=A��es Invest Router
AllowNoIcons=yes
InfoAfterFile=C:\Documents and Settings\Anderson\My Documents\Donda\Projetos\AcoesInvestRouter_FIX\contrato.txt
OutputBaseFilename=acoesrouter
Compression=lzma
SolidCompression=yes

[Languages]
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 0,6.1

[Files]
Source: "C:\Documents and Settings\Anderson\My Documents\Donda\Projetos\AcoesInvestRouter_FIX\AcoesInvestRouter.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Documents and Settings\Anderson\My Documents\Donda\Projetos\AcoesInvestRouter_FIX\broker.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Documents and Settings\Anderson\My Documents\Donda\Projetos\AcoesInvestRouter_FIX\broker.zbd"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Documents and Settings\Anderson\My Documents\Donda\Projetos\AcoesInvestRouter_FIX\brokerages.ini"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Documents and Settings\Anderson\My Documents\Donda\Projetos\AcoesInvestRouter_FIX\brokerRun.bat"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Documents and Settings\Anderson\My Documents\Donda\Projetos\AcoesInvestRouter_FIX\Luma.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Documents and Settings\Anderson\My Documents\Donda\Projetos\AcoesInvestRouter_FIX\JGrafix\*"; DestDir: "{app}\JGrafix"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\A��es Invest Router"; Filename: "{app}\"
Name: "{group}\{cm:ProgramOnTheWeb,A��es Invest Router}"; Filename: "http://www.aifix.com.br"
Name: "{group}\{cm:UninstallProgram,A��es Invest Router}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\A��es Invest Router"; Filename: "{app}\"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\A��es Invest Router"; Filename: "{app}\"; Tasks: quicklaunchicon

[Run]
Filename: "{app}\AcoesInvestRouter.exe"; Description: "{cm:LaunchProgram,A��es Invest Router}"; Flags: shellexec postinstall skipifsilent
