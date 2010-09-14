unit UFrmMiniBook;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ExtCtrls,Sheet, StdCtrls, Buttons,IniFiles;

type
  TFrmMiniBook = class(TForm)
    StringGrid1: TStringGrid;
    Timer1: TTimer;
    Panel1: TPanel;
    Edit1: TEdit;
    Button1: TButton;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    CheckBox1: TCheckBox;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure StringGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Symbol: String;
    Editing : Boolean;
    procedure AddLine(Line, Direction, Value, Qty, Broker:String);
    procedure UpdateLine(Line, Direction, Value, Qty, Broker:String);
    procedure DelLine(Line,Direction, DelType:String);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  FrmMiniBook: TFrmMiniBook;

implementation

uses UFrmMainTreeView, UFrmTradeCentral, UFrmBrokerBuy, UFrmBrokerSell;

{$R *.dfm}

procedure TFrmMiniBook.AddLine(Line, Direction, Value, Qty, Broker: String);
var I, L:Integer;
begin
     L:=StrToInt(Line) + 1;
     //Compra ou venda
     if Direction = 'A' then
     begin
       //Manda tudo pra baixo
       for I := 5 downto L do
       begin
        Self.StringGrid1.Cells[1,I]:='++';
        Self.StringGrid1.Cells[2,I]:='++';
        Self.StringGrid1.Cells[0,I]:='++';
        Self.StringGrid1.Cells[1,I]:=Self.StringGrid1.Cells[1,I-1];
        Self.StringGrid1.Cells[2,I]:=Self.StringGrid1.Cells[2,I-1];
        Self.StringGrid1.Cells[0,I]:=Self.StringGrid1.Cells[0,I-1];
       end;

       //Compra
       Self.StringGrid1.Cells[1,L]:=Qty;
       Self.StringGrid1.Cells[2,L]:=Value;
       Self.StringGrid1.Cells[0,L]:=Broker;
     end
     else
     begin
      //Manda tudo pra baixo
       for I := 5 downto L do
       begin
        Self.StringGrid1.Cells[4,I]:='++';
        Self.StringGrid1.Cells[3,I]:='++';
        Self.StringGrid1.Cells[5,I]:='++';
        Self.StringGrid1.Cells[4,I]:=Self.StringGrid1.Cells[4,I-1];
        Self.StringGrid1.Cells[3,I]:=Self.StringGrid1.Cells[3,I-1];
        Self.StringGrid1.Cells[5,I]:=Self.StringGrid1.Cells[5,I-1];
       end;
       //Venda
       Self.StringGrid1.Cells[4,L]:=Qty;
       Self.StringGrid1.Cells[3,L]:=Value;
       Self.StringGrid1.Cells[5,L]:=Broker;
     end;
end;

procedure TFrmMiniBook.Button1Click(Sender: TObject);
var j:integer;
    s:String;
begin
  if Edit1.Text <> '' then
  begin
   s:=UpperCase( Edit1.Text);
//Se não existir na lista geral, adiciona
    try
      if(not FrmCentral.CentralSheet.FindQuote(s)) then
      FrmCentral.AddSymbol(s);

      Symbol:=s;

      FrmMainTreeView.DaileonFW.IOHandler.WriteLn('mbq ' + LowerCase(Symbol));
      Self.Caption:=Symbol;

      Timer1.Enabled:=True;

    except
      on E:EAccessViolation do
      begin
        FrmMainTreeView.MsgErr:='Não foi possível enviar a solicitação ao servidor.';
        FrmMainTreeView.ShowMsgErr;
      end;
    end;
  end;
end;

procedure TFrmMiniBook.CheckBox1Click(Sender: TObject);
begin
 if CheckBox1.Checked then
 Self.FormStyle:=fsStayOnTop
 else
 Self.FormStyle:=fsNormal;
end;

procedure TFrmMiniBook.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle:= Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent:= GetDesktopWindow;
end;

