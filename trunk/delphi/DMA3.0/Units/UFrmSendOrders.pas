unit UFrmSendOrders;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, JvExComCtrls, JvComCtrls, StdCtrls, ExtCtrls, Menus,
  UFrmLogin, URouterLibrary, UFrmDefault, UConnectionCenter;

type
  TfrmSendOrders = class(TFrmDefault)
    Panel3: TPanel;
    Label1: TLabel;
    edtClientAccount: TLabeledEdit;
    edtSymbol: TLabeledEdit;
    cbValidity: TComboBox;
    edtClientName: TEdit;
    dtUntilDate: TDateTimePicker;
    btnSendOrder: TButton;
    btnOptions: TButton;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    rdDirectionSell: TRadioButton;
    rdDirectionBuy: TRadioButton;
    popOptions: TPopupMenu;
    popOptClearAfterSend: TMenuItem;
    popOptCloseAfterSend: TMenuItem;
    N1: TMenuItem;
    popOptChangeColor: TMenuItem;
    N2: TMenuItem;
    popOptAdvanceSendOrder: TMenuItem;
    popOptConfirmBeforeSend: TMenuItem;
    edtQuantity: TEdit;
    Label10: TLabel;
    edtPrice: TEdit;
    Label11: TLabel;
    cdlgChangeColor: TColorDialog;
    procedure rdDirectionSellClick(Sender: TObject);
    procedure rdDirectionBuyClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnSendOrderClick(Sender: TObject);
    procedure btnOptionsClick(Sender: TObject);
    procedure cbValidityChange(Sender: TObject);
    procedure edtQuantityKeyPress(Sender: TObject; var Key: Char);
    procedure edtQuantityMouseActivate(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y, HitTest: Integer;
      var MouseActivate: TMouseActivate);
    procedure edtQuantityDblClick(Sender: TObject);
    procedure edtQuantityKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtQuantityClick(Sender: TObject);
    procedure edtPriceKeyPress(Sender: TObject; var Key: Char);
    procedure edtPriceClick(Sender: TObject);
    procedure edtPriceDblClick(Sender: TObject);
    procedure edtPriceKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtPriceMouseActivate(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y, HitTest: Integer;
      var MouseActivate: TMouseActivate);
    procedure popOptChangeColorClick(Sender: TObject);
    procedure edtClientAccountExit(Sender: TObject);
  private
    FOrderDirection: TDirectionOrderFix;
    FQuantity: String;
    FPrice: String;
    procedure SetOrderDirection(const Value: TDirectionOrderFix);
    procedure SelectOrderDirection;
    procedure SendOrder;
    procedure ClearData;
    procedure AddToQuantity ( Value: Integer);
    procedure MultiplyQuantity( Value:Integer);
    procedure SubtractQuantity( Value: Integer);
    procedure AddToPrice(Value : Double);
    procedure SubtractPrice(Value: Double);
    procedure MultiplyPrice( Value:Integer);
    procedure FormatQuantity( Key:Char );
    procedure FormatPrice( Key:Char );
    function AjustPrice:String;
    procedure ChangeColor;
    procedure ConsultClientName;
    { Private declarations }
  public
    { Public declarations }
    property OrderDirection: TDirectionOrderFix read FOrderDirection
      write SetOrderDirection;
  end;

var
  frmSendOrders: TfrmSendOrders;

implementation

uses UFrmConfirmSendOrder;

{$R *.dfm}

{ TForm1 }

procedure TfrmSendOrders.AddToPrice(Value: Double);
var V:Double;
    PriceTemp:String;
