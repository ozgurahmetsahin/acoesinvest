unit UFrmPortfolio;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, Sheet, StdCtrls, ExtCtrls, Buttons;

type
  TFrmPortfolio = class(TForm)
    Portfolio: TSheet;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Calculator: TTimer;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label24: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    BitBtn1: TBitBtn;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Shape1: TShape;
    procedure FormShow(Sender: TObject);
    procedure CalculatorTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPortfolio: TFrmPortfolio;

implementation

uses UFrmMainTreeView;

{$R *.dfm}

procedure TFrmPortfolio.BitBtn1Click(Sender: TObject);
var MsgSend:String;
    BMsgSend:TBytes;
begin
  MsgSend:='35=ADR' + #1 + '5017=5' + #1 + #3;
  BMsgSend:=FrmMainTreeView.StrToBytes(MsgSend);
  FrmMainTreeView.Broker.IOHandler.WriteDirect(BMsgSend);
end;

procedure TFrmPortfolio.CalculatorTimer(Sender: TObject);
var Qtde : Integer;
    Val1 : Double;
    Val2 : Double;
    Val3 : Double;
    Val4 : Double;
    ValTemp : Double;
    K : Integer;
begin

if(FrmMainTreeView.Broker.Connected) then
begin

  Val1 := 0; Val2 := 0; Val3 := 0; Val4 := 0; Qtde := 0;

  if (Portfolio.RowCount >= 1) And (Portfolio.Cells[0,1] <> '') then
  begin
  for K := 1 to Portfolio.RowCount - 1 do
  begin

    try