procedure TFrmMiniBook.DelLine(Line,Direction,DelType: String);
var I,L:Integer;
begin
//Somente ela ( tipo 1 )
     if DelType = '1' then
     begin
        //Linha cancelada
        L:= StrToInt(Line) + 1;

        //Compra ou venda
        if Direction = 'A' then
        begin

          //Limpa linha cancelada
          Self.StringGrid1.Cells[1,L]:='--';
          Self.StringGrid1.Cells[2,L]:='--';
          Self.StringGrid1.Cells[0,L]:='--';
          //Sobe tudo abaixo da cancelada
          for I := L+1 to 6 do
          begin
           Self.StringGrid1.Cells[1,I-1]:=Self.StringGrid1.Cells[1,I];
           Self.StringGrid1.Cells[2,I-1]:=Self.StringGrid1.Cells[2,I];
           Self.StringGrid1.Cells[0,I-1]:=Self.StringGrid1.Cells[0,I];
           Self.StringGrid1.Cells[1,I]:='-+';
           Self.StringGrid1.Cells[2,I]:='-+';
           Self.StringGrid1.Cells[0,I]:='-+';
          end;

        end
        else
        begin
          //Limpa linha cancelada
          Self.StringGrid1.Cells[4,L]:='--';
          Self.StringGrid1.Cells[3,L]:='--';
          Self.StringGrid1.Cells[5,L]:='--';
          //Sobe tudo abaixo da cancelada
          for I := L+1 to 6 do
          begin
           Self.StringGrid1.Cells[4,I-1]:=Self.StringGrid1.Cells[4,I];
           Self.StringGrid1.Cells[3,I-1]:=Self.StringGrid1.Cells[3,I];
           Self.StringGrid1.Cells[5,I-1]:=Self.StringGrid1.Cells[5,I];
           Self.StringGrid1.Cells[4,I]:='-+';
           Self.StringGrid1.Cells[3,I]:='-+';
           Self.StringGrid1.Cells[5,I]:='-+';
         end;

     end;
  end;
end;

procedure TFrmMiniBook.FormClose(Sender: TObject; var Action: TCloseAction);
var
  I: Integer;
begin
 for I := 1 to 20 do
 begin
   if (FrmMainTreeView.FrmsBooks[I] = Self ) then
   FrmMainTreeView.FrmsBooks[I]:=nil;
 end;
end;

procedure TFrmMiniBook.FormCreate(Sender: TObject);
begin
  StringGrid1.Cells[0,0]:= 'Comprador';
  StringGrid1.Cells[1,0]:= 'Qtde.';
  StringGrid1.Cells[2,0]:= 'Preço';
  StringGrid1.Cells[3,0]:= 'Preço';
  StringGrid1.Cells[4,0]:= 'Qtde.';
  StringGrid1.Cells[5,0]:= 'Vendedor';
end;

procedure TFrmMiniBook.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 case Key of
   116:
   begin
     FrmBrokerBuy.LabeledEdit1.Text:=Symbol;

     FrmBrokerBuy.LabeledEdit3.Text:=FrmBrokerBuy.ChangeDecimalSeparator(StringGrid1.Cells[3,1],'.',',');

     FrmBrokerBuy.LabeledEdit2.Text:=StringGrid1.Cells[1,1];

     FrmBrokerBuy.LabeledEdit3.Text:=FrmBrokerBuy.ChangeDecimalSeparator(StringGrid1.Cells[3,1],'.',',');

     FrmBrokerBuy.CalcTotal;

     FrmBrokerBuy.Label23.Caption:='';
     FrmBrokerBuy.Label22.Visible:=False;
     FrmBrokerBuy.Label23.Visible:=False;

     FrmBrokerBuy.Show;
   end;
   120:
   begin
     FrmBrokerSell.LabeledEdit1.Text:=Symbol;

     FrmBrokerSell.LabeledEdit3.Text:=FrmBrokerBuy.ChangeDecimalSeparator(StringGrid1.Cells[2,1],'.',',');

     FrmBrokerSell.LabeledEdit2.Text:=StringGrid1.Cells[4,1];

     FrmBrokerSell.LabeledEdit3.Text:=FrmBrokerBuy.ChangeDecimalSeparator(StringGrid1.Cells[2,1],'.',',');

     FrmBrokerSell.CalcTotal;

     FrmBrokerSell.Label23.Caption:='';
     FrmBrokerSell.Label22.Visible:=False;
     FrmBrokerSell.Label23.Visible:=False;

     FrmBrokerSell.Show;
   end;
 end;
end;

procedure TFrmMiniBook.StringGrid1DblClick(Sender: TObject);
begin

 if StringGrid1.Col >= 3  then
 begin
   //Compra
   FrmBrokerBuy.LabeledEdit1.Text:=Symbol;

   FrmBrokerBuy.LabeledEdit3.Text:=StringGrid1.Cells[3,StringGrid1.Row];

   FrmBrokerBuy.LabeledEdit2.Text:=StringGrid1.Cells[4,StringGrid1.Row];

   FrmBrokerBuy.LabeledEdit3.Text:=StringGrid1.Cells[3,StringGrid1.Row];

   FrmBrokerBuy.CalcTotal;

   FrmBrokerBuy.Label23.Caption:='';
   FrmBrokerBuy.Label22.Visible:=False;
   FrmBrokerBuy.Label23.Visible:=False;

   FrmBrokerBuy.Show;
 end
 else
 begin
     FrmBrokerSell.LabeledEdit1.Text:=Symbol;

     FrmBrokerSell.LabeledEdit3.Text:=StringGrid1.Cells[2,StringGrid1.Row];

     FrmBrokerSell.LabeledEdit2.Text:=StringGrid1.Cells[1,StringGrid1.Row];

     FrmBrokerSell.LabeledEdit3.Text:=StringGrid1.Cells[2,StringGrid1.Row];

     FrmBrokerSell.CalcTotal;

     FrmBrokerSell.Label23.Caption:='';
     FrmBrokerSell.Label22.Visible:=False;
     FrmBrokerSell.Label23.Visible:=False;

     FrmBrokerSell.Show;
 end;


