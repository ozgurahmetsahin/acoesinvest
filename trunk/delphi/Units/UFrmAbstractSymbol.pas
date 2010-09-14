unit UFrmAbstractSymbol;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls,Sheet, Grids;

type
  TFrmAbstractSymbol = class(TForm)
    StringGrid1: TStringGrid;
    TimerUpdate: TTimer;
    Panel1: TPanel;
    Edit1: TEdit;
    Button1: TButton;
    procedure TimerUpdateTimer(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure StringGrid1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  protected
    procedure CreateParams(var Params:TCreateParams);  override;
  public
    { Public declarations }
    Symbol : String;
  end;

var
  FrmAbstractSymbol: TFrmAbstractSymbol;

implementation

uses UFrmTradeCentral, UFrmMainTreeView;

{$R *.dfm}

procedure TFrmAbstractSymbol.Button1Click(Sender: TObject);
var s:String;
begin
s:=UpperCase(Edit1.Text);
//Se não existir na lista geral, adiciona
    try
      if(not FrmCentral.CentralSheet.FindQuote(s)) then
      FrmCentral.AddSymbol(s);
      TimerUpdate.Enabled:=True;
      Symbol:=s;
      Self.Caption:='Resumo ' + Symbol;
    except
      on E:EAccessViolation do
      begin
        FrmMainTreeView.MsgErr:='Não foi possível enviar a solicitação ao servidor.';
        FrmMainTreeView.ShowMsgErr;
      end;
    end;
end;

procedure TFrmAbstractSymbol.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle:= Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent:= GetDesktopWindow;
end;

procedure TFrmAbstractSymbol.FormShow(Sender: TObject);
begin
  StringGrid1.Cells[0,0]:='Últ.';

  StringGrid1.Cells[2,0]:='Osc.';

  StringGrid1.Cells[0,1]:='Máx.';

  StringGrid1.Cells[2,1]:='Mín.';

  StringGrid1.Cells[0,2]:='Aber.';

  StringGrid1.Cells[2,2]:='Fech.';

  StringGrid1.Cells[0,3]:='Osc Sem.';

  StringGrid1.Cells[2,3]:='Osc Mês.';

  StringGrid1.Cells[0,4]:='Osc Ano.';

  //StringGrid1.Cells[2,4]:='Status.';

end;

procedure TFrmAbstractSymbol.StringGrid1DrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
with StringGrid1.Canvas do
   begin
     if Odd(ARow) then
     Brush.Color:=$00400000
     else
     Brush.Color:=$00770000;
     FillRect(Rect);
     Font:=StringGrid1.Font;
     Font.Style:=Font.Style + [fsBold];
     Font.Color:=clWhite;
     TextRect(Rect,Rect.Left + 3,Rect.Top + 3,StringGrid1.Cells[ACol,ARow]);
   end;
end;

procedure TFrmAbstractSymbol.StringGrid1KeyPress(Sender: TObject;
  var Key: Char);
begin
  Edit1.Text:=Key;
  Edit1.SetFocus;
  Edit1.SelStart:=Length(Edit1.Text);
end;

procedure TFrmAbstractSymbol.TimerUpdateTimer(Sender: TObject);
begin
  {Label14.Caption:= FrmCentral.CentralSheet.GetValue(clLast,Symbol);
  Label15.Caption:= FrmCentral.CentralSheet.GetValue(clMax,Symbol);
  Label16.Caption:= FrmCentral.CentralSheet.GetValue(clMin,Symbol);
  Label17.Caption:= FrmCentral.CentralSheet.GetValue(clOpen,Symbol);
  Label18.Caption:= FrmCentral.CentralSheet.GetValue(clClose,Symbol);
  Label19.Caption:= FrmCentral.CentralSheet.GetValue(clNeg,Symbol);
  Label20.Caption:= FrmCentral.CentralSheet.GetValue(clVar,Symbol);
  Label21.Caption:= FrmCentral.CentralSheet.GetValue(clVarWeek,Symbol);
  Label22.Caption:= FrmCentral.CentralSheet.GetValue(clVarMonth,Symbol);
  Label23.Caption:= FrmCentral.CentralSheet.GetValue(clVarYear,Symbol);}


  StringGrid1.Cells[1,0]:=FrmCentral.CentralSheet.GetValue(clLast,Symbol);
  StringGrid1.Cells[3,0]:=FrmCentral.CentralSheet.GetValue(clVar,Symbol);
  StringGrid1.Cells[1,1]:=FrmCentral.CentralSheet.GetValue(clMax,Symbol);
  StringGrid1.Cells[3,1]:=FrmCentral.CentralSheet.GetValue(clMin,Symbol);
  StringGrid1.Cells[1,2]:=FrmCentral.CentralSheet.GetValue(clOpen,Symbol);
  StringGrid1.Cells[3,2]:=FrmCentral.CentralSheet.GetValue(clClose,Symbol);
  StringGrid1.Cells[1,3]:=FrmCentral.CentralSheet.GetValue(clVarWeek,Symbol);
  StringGrid1.Cells[3,3]:=FrmCentral.CentralSheet.GetValue(clVarMonth,Symbol);
  StringGrid1.Cells[1,4]:=FrmCentral.CentralSheet.GetValue(clVarYear,Symbol);
  {if (FrmCentral.CentralSheet.GetValue(clStatus,Symbol) = 'W')then
  StringGrid1.Cells[3,4]:='Aguarde'
  else if FrmCentral.CentralSheet.GetValue(clStatus,Symbol) = 'B' then
  StringGrid1.Cells[3,4]:='Comprado'
  else StringGrid1.Cells[3,4]:='Vendido';}

end;

end.
