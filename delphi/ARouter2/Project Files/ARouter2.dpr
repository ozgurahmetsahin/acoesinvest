program ARouter2;

uses
  Forms,
  UFrmMain in 'Units\UFrmMain.pas' {FrmMain},
  UConsts in 'Units\UConsts.pas',
  UDataControl in 'Units\UDataControl.pas',
  UFrmConnectionControl in 'Units\UFrmConnectionControl.pas' {FrmConnectionControl},
  UFrmSheet in 'Units\UFrmSheet.pas' {FrmSheet},
  UFrmOpenSheet in 'Units\UFrmOpenSheet.pas' {FrmOpenSheet};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.CreateForm(TFrmConnectionControl, FrmConnectionControl);
  Application.CreateForm(TFrmSheet, FrmSheet);
  Application.CreateForm(TFrmOpenSheet, FrmOpenSheet);
  Application.Run;
end.