begin
  // Obtemos o valor atual do price
  if FPrice<>'' then
  V:=StrToFloat(AjustPrice)
  else
  V:=0;

  // Adicionamos a ele o valor desejado
  V:= V + Value;

  // Colocamos numa variavel temporaria o valor
  // do price adicionado para que possamos remover
  // os pontos
  PriceTemp:= StringReplace(FormatFloat('0.00',V),FormatSettings.DecimalSeparator,'',[rfReplaceAll]);
  // Removemos os 0 a esquerda
  PriceTemp:= IntToStr(StrToInt(PriceTemp));

  // Colocamos o price atual devolta
  FPrice:= PriceTemp;

  // Exibimos no edit o novo valor
  FormatPrice(#0);
end;

procedure TfrmSendOrders.AddToQuantity(Value: Integer);
var V:Integer;
begin
  // Converte a quantidade em numero
  if FQuantity<>'' then
  V:=StrToInt(FQuantity)
  else
  V:=0;

  // Adiciona na quantidade
  V:= V + Value;

  // Retorna na quantidade o valor adicionado
  FQuantity:=IntToStr(V);

  // Formata no edit ( Key #0 para que a funcao igunore
  // adicionar na string da quantidade e formate o valor atual
  FormatQuantity(#0);
end;

function TfrmSendOrders.AjustPrice: String;
begin
  Result:='0';
  // Se FPrice so tiver 2 chars, exemplo: 50,
  // significa entao q esses 50 são centavos
  // ficando 0,50, para maior que 2 char,
  // por exemplo 150, entao significa que tem
  // que ficar 1,50
  if Length(FPrice) = 1 then
  begin
    Result:= '0' + FormatSettings.DecimalSeparator +'0' +FPrice;
  end
  else if Length(FPrice) = 2 then
  begin
    Result:= '0' + FormatSettings.DecimalSeparator + FPrice;
  end
  else
  begin
    Result:= Copy(FPrice,1,Length(FPrice)-2) + FormatSettings.DecimalSeparator +
    Copy(FPrice,Length(FPrice)-1,Length(FPrice));
  end;
end;

procedure TfrmSendOrders.btnOptionsClick(Sender: TObject);
var Cursor:TPoint;
begin
 GetCursorPos(Cursor);
 popOptions.Popup(Cursor.X,Cursor.Y);
end;

procedure TfrmSendOrders.btnSendOrderClick(Sender: TObject);
begin
  SendOrder;
end;

procedure TfrmSendOrders.cbValidityChange(Sender: TObject);
begin
  // Exbibe o campo de data
  // para validade 'Até o dia'
  if cbValidity.ItemIndex=3 then
  dtUntilDate.Visible:=True
  else
  dtUntilDate.Visible:=False;
end;

procedure TfrmSendOrders.ChangeColor;
begin
  cdlgChangeColor.Color:=Panel3.Color;
  if cdlgChangeColor.Execute then
  Panel3.Color:=cdlgChangeColor.Color;
end;

procedure TfrmSendOrders.ClearData;
begin
  edtClientAccount.Clear;
  edtSymbol.Clear;
  edtQuantity.Clear;
  edtPrice.Clear;
  edtClientName.Clear;
end;

procedure TfrmSendOrders.ConsultClientName;
var Msg:String;
begin
  ConnCenter.ConsultClientName:= edtClientName;
  Msg:=ConnCenter.FixLibrary.UserListRequest(edtClientAccount.Text);
  Msg:=Msg + ConnCenter.FixLibrary.GenerateCheckSum(Msg);
  ConnCenter.SendCmdFix(Msg);;
end;

procedure TfrmSendOrders.edtClientAccountExit(Sender: TObject);
begin
  ConsultClientName;
end;

procedure TfrmSendOrders.edtPriceClick(Sender: TObject);
begin
  // Garante que o cursor vai sempre estar no final
  edtPrice.SelStart:=Length(edtPrice.Text);
end;

procedure TfrmSendOrders.edtPriceDblClick(Sender: TObject);
begin
  // Evita que fica selecionado tudo
  edtPrice.SelStart:=Length(edtPrice.Text);
end;

procedure TfrmSendOrders.edtPriceKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // Abortamos o uso das teclas direcionais
  if (Key >= 37) and (Key <= 40) then
  Key:=0
  else if Key = 46 then
  begin
    // Abortamos o uso do delete
    edtPrice.SelStart:=Length(edtPrice.Text);
    Key:=0;
  end;
end;

procedure TfrmSendOrders.edtPriceKeyPress(Sender: TObject; var Key: Char);
begin
  // Formata o preco
  FormatPrice(Key);
  // Anula a exbicao do char digitado no edit
  Key:=#0;
end;

procedure TfrmSendOrders.edtPriceMouseActivate(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y, HitTest: Integer;
  var MouseActivate: TMouseActivate);
begin
  // Se estiver ja em focus
  if TEdit(edtPrice).Focused then
  begin
    // Direito adiciona, esquerdo subtrai
    if Button = mbLeft then
    AddToPrice(0.01)
    else if Button = mbRight then
    SubtractPrice(0.01);
  end;

  // Se botao direito, evita aparecer as opcoes do edit
  if Button = mbRight then
  MouseActivate:=maActivateAndEat;
end;

procedure TfrmSendOrders.edtQuantityClick(Sender: TObject);
begin
  // Garante que o cursor vai sempre estar no final
  edtQuantity.SelStart:=Length(edtQuantity.Text);
end;

procedure TfrmSendOrders.edtQuantityDblClick(Sender: TObject);
begin
  // Evita que fica selecionado tudo
  edtQuantity.SelStart:=Length(edtQuantity.Text);
end;

procedure TfrmSendOrders.edtQuantityKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // Abortamos o uso das teclas direcionais
  if (Key >= 37) and (Key <= 40) then
  Key:=0
  else if Key = 46 then
  begin
    // Abortamos o uso do delete
    edtQuantity.SelStart:=Length(edtQuantity.Text);
    Key:=0;
  end;
end;

procedure TfrmSendOrders.edtQuantityKeyPress(Sender: TObject; var Key: Char);
begin
  // Formata a quantidade
  FormatQuantity(Key);
  // Aborta a escrita do char no edit
  Key:=#0;
end;

procedure TfrmSendOrders.edtQuantityMouseActivate(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y, HitTest: Integer;
  var MouseActivate: TMouseActivate);
begin
  // Se estiver ja em focus
  if TEdit(edtQuantity).Focused then
  begin
    // Direito adiciona, esquerdo subtrai
    if Button = mbLeft then
    AddToQuantity(100)
    else if Button = mbRight then
    SubtractQuantity(100);
  end;

  // Se botao direito, evita aparecer as opcoes do edit
  if Button = mbRight then
  MouseActivate:=maActivateAndEat;

end;

procedure TfrmSendOrders.FormatPrice(Key: Char);
begin
  { O uso dessa diretiva de compilacao faz com que
    desativa a mensagem de Warning durante a compilacao
    dessa funcao. Estou usando isso pois o uso da estrutura
    abaixo Key in [..] gera uma mensagem de Warning pelo compilador
    avisando que é melhor usar outra funcao para essa comparacao.
    Porem essa funcao nao é muito boa e é muito lenta, por tanto
    preferi continuar usando esse tipo de estrutura e desativando
    a mensagem de Warning.
    Assim se tiver um warning em outra parte do projeto, vai aparecer
    na compilacao e sei que não sera essa aqui. }
  {$Warnings Off}
  // Se for apenas numeros digitados
  // isso evita que char do Backspace
  // fique na string de controle do preco
  if Key in [#48..#57] then
  begin
    // Adiciona o char no final da string
    FPrice:=FPrice + Key;

    // Se for 0( zero) e nao tiver nada no preco
    // ignora a adicao para que nao fique com um
    // zero a esquerda. Exemplo: 0353
    if FPrice = '0' then
    FPrice:= '';
  end
  else if Key = #8 then
  begin
    // Backspace, retira o ultimo char da string
    if Length(FPrice) > 1 then
    FPrice:= Copy(FPrice,1,Length(FPrice)-1)
    else
    FPrice:='';
  end
  else if Key = #42 then
  begin
    // Asterisco, multiplica a quantidade atual por mil
    MultiplyPrice(1000);
  end
  else if Key = #43 then
  begin
    // Sinal de +, adiciona na quantidade 100
    AddToPrice(0.01);
  end
  else if Key = #45 then
  begin
    // Sinal de -, subtrai na quantidade 100
    SubtractPRice(0.01);
  end;

  // Escreve no edit o numero formatado
  if FPrice<>'' then
  edtPrice.Text:=FormatFloat('###,###,###,##0.00',StrToFloat(AjustPrice))
  else
  edtPrice.Text:='';

  // Coloca o cursor no final da string
  edtPrice.SelStart:=Length(edtPrice.Text);

  {Reativamos a diretiva para continuar avisando
  warnings em outros lugares }
  {$Warnings on}
end;

procedure TfrmSendOrders.FormatQuantity(Key: Char);
begin

  { O uso dessa diretiva de compilacao faz com que
    desativa a mensagem de Warning durante a compilacao
    dessa funcao. Estou usando isso pois o uso da estrutura
    abaixo Key in [..] gera uma mensagem de Warning pelo compilador
    avisando que é melhor usar outra funcao para essa comparacao.
    Porem essa funcao nao é muito boa e é muito lenta, por tanto
    preferi continuar usando esse tipo de estrutura e desativando
    a mensagem de Warning.
    Assim se tiver um warning em outra parte do projeto, vai aparecer
    na compilacao e sei que não sera essa aqui. }
  {$Warnings Off}

  // Se for apenas numeros digitados
  // isso evita que char do Backspace
  // fique na string de controle da quantidade
  if Key in [#48..#57] then
  begin
    // Adiciona o char no final da string
    FQuantity:=FQuantity + Key;

    // Se for 0( zero) e nao tiver nada na quantidade
    // ignora a adicao para que nao fique com um
    // zero a esquerda. Exemplo: 0353
    if FQuantity = '0' then
    FQuantity:= '';
  end
  else if Key = #8 then
  begin
    // Backspace, retira o ultimo char da string
    if Length(FQuantity) > 1 then
    FQuantity:= Copy(FQuantity,1,Length(FQuantity)-1)
    else
    FQuantity:='';
  end
  else if Key = #42 then
  begin
    // Asterisco, multiplica a quantidade atual por mil
    MultiplyQuantity(1000);
  end
  else if Key = #43 then
  begin
    // Sinal de +, adiciona na quantidade 100
    AddToQuantity(100);
  end
  else if Key = #45 then
  begin
    // Sinal de -, subtrai na quantidade 100
    SubtractQuantity(100);
  end;

  // Escreve no edit o numero formatado
  if FQuantity <> '' then
  edtQuantity.Text:= FormatFloat('###,###,###,###,###', StrToFloat(FQuantity))
  else
  edtQuantity.Text:= '';

  // Coloca o cursor no final da string
  edtQuantity.SelStart:=Length(edtQuantity.Text);

  {Reativamos a diretiva para continuar avisando
  warnings em outros lugares }
  {$Warnings on}
end;

procedure TfrmSendOrders.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // Se Esc, fecha a janela
  if Key = 27 then
  Self.Close;
end;

procedure TfrmSendOrders.MultiplyPrice(Value: Integer);
var V:Double;
    PriceTemp:String;
begin
  // Obtemos o valor atual do price
  if FPrice<>'' then
  V:=StrToFloat(AjustPrice)
  else
  V:=0;

  // Multiplicamos a ele o valor desejado
  V:= V * Value;

  // Colocamos numa variavel temporaria o valor
  // do price adicionado para que possamos remover
  // os pontos
  PriceTemp:= StringReplace(FormatFloat('0.00',V),FormatSettings.DecimalSeparator,'',[rfReplaceAll]);
  // Removemos os 0 a esquerda
  PriceTemp:= IntToStr(StrToInt(PriceTemp));

  // Colocamos o price atual devolta
  FPrice:= PriceTemp;

  // Exibimos no edit o novo valor
  FormatPrice(#0);
end;

procedure TfrmSendOrders.MultiplyQuantity(Value: Integer);
var V:Integer;
begin
  // Converte a quantidade em numero
  if FQuantity<>'' then
  V:=StrToInt(FQuantity)
  else
  V:=0;

  // Adiciona na quantidade
  V:= V * Value;

  // Retorna na quantidade o valor adicionado
  FQuantity:=IntToStr(V);

  // Formata no edit ( Key #0 para que a funcao igunore
  // adicionar na string da quantidade e formate o valor atual
  FormatQuantity(#0);
end;

procedure TfrmSendOrders.popOptChangeColorClick(Sender: TObject);
begin
  ChangeColor;
end;

procedure TfrmSendOrders.rdDirectionBuyClick(Sender: TObject);
begin
  SelectOrderDirection;
end;

procedure TfrmSendOrders.rdDirectionSellClick(Sender: TObject);
begin
  SelectOrderDirection
end;

procedure TfrmSendOrders.SelectOrderDirection;
begin
  // Seleciona a direcao da ordem
  if rdDirectionBuy.Checked then
  begin
    OrderDirection:= dcBuy;
    Self.Caption:='Boleta Compra';
    Panel3.Color:=$0080FF80;
  end
  else if rdDirectionSell.Checked then
       begin
        OrderDirection:= dcSell;
        Self.Caption:='Boleta Venda';
        Panel3.Color:=$0080FFFF;
       end
       else
        raise Exception.Create('Direção da Ordem desconhecida.');
end;

procedure TfrmSendOrders.SendOrder;
var Msg:String;
    ValidityOrder:TValidityOrderFix;
    FConfirm:TfrmConfirmOrderBeforeSend;
begin
  // Suprime mensagem de warning do delphi avisando
  // que essa variavel pode nao ser inicializada.
  ValidityOrder:=vdToday;

  // Validade da Ordem
  case cbValidity.ItemIndex of
    0: ValidityOrder:= vdToday;
    1: ValidityOrder:= vdGoodTillCancel;
    2: ValidityOrder:= vdParcExecOrCancel;
    3: ValidityOrder:= vdGoodTillDate;
  end;

  // Prepara a mensagem a ser enviada
  Msg:= ConnCenter.FixLibrary.SendOrderFix(edtClientAccount.Text, edtSymbol.Text, FQuantity,
  StringReplace(AjustPrice,',','.',[rfReplaceAll]), ValidityOrder, FOrderDirection, dtUntilDate.Date);
  // Adiciona o Checksum
  Msg:= Msg + ConnCenter.FixLibrary.GenerateCheckSum(Msg);

  // Envia
  if popOptConfirmBeforeSend.Checked then
  begin
    // Necessita confirmar primeiro.
    // Self no Owner para que apareca no centro do boleta, assim
    // como ta setado na propriedade position do FrmConfirmOrderBeforeSend
    FConfirm:= TfrmConfirmOrderBeforeSend.Create(Self);
    if FConfirm.ConfirmOrder(edtClientAccount.Text, edtClientName.Text, edtSymbol.Text, FQuantity,
    StringReplace(AjustPrice,',','.',[rfReplaceAll]), FOrderDirection, ValidityOrder, dtUntilDate.Date, '--') = mrOk then
    begin
      ConnCenter.SendCmdFix(Msg);
      // Verifica as opcoes da boleta
      if popOptClearAfterSend.Checked then
      ClearData;
      if popOptCloseAfterSend.Checked then
      Self.Close;
    end;
  end
  else
  begin
    // Envia sem confirmar
    ConnCenter.SendCmdFix(Msg);
    // Verifica as opcoes da boleta
    if popOptClearAfterSend.Checked then
    ClearData;
    if popOptCloseAfterSend.Checked then
    Self.Close;
  end;

end;

procedure TfrmSendOrders.SetOrderDirection(const Value: TDirectionOrderFix);
begin
  FOrderDirection := Value;
  case Value of
    dcBuy: rdDirectionBuy.Checked:=True;
    dcSell: rdDirectionSell.Checked:=True ;
  end;
end;

procedure TfrmSendOrders.SubtractPrice(Value: Double);
var V:Double;
    PriceTemp:String;
begin
  // Obtemos o valor atual do price
  if FPrice<>'' then
  V:=StrToFloat(AjustPrice)
  else
  V:=0;

  // Subtraimos a ele o valor desejado
  V:= V - Value;

  // Garante q Price nao vai ficar negativo
  if V<=0 then
  V:=0;

  // Colocamos numa variavel temporaria o valor
  // do price adicionado para que possamos remover
  // os pontos
  PriceTemp:= StringReplace(FormatFloat('0.00',V),FormatSettings.DecimalSeparator,'',[rfReplaceAll]);
  // Removemos os 0 a esquerda
  PriceTemp:= IntToStr(StrToInt(PriceTemp));

  // Colocamos o price atual devolta
  FPrice:= PriceTemp;

  // Exibimos no edit o novo valor
  FormatPrice(#0);
end;

procedure TfrmSendOrders.SubtractQuantity(Value: Integer);
var V:Integer;
begin
  // Converte a quantidade em numero
  if FQuantity<>'' then
  V:=StrToInt(FQuantity)
  else
  V:=0;

  // Subtrai na quantidade
  V:= V - Value;

  // Garante que quantidade nao fica negativa
  if V <= 0 then
  V:=0;

  // Retorna na quantidade o valor adicionado
  FQuantity:=IntToStr(V);

  // Formata no edit ( Key #0 para que a funcao igunore
  // adicionar na string da quantidade e formate o valor atual
  FormatQuantity(#0);
end;

end.
