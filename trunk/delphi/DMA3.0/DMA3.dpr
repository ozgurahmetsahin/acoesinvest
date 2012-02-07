program DMA3;

uses
  Forms,
  UFrmLogin in 'Units\UFrmLogin.pas' {frmLogin},
  UFrmMainBar in 'Units\UFrmMainBar.pas' {frmMainBar},
  UFrmSheetDiffusion in 'Units\UFrmSheetDiffusion.pas' {frmSheetDiffusion},
  UThrdFixRead in 'Units\UThrdFixRead.pas',
  UFrmConfirmSendOrder in 'Units\UFrmConfirmSendOrder.pas' {frmConfirmOrderBeforeSend},
  UFrmDefault in 'Units\UFrmDefault.pas' {FrmDefault},
  UFrmSendOrders in 'Units\UFrmSendOrders.pas' {frmSendOrders},
  UConnectionCenter in 'Units\UConnectionCenter.pas' {ConnectionCenter},
  DMAConnection in 'Units\DMAConnection.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.Run;
end.
