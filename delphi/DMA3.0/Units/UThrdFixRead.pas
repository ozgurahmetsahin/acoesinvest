unit UThrdFixRead;

interface

uses Classes, Windows, SysUtils, DMAConnection, UConnectionCenter;

type
  TThrdFixReader = class(TConnectionReader)
  private
    { Private declarations }
    MsgFix:String;
    FConnCenter: TConnectionCenter;
    procedure ProcessMsgFix;
  protected
    procedure Execute; override;
  public
    property ConnCenter: TConnectionCenter read FConnCenter write FConnCenter;
  end;

implementation

uses UFrmLogin;

{ TThrdFixReader }

procedure TThrdFixReader.Execute;
var MsgFixRead:String;
begin
 while FConn.Connected do
 begin
   // Le dados do servidor
   if FConn.Data.Next then
   begin
     MsgFixRead:=FConn.Data.GetData;

     MsgFix:= MsgFixRead;
     Synchronize(ProcessMsgFix);

     // Limpa mensagem por precaucao
     MsgFixRead:='';
   end
   else
    Sleep(100);
 end;
{ TODO -oDonda -cEstrutura :
Ao morrer por um erro antes de exibir o formulario FrmMain ( quando estiver na tela
de login ) nenhuma mensagem é exibida ao cliente. }
end;

procedure TThrdFixReader.ProcessMsgFix;
begin
 // Pede para o componente tratar
 ConnCenter.FixLibrary.ReadMsg(MsgFix);
end;

end.
