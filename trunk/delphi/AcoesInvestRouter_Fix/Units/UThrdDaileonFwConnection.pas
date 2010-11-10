unit UThrdDaileonFwConnection;

interface

uses
  Classes,Windows,SysUtils,IdException,IdExceptionCore,Dialogs;

type
  TDaileonFwConnection = class(TThread)
  private
    { Private declarations }
    Msg:String;
    procedure EchoMessage;
    procedure TryConnect;
  protected
    procedure Execute; override;
  end;

implementation

{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure TDaileonFwConnection.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ TDaileonFwConnection }

uses UFrmMainTreeView,UFrmConnection,UThrdDaileonFwRead,UFrmMainLine,UFrmTradeCentral,
UFrmTrade;

procedure TDaileonFwConnection.EchoMessage;
begin
 FrmConnection.StatusBar1.SimpleText:=Msg;
end;

procedure TDaileonFwConnection.Execute;
begin
  { Place thread code here }

  //Tentamos nos conectar ao Host
  Synchronize(TryConnect);
end;

procedure TDaileonFwConnection.TryConnect;
var ThrdRead : TThrdDaileonFwRead;
begin

 try
    FrmMainTreeView.DaileonFW.Host:=FrmMainTreeView.DefaultTradeHost;

    //Tenta se conectar no host configurado no componente
    FrmMainTreeView.DaileonFW.Connect;

    //Verificamos se realmente esta conectado
    if(FrmMainTreeView.DaileonFW.Connected) then
    begin
      Msg:='Você foi conectado com êxito.';
      Synchronize(EchoMessage);

      //Iniciamos Thread de Leitura
//      ThrdRead:=TThrdDaileonFwRead.Create(True);
      ThrdRead.Resume;

      //Fechamos o form de conexao e exibimos o form main
      FrmConnection.Hide;
      FrmMainLine.Show;

      //Enviamos a solicitação de Login...
      FrmMainTreeView.DaileonFW.IOHandler.WriteLn('login ' +
      FrmConnection.EdtUserTrade.Text + ' ' + FrmConnection.EdtPassTrade.Text);
    end;
  except
    //Houve uma exceção ao se conectar
     on E:EIdAlreadyConnected do
     begin
       MessageDlg('Você já está conectado.',mtInformation,[mbOk],0);
       Msg:='Aviso: Você já está conectado.';
       Synchronize(EchoMessage);
     end;
     on E:EIdConnectTimeout do
     begin
       MessageDlg('O servidor não respondeu no tempo limite.',mtInformation,[mbOk],0);
       Msg:='Aviso: O servidor não respondeu no tempo limite.';
       Synchronize(EchoMessage);
     end;
     on E:EIdConnectException do
     begin
       MessageDlg('Houve uma falha ao se conectar.',mtInformation,[mbOk],0);
       Msg:='Aviso: Houve uma falha ao se conectar.';
       Synchronize(EchoMessage);
     end;
  end;
end;

end.