end;

procedure TFrmMiniBook.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var BrokeRageFile : TIniFile;
begin
 if ARow > 0 then
 begin




   with StringGrid1.Canvas do
   begin
//     if Odd(ARow) then
//     Brush.Color:=$00400000
//     else
//     Brush.Color:=$00770000;
//     FillRect(Rect);
//     Font:=StringGrid1.Font;
//     Font.Style:=Font.Style + [fsBold];
//     Font.Color:=clWhite;
//     TextRect(Rect,Rect.Left + 3,Rect.Top + 3,StringGrid1.Cells[ACol,ARow]);


       case ARow of

         1 : Brush.Color:=RGB(241,234,180);
         2 : Brush.Color:=RGB(234,204,21);
         3 : Brush.Color:=RGB(140,213,43);
         4 : Brush.Color:=RGB(0,170,0);
         5 : Brush.Color:=RGB(132,193,255);

       end;


       FillRect(Rect);
     Font:=StringGrid1.Font;
     Font.Style:=Font.Style + [fsBold];
     Font.Color:=clBlack;
     TextRect(Rect,Rect.Left + 3,Rect.Top + 3,StringGrid1.Cells[ACol,ARow]);

     if (ACol = 0) or (Acol = 5) then
     begin

      if Symbol <> '' then
      begin
        BrokeRageFile:=TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'brokerages.ini');

        TextRect(Rect,Rect.Left + 3,Rect.Top + 3,BrokeRageFile.ReadString('brokerage',StringGrid1.Cells[ACol,ARow],'ERRO'));

        BrokeRageFile.Free;
      end;

     end;


   end;


 end;
end;

procedure TFrmMiniBook.StringGrid1KeyPress(Sender: TObject; var Key: Char);
begin
  Edit1.Text:=Key;
  Edit1.SetFocus;
  Edit1.SelStart:=Length(Edit1.Text);
end;

procedure TFrmMiniBook.Timer1Timer(Sender: TObject);
begin
try
  Self.Caption:='Livro ' + Symbol + ' [ Últ: ' +
  FrmCentral.CentralSheet.GetValue(clLast,Symbol) + ' ]';

  Label10.Caption:=FrmCentral.CentralSheet.GetValue(clLast,Symbol);

//  if FrmCentral.CentralSheet.GetValue(clStatus,Symbol) = 'W' then
//  begin
//    Label2.Font.Color:=clYellow;
//    Label2.Caption:='Aguarde';
//  end
//  else if FrmCentral.CentralSheet.GetValue(clStatus,Symbol) = 'B' then
//  begin
//    Label2.Font.Color:=clLime;
//    Label2.Caption:='Comprado';
//  end
//  else if FrmCentral.CentralSheet.GetValue(clStatus,Symbol) = 'S' then
//  begin
//    Label2.Font.Color:=clRed;
//    Label2.Caption:='Vendido';
//  end
//  else
//  begin
//    Label2.Font.Color:=clYellow;
//    Label2.Caption:='--';
//  end;

  if StrToFloat(FrmMainTreeView.ChangeDecimalSeparator(FrmCentral.CentralSheet.GetValue(clVar,Symbol)
  ,'.',',')) > 0 then
  begin
    Label4.Font.Color:=clLime;
    Label4.Caption:='+'+FrmCentral.CentralSheet.GetValue(clVar,Symbol);
  end
  else
  begin
    Label4.Font.Color:=clRed;
    Label4.Caption:=FrmCentral.CentralSheet.GetValue(clVar,Symbol);
  end;


  Label6.Caption:=FrmCentral.CentralSheet.GetValue(clMax,Symbol);
  Label8.Caption:=FrmCentral.CentralSheet.GetValue(clMin,Symbol);

except
  on E:Exception do
  Timer1.Enabled:=False;
end;

end;

procedure TFrmMiniBook.UpdateLine(Line, Direction, Value, Qty, Broker: String);
var L:Integer;
begin
     L:= StrToInt(Line) + 1;
     //Compra ou venda
     if Direction = 'A' then
     begin
       //Compra
       Self.StringGrid1.Cells[1,L]:=Qty;
       Self.StringGrid1.Cells[2,L]:=Value;
       Self.StringGrid1.Cells[0,L]:=Broker;
     end
     else
     begin
       //Venda
       Self.StringGrid1.Cells[4,L]:=Qty;
       Self.StringGrid1.Cells[3,L]:=Value;
       Self.StringGrid1.Cells[5,L]:=Broker;
     end;
end;

end.
