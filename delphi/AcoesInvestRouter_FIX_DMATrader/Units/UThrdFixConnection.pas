unit UThrdFixConnection;

interface

uses
  Classes,IdException,IdExceptionCore;

type
  TFixConnection = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute; override;
  end;

implementation
  uses UFrmMainTreeView, UFrmConnection, URouterLibrary,UThrdFixRead;
{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure TThrdFixConnection.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ TThrdFixConnection }

procedure TFixConnection.Execute;
var MsgLoginFix:String;
    MsgError:String;
    FixRead: TFixRead;
begin
  { Place thread code here }

  try

    {Se conecta ao fix}
    FrmMainTreeView.Fix.Connect;

    if FrmMainTreeView.Fix.Connected then
    begin
      {Seta User e Pass}
//      FrmMainTreeView.RouterLibrary1.FixSession.Username:=FrmConnection.Edit1.Text;
//      FrmMainTreeView.RouterLibrary1.FixSession.Password:=FrmConnection.Edit2.Text;
//      FrmMainTreeView.RouterLibrary1.FixSession.SenderCompId:=FrmConnection.Edit1.Text;

      {Gera msg de login}
      MsgLoginFix:=FrmMainTreeView.RouterLibrary1.Logon(FIXProtocol);

      {Gera Checksum}
      MsgLoginFix:=MsgLoginFix + FrmMainTreeView.RouterLibrary1.GenerateCheckSum(MsgLoginFix);

      {Escreve no memo}
      FrmMainTreeView.Memo1.Lines.Add(MsgLoginFix);

      {Inicia Leitor}
      FixRead:=TFixRead.Create(True);
      FixRead.Resume;

      {Envia}
      FrmMainTreeView.Fix.IOHandler.WriteLn(MsgLoginFix);

    end;

  except

    on E:EIdConnectTimeout do
    begin
      MsgError:='Tempo limite excedido para conexão ao servidor FIX.';
      FrmMainTreeView.MsgErr:=MsgError;
      FrmMainTreeView.ShowMsgErr;
    end;

    on E:EIdConnectException do
    begin
      MsgError:='Não foi possível se conectar ao servidor FIX.';
      FrmMainTreeView.MsgErr:=MsgError;
      FrmMainTreeView.ShowMsgErr;
    end;

    on E:EIdException do
    begin
      MsgError:='Erro geral ao se conectar ao servidor FIX.';
      FrmMainTreeView.MsgErr:=MsgError;
      FrmMainTreeView.ShowMsgErr;
    end;

  end;
end;

end.

