unit UFrmBrokerSpeed;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, pngimage, ExtCtrls, Grids, Buttons, Sheet,IniFiles;

type
  TFrmBrokerSpeed = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    CheckBox1: TCheckBox;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Panel1: TPanel;
    StringGrid1: TStringGrid;
    Timer1: TTimer;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    Panel2: TPanel;
    Label3: TLabel;
    procedure Timer1Timer(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    Symbol:String;
    procedure AddLine(Line, Direction, Value, Qty, Broker: String);
    procedure UpdateLine(Line, Direction, Value, Qty, Broker: String);
    procedure DelLine(Line,Direction,DelType: String);
  end;

var
  FrmBrokerSpeed: TFrmBrokerSpeed;

implementation

uses UFrmTradeCentral, UFrmMainTreeView;

{$R *.dfm}

procedure TFrmBrokerSpeed.CheckBox1Click(Sender: TObject);
begin
 // Muda estado dos campos de preços
 Edit5.ReadOnly:=CheckBox1.Checked;
 Edit7.ReadOnly:=CheckBox1.Checked;
end;

procedure TFrmBrokerSpeed.FormCreate(Sender: TObject);
begin
  StringGrid1.Cells[0,0]:= 'Comprador';
  StringGrid1.Cells[1,0]:= 'Qtde.';
  StringGrid1.Cells[2,0]:= 'Preço';
  StringGrid1.Cells[3,0]:= 'Preço';
  StringGrid1.Cells[4,0]:= 'Qtde.';
  StringGrid1.Cells[5,0]:= 'Vendedor';
end;

procedure TFrmBrokerSpeed.FormShow(Sender: TObject);
begin
 // Pega o código da conta e o nome do cliente
 Edit2.Text:=FrmMainTreeView.MarketID;
 Edit3.Text:=FrmMainTreeView.ClientName;
end;

procedure TFrmBrokerSpeed.SpeedButton1Click(Sender: TObject);
begin
  // Tenta solicitar os dados
  try
    // Se tiver vazio não faz nada
    if(Edit1.Text='')then
    exit;

    // Adiciona o ativo na variavel Symbol, convertendo em
    // maiuscula
    Symbol:=UpperCase(Edit1.Text);

    // Conferne na planilha central se já não existe tal ativo
    // se nao exister, adiciona
    if(not FrmCentral.CentralSheet.FindQuote(Symbol))then
    FrmCentral.AddSymbol(Symbol);

    // Realiza chamada do ativo
    FrmMainTreeView.DaileonFW.IOHandler.WriteLn('sqt ' + Symbol);
    FrmMainTreeView.DaileonFW.IOHandler.WriteLn('mbq ' + Symbol);
  except on E: Exception do
    FrmMainTreeView.AddLogMsg('Erro ao adicionar ativo à boleta speed:'+E.Message);
  end;
end;

procedure TFrmBrokerSpeed.SpeedButton2Click(Sender: TObject);
var MsgOrderBuy:String;
    MsgOrderBuyBytes:TBytes;
    Value, Price,Dif, Range1: Double;
begin

// Valor atual da cotação
     Value:=StrToFloat(FrmMainTreeView.ChangeDecimalSeparator(FrmCentral.CentralSheet.GetValue(clLast,Symbol),'.',','));

     // Calcula diferencia porcentagem
     Dif:= Value * 0.10;

     // Calcula os Ranges
     Range1:= Value - Dif;

     // Verifica se o preco da ordem esta entre os Ranges
     Price:=StrToFloat(FrmMainTreeView.ChangeDecimalSeparator(Edit5.Text,'.',','));

     if( Price < Range1 ) then
     begin
       Label3.Caption:='Sua ordem está fora do padrão de mercado.';
       exit;
     end;

MsgOrderBuy:=
         '35=OR' + // Identificacao do Comando
         #1 +
         '5017=0' + // Tipo do comando
         #1 ;
         MsgOrderBuy:=MsgOrderBuy + '54=2'; // Direcao da Ordem : 1 - Compra, 2 - Venda
         MsgOrderBuy:=MsgOrderBuy +
         #1 +
         '117=' + Symbol + //  Codigo do Ativo
         #1 +
         '53=' +  Edit4.Text + // Quantidade a ser comprada ou vendida
         #1 +
         '44=' + FrmMainTreeView.ChangeDecimalSeparator( Edit5.Text,',','.' )  +  //  Preço Limite
         #1 +
         '5018=0' + // Tipo Validade: 0 - Hoje, 1 - Ate Cancelar, 2 - Dta Espec., 3 - Tudo ou Nada, 4 - Executa ou Cancela
         #1 +
         '5019='+ FrmMainTreeView.MarketID + // Codigo da conta
         #1 +
         '5020=0' + // Tipo de preço: 0 - Preço Limite
         #1;


 MsgOrderBuy:=MsgOrderBuy + #3;

 MsgOrderBuyBytes:=FrmMainTreeView.StrToBytes(MsgOrderBuy);

 FrmMainTreeView.LabelReturn:=Label3;

 FrmMainTreeView.Memo1.Lines.Add(MsgOrderBuy);

 FrmMainTreeView.Broker.IOHandler.WriteBufferClear;
 FrmMainTreeView.Broker.IOHandler.WriteDirect(MsgOrderBuyBytes);
 FrmMainTreeView.Broker.IOHandler.WriteBufferFlush;
end;

procedure TFrmBrokerSpeed.SpeedButton3Click(Sender: TObject);
var MsgOrderBuy:String;
    MsgOrderBuyBytes:TBytes;
begin
MsgOrderBuy:=
         '35=OR' + // Identificacao do Comando
         #1 +
         '5017=0' + // Tipo do comando
         #1 ;
         MsgOrderBuy:=MsgOrderBuy + '54=1'; // Direcao da Ordem : 1 - Compra, 2 - Venda
         MsgOrderBuy:=MsgOrderBuy +
         #1 +
         '117=' + Symbol + //  Codigo do Ativo
         #1 +
         '53=' +  Edit6.Text + // Quantidade a ser comprada ou vendida
         #1 +
         '44=' + FrmMainTreeView.ChangeDecimalSeparator( Edit7.Text,',','.' )  +  //  Preço Limite
         #1 +
         '5018=0' + // Tipo Validade: 0 - Hoje, 1 - Ate Cancelar, 2 - Dta Espec., 3 - Tudo ou Nada, 4 - Executa ou Cancela
         #1 +
         '5019='+ FrmMainTreeView.MarketID + // Codigo da conta
         #1 +
         '5020=0' + // Tipo de preço: 0 - Preço Limite
         #1;


 MsgOrderBuy:=MsgOrderBuy + #3;

 MsgOrderBuyBytes:=FrmMainTreeView.StrToBytes(MsgOrderBuy);

 FrmMainTreeView.LabelReturn:=Label3;

 FrmMainTreeView.Memo1.Lines.Add(MsgOrderBuy);

 FrmMainTreeView.Broker.IOHandler.WriteBufferClear;
 FrmMainTreeView.Broker.IOHandler.WriteDirect(MsgOrderBuyBytes);
 FrmMainTreeView.Broker.IOHandler.WriteBufferFlush;

end;

procedure TFrmBrokerSpeed.StringGrid1Click(Sender: TObject);
var n:Integer;
begin
 if StringGrid1.Col >= 3  then
 begin
   //Compra
   Edit4.Text:=StringGrid1.Cells[4,StringGrid1.Row];

   if(Copy(Edit4.Text,Length(Edit4.Text),1) = 'k')then
   begin
     n:=StrToInt(Copy(Edit4.Text,1,Length(Edit4.Text)-1));
     n:=n*1000;
     Edit4.Text:=IntToStr(n);
   end;

   Edit5.Text:=StringGrid1.Cells[3,StringGrid1.Row];
 end
 else
 begin
     Edit6.Text:=StringGrid1.Cells[1,StringGrid1.Row];
     if(Copy(Edit6.Text,Length(Edit6.Text),1) = 'k')then
     begin
       n:=StrToInt(Copy(Edit6.Text,1,Length(Edit6.Text)-1));
       n:=n*1000;
       Edit6.Text:=IntToStr(n);
     end;
     Edit7.Text:=StringGrid1.Cells[2,StringGrid1.Row];
 end;
end;

procedure TFrmBrokerSpeed.StringGrid1DrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
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

procedure TFrmBrokerSpeed.Timer1Timer(Sender: TObject);
begin
  // Tenta obter os dados
  try
    // Se tiver ativo
    if(Symbol <> '') then
    begin
      // Pega o valor do último
      Label1.Caption:=FrmCentral.CentralSheet.GetValue(clLast,Symbol);

      // Se chekbox estiver ativo, pega o valor da boleta
      if(CheckBox1.State=cbChecked)then
      begin
        // Preco de compra ( Melhor valor de venda)
        Edit7.Text:=StringGrid1.Cells[3,1];

        // Preco de venda ( Melhor valor de compra)
        Edit5.Text:=StringGrid1.Cells[2,1];
      end;
    end;

  except on E: Exception do
    FrmMainTreeView.AddLogMsg('Erro ao obter dados para boleta speed:' + E.Message);
  end;
end;

procedure TFrmBrokerSpeed.AddLine(Line, Direction, Value, Qty, Broker: String);
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

procedure TFrmBrokerSpeed.UpdateLine(Line, Direction, Value, Qty, Broker: String);
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

procedure TFrmBrokerSpeed.DelLine(Line,Direction,DelType: String);
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

procedure TFrmBrokerSpeed.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
 if Key = #13 then
 begin
   SpeedButton1Click(Self);
 end;
end;

end.
