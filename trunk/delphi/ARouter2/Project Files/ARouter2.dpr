program ARouter2;

uses
  Forms,
  UFrmMain in 'Units\UFrmMain.pas' {FrmMain},
  UConsts in 'Units\UConsts.pas',
  UDataControl in 'Units\UDataControl.pas',
  UFrmConnectionControl in 'Units\UFrmConnectionControl.pas' {FrmConnectionControl},
  UFrmSheet in 'Units\UFrmSheet.pas' {FrmSheet},
  UFrmOpenSheet in 'Units\UFrmOpenSheet.pas' {FrmOpenSheet},
  UFrmBook in 'Units\UFrmBook.pas' {FrmBook},
  UFrmLogin in 'Units\UFrmLogin.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmBook, FrmBook);
  Application.Run;
end.
