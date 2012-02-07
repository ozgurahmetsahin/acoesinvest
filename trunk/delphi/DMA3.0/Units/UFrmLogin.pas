unit UFrmLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, pngimage, ExtCtrls, UFrmDefault, UConnectionCenter;

type
  TfrmLogin = class(TFrmDefault)
    imgLogin: TImage;
    edtUserDiffusion: TEdit;
    edtPassDiffusion: TEdit;
    edtUserBroker: TEdit;
    edtPassBroker: TEdit;
    chbSave: TCheckBox;
    btnEnter: TButton;
    btnClear: TButton;
    btnExit: TButton;
    procedure btnClearClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure btnEnterClick(Sender: TObject);

  private
    { Private declarations }

  public
    { Public declarations }

  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.dfm}

procedure TfrmLogin.btnClearClick(Sender: TObject);
begin
  edtUserDiffusion.Clear;
  edtPassDiffusion.Clear;
  edtUserBroker.Clear;
  edtPassBroker.Clear;
  edtUserDiffusion.SetFocus;
end;

procedure TfrmLogin.btnEnterClick(Sender: TObject);
var NewConnCenter:TConnectionCenter;
begin
  // Cria o Centro de Conexao
  NewConnCenter:=TConnectionCenter.Create(nil);
  // Associa o centro de difusao para a propriedade interna
  Self.ConnCenter:=NewConnCenter;
  // Conecta ao servidor
  if NewConnCenter.ConnectFix('189.59.5.156', 443) then
  NewConnCenter.StartFix(edtUserBroker.Text, edtPassBroker.Text);  // Manda mensagem de autenticao no servidor

end;

procedure TfrmLogin.btnExitClick(Sender: TObject);
begin
  Application.Terminate; // O Close funciona tbm, mas o terminate,
                         // manda o sinal para o windows avisando a finalizacao
                         // assim liberando a memoria utilizada.
end;


end.