//     if Portfolio.GetValue(clLast,Portfolio.Cells[0,K]) <>'0' then
//     Qtde := StrToInt(Portfolio.GetValue(clLast,Portfolio.Cells[0,K]))
//     else
     Qtde := StrToInt(Portfolio.GetValue(clPicture,Portfolio.Cells[0,K]));

     // Se quantidade estiver zerada, excluir da lista
     if Qtde = 0 then
     begin
       FrmPortfolio.Portfolio.DelLine(FrmPortfolio.Portfolio.Cells[0,K]);
     end
     else
     begin

       // Total em custodia
       Val1 := StrToFloat(FrmMainTreeView.ChangeDecimalSeparator(Portfolio.GetValue(clSell,Portfolio.Cells[0,K]),'.',','));
       Val2 := Val1 * Qtde;
       Portfolio.SetValue(clBaseIn,Portfolio.Cells[0,K], FormatFloat('0.00',Val2));

       // Zera para não ter erros
       Val1 := 0; Val2 := 0;

       // Total em atual
       Val1 := StrToFloat(FrmMainTreeView.ChangeDecimalSeparator(Portfolio.GetValue(clStatus,Portfolio.Cells[0,K]),'.',','));
       Val2 := Val1 * Qtde;
       Portfolio.SetValue(clObj1,Portfolio.Cells[0,K], FormatFloat('0.00',Val2));

       // Somatoria geral em custodia atual
       Val3 := Val3 + Val2;

      // Zera para não ter erros
       Val1 := 0; Val2 := 0;

       // Lucro/Prejuizo R$
       Val1 := StrToFloat(FrmMainTreeView.ChangeDecimalSeparator(Portfolio.GetValue(clBaseIn,Portfolio.Cells[0,K]),'.',','));
       Val2 := StrToFloat(FrmMainTreeView.ChangeDecimalSeparator(Portfolio.GetValue(clObj1,Portfolio.Cells[0,K]),'.',','));
       ValTemp := Val2 - Val1;
       Portfolio.SetValue(clObj2,Portfolio.Cells[0,K], FormatFloat('0.00',ValTemp));

       // Somatoria Lucro/Prejuizo. Esta em () pq ValTemp pode ser negativo
       Val4 := Val4 + (ValTemp);

       // Lucro/Prejuizo %
       ValTemp := (ValTemp / Val1) * 100;
       //if(Val2 < Val1)then ValTemp:=ValTemp * -1;
       Portfolio.SetValue(clObj3,Portfolio.Cells[0,K], FormatFloat('0.00',ValTemp));

     end;

    except
      on E:Exception do
      FrmMainTreeView.Memo1.Lines.Add(E.Message);
    end;


  end;

  // Somatoria
  Label3.Caption:=FormatFloat('0.00',Val3);
  if(Val4 < 0)then Label4.Font.Color:=clRed else Label4.Font.Color:=clLime;
  Label4.Caption:=FormatFloat('0.00',Val4);
  end
  else
  begin
   Label3.Caption:='0.00';
   Label4.Caption:='0.00';
  end;

  try
    // Patrimonio Online
    Val1 := StrToFloat(FrmMainTreeView.ChangeDecimalSeparator(Label3.Caption,'.',','));
    Val2 := StrToFloat(FrmMainTreeView.ChangeDecimalSeparator(Label7.Caption,'.',','));
    Val3 := Val1 + Val2;
    Label10.Caption:=FormatFloat('0.00',Val3);
  except
    on E: Exception do
    FrmMainTreeView.Memo1.Lines.Add(E.Message);
  end;

  try
    // Saldo Projetado
    Val1 := StrToFloat(FrmMainTreeView.ChangeDecimalSeparator(Label6.Caption,'.',',')); // Saldo em conta
    Val2 := StrToFloat(FrmMainTreeView.ChangeDecimalSeparator(Label26.Caption,'.',',')); // Compras do Dia
    Val3 := StrToFloat(FrmMainTreeView.ChangeDecimalSeparator(Label28.Caption,'.',',')); //  Vendas do Dia
    Val4 := StrToFloat(FrmMainTreeView.ChangeDecimalSeparator(Label12.Caption,'.',',')) +
            StrToFloat(FrmMainTreeView.ChangeDecimalSeparator(Label18.Caption,'.',',')) +
            StrToFloat(FrmMainTreeView.ChangeDecimalSeparator(Label22.Caption,'.',',')); // Somatoria D+1 D+2 D+3

    ValTemp := (Val1 + Val3 + Val4) - Val2;
    Label7.Caption:=FormatFloat('0.00',ValTemp);
  except
   on E: Exception do
   FrmMainTreeView.Memo1.Lines.Add(E.Message);
  end;

  // Zera para não ter erros
 Val1 := 0; Val2 := 0;

 // Diferenca entre compra e vendas
 try
 Val1:=StrToFloatDef(FrmMainTreeView.ChangeDecimalSeparator(Label26.Caption,'.',','),0);
 Val2:=StrToFloatDef(FrmMainTreeView.ChangeDecimalSeparator(Label28.Caption,'.',','),0);
 ValTemp:=Val2-Val1;
 Label33.Caption:=FormatFloat('0.00',ValTemp);
 except
   on E: Exception do
   FrmMainTreeView.Memo1.Lines.Add(E.Message);
  end;

end;
end;

procedure TFrmPortfolio.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Calculator.Enabled:=False;
end;

procedure TFrmPortfolio.FormShow(Sender: TObject);
var Msg:String;
    MsgB : TBytes;
begin
 Randomize;
 Msg:='35=PV' + // Identificacao do Comando
         #1 +
         '5017=5' + // Tipo do comando
         #1 +
         '5262=1' +
         #1 +
         '5209=1' +
         #1 +
         '5019=' + FrmMainTreeView.MarketID +
         #1 +
         '45='+ IntToStr(Random(100)) +#1+ #3;

  FrmMainTreeView.Memo1.Lines.Add(Msg);

  MsgB:=FrmMainTreeView.StrToBytes(Msg);

  FrmMainTreeView.Broker.IOHandler.WriteDirect(MsgB);

  Calculator.Enabled:=True;

end;

end.
