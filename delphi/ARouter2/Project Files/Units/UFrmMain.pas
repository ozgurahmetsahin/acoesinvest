unit UFrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UDataControl, StdCtrls, Buttons;

type
  TFrmMain = class(TForm)
    BitBtn1: TBitBtn;
    Memo1: TMemo;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Connection:TConnection;
  end;

var
  FrmMain: TFrmMain;

implementation

uses UConsts;

{$R *.dfm}

procedure TFrmMain.BitBtn1Click(Sender: TObject);
begin
  Connection:=TConnection.Create;
  Connection.Host:='server2.acoesinvest.com.br';
  Connection.Port:=81;
  Connection.ConnectTimeOut:=2000;
  Connection.ReadTimeOut:=250;

  if Connection.Connect then
  ShowMessage('Conectado')
  else ShowMessage('Erro');


end;

procedure TFrmMain.Button1Click(Sender: TObject);
begin
  Memo1.Lines.AddStrings(Connection.GetAllDataRecv);
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  {Configura Caption do Form}
  Self.Caption:=SAppName + SSpace + SAppVersion
end;

end.
