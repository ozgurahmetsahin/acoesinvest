unit UThrdBrokerConnection;

interface

uses
  Classes,SysUtils,IdException,IdExceptionCore;

type
  TBrokerConnection = class(TThread)
  private
    { Private declarations }
    procedure TryConnect;
  protected
    procedure Execute; override;
  end;

implementation
  uses UFrmMainTreeView,UThrdBrokerRead,UFrmConnection,UFrmPortfolio;
{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure TThrdBrokerConnection.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ TThrdBrokerConnection }

procedure TBrokerConnection.Execute;
begin
  { Place thread code here }
  Synchronize(TryConnect);
end;

procedure TBrokerConnection.TryConnect;
var BrokerRead : TBrokerRead;
    MsgLogin : String;
    BMsgLogin : TBytes;
begin
  try
    // Limpa Custodia
    FrmPortfolio.Portfolio.ClearLines;

    //Tenta se conectar
    FrmMainTreeView.Broker.Connect;

    //Se realmente conectou
    if FrmMainTreeView.Broker.Connected then
    begin

       FrmMainTreeView.Memo1.Lines.Add('Conectado');

//       //Inicia Thread de Leitura de dados
       BrokerRead:=TBrokerRead.Create(True);
       BrokerRead.Resume;

       //Enviamos solicitação de login
       MsgLogin:='35=LOGIN' + #1 + '553=' + FrmConnection.EdtUserBroker.Text + #1 +
                                    '554=' + FrmConnection.EdtPassBroker.Text + #1 +
                                    '5158=2' + #1 +#3;

       BMsgLogin:=FrmMainTreeView.StrToBytes(MsgLogin);

       FrmMainTreeView.Broker.IOHandler.WriteDirect(BMsgLogin);
    end;
  except
    on E:EIdConnectTimeout do
    begin
       FrmMainTreeView.MsgErr:='Não foi possível se conectar ao broker.';
       FrmMainTreeView.ShowMsgErr;
    end;
  end;
end;

end.
