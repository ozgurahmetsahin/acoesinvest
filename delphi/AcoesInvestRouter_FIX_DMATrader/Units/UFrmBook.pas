unit UFrmBook;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtCtrls, Grids, StdCtrls, Buttons, IdGlobal,
  Tabs, AppEvnts, IniFiles, ComCtrls;

type
  TFrmBook = class(TForm)
    Panel1: TPanel;
    StringGrid1: TStringGrid;
    TabSet1: TTabSet;
    Panel2: TPanel;
    Edit1: TEdit;
    BitBtn1: TBitBtn;
    CheckBox1: TCheckBox;
    StringGrid2: TStringGrid;
    StatusBar1: TStatusBar;
    Memo1: TMemo;
    Label1: TLabel;
    procedure Menu_ConnOnOffClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure TabSet1Change(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure CheckBox1Click(Sender: TObject);
    procedure ApplicationEvents1Exception(Sender: TObject; E: Exception);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    LTrade:Integer;
    LBook: Integer;
    ListBuy:TStringList;
    ListSell:TStringList;
    ListData:TStringList;
    FSymbol: String;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
    procedure NotConnected;
    procedure AddLine(Line, Direction, Value, Qty, Broker: String);
    procedure UpdateLine(NewLine, OldLine, Direction, Value, Qty, Broker: String);
    procedure DelLine(Line,Direction,DelType: String);
    procedure UpdateBuyers;
    procedure UpdateSellers;
    procedure UpdateRowCount;
  published
    property Symbol:String read FSymbol write FSymbol;
  end;
  {$M+}
  TBookThread = class(TThread)
   private
    FBook: TFrmBook;
   protected
    procedure Execute; override;
    procedure ShowIsRunning;
    function RemoveChar(Text : String;Char: Char):String;
   published
    property BookForm:TFrmBook read FBook;
   public
    constructor Create(ABook:TFrmBook); reintroduce;
  end;
  {$M-}

var
  FrmBook: TFrmBook;
  BookThread:TBookThread;
  CritSection:TRTLCriticalSection;

implementation

uses UThrdDaileonFwRead, UFrmMainTreeView;


{$R *.dfm}

procedure TFrmBook.FormCreate(Sender: TObject);
begin
 LTrade:=0;
 LBook:=0;

 ListBuy:=TStringList.Create;
 ListSell:=TStringList.Create;
 ListData:=TStringList.Create;

 Menu_ConnOnOffClick(Self);

 StringGrid2.Cells[0,0]:='�ltimo';
 StringGrid2.Cells[1,0]:='Osc.';
 StringGrid2.Cells[2,0]:='Compra';
 StringGrid2.Cells[3,0]:='Venda';
 StringGrid2.Cells[4,0]:='M�xima';
 StringGrid2.Cells[5,0]:='M�nima';
 StringGrid2.Cells[6,0]:='Abertura';
 StringGrid2.Cells[7,0]:='Fechamento';
 StringGrid2.Cells[8,0]:='Neg�cios';

 BookThread:=TBookThread.Create(Self);

 if ParamCount = 1 then
 begin
   Edit1.Text:= ParamStr(1);
   BitBtn1Click(Self);
 end;

end;

procedure TFrmBook.FormShow(Sender: TObject);
begin
  Edit1.SetFocus;
end;

procedure TFrmBook.Menu_ConnOnOffClick(Sender: TObject);
begin
 // Cria Thread de Conexao e configura as
 // propriedades.
 StringGrid1.Cells[0,0]:='Comprador';
 StringGrid1.Cells[1,0]:='Quantidade';
 StringGrid1.Cells[2,0]:='Pre�o';
 StringGrid1.Cells[3,0]:='Pre�o';
 StringGrid1.Cells[4,0]:='Quantidade';
 StringGrid1.Cells[5,0]:='Vendedor';
end;


procedure TFrmBook.NotConnected;
begin
  MessageDlg('N�o foi poss�vel solicitar os dados ao servidor.', mtError,[mbOk],0);
end;

procedure TFrmBook.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var BrokeRageFile : TIniFile;
    SplitBuyer:TStringList;
    SplitSeller:TStringList;
begin
 if ARow >=1 then
 begin

  if (ListBuy.Count > 0) and (ListSell.Count > 0) then
  begin
    SplitBuyer:=TStringList.Create;
    SplitSeller:=TStringList.Create;

    SplitColumns(ListBuy.Strings[ARow-1],SplitBuyer,':');
    SplitColumns(ListSell.Strings[ARow-1],SplitSeller,':');

    case ACol of
      0: if StringGrid1.Cells[ACol,ARow]<>SplitBuyer[3] then StringGrid1.Cells[ACol,ARow]:=SplitBuyer[3];
      1: if StringGrid1.Cells[ACol,ARow]<>SplitBuyer[2] then StringGrid1.Cells[ACol,ARow]:=SplitBuyer[2];
      2: if StringGrid1.Cells[ACol,ARow]<>SplitBuyer[1] then StringGrid1.Cells[ACol,ARow]:=SplitBuyer[1];
      3: if StringGrid1.Cells[ACol,ARow]<>SplitSeller[1] then StringGrid1.Cells[ACol,ARow]:=SplitSeller[1];
      4: if StringGrid1.Cells[ACol,ARow]<>SplitSeller[2] then StringGrid1.Cells[ACol,ARow]:=SplitSeller[2];
      5: if StringGrid1.Cells[ACol,ARow]<>SplitSeller[3] then StringGrid1.Cells[ACol,ARow]:=SplitSeller[3];
    end;

    FreeAndNil(SplitBuyer);
    FreeAndNil(SplitSeller);
  end;

  with StringGrid1.Canvas do
  begin
    if Odd(ARow) then
      Brush.Color:=RGB(234,255,255)
    else
      Brush.Color:=RGB(181,231,232);
   FillRect(Rect);
   Font:=StringGrid1.Font;
   Font.Style:=Font.Style + [fsBold];
   Font.Color:=clBlack;
   TextRect(Rect,Rect.Left + 3,Rect.Top + 3,StringGrid1.Cells[ACol,ARow]);

   if (ACol = 0 ) or ( ACol = 5 ) then
   begin
    BrokeRageFile:=TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'brokerages.ini');
    TextRect(Rect,Rect.Left + 3,Rect.Top + 3,BrokeRageFile.ReadString('brokerage',StringGrid1.Cells[ACol,ARow],''));
    BrokeRageFile.Free;
   end;

  end;


 end;
end;

procedure TFrmBook.TabSet1Change(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
begin
  case NewTab of
    0: StringGrid1.RowCount:=6;
    1: StringGrid1.RowCount:=11;
    2: StringGrid1.RowCount:=16;
    3: StringGrid1.RowCount:=5000;
  end;
end;


procedure TFrmBook.AddLine(Line, Direction, Value, Qty, Broker: String);
var DataLine:String;
begin
// EnterCriticalSection(CritSection);
 try
 Value:=FrmMainTreeView.ChangeDecimalSeparator(Value,'.',',');
 Value:=FormatFloat('0.00',StrToFloat(Value));

 DataLine:=Line+':'+Value+':'+Qty+':'+Broker;
 if Direction = 'A' then
 begin
   EnterCriticalSection(CritSection);
   ListBuy.Insert(StrToInt(Line), DataLine);
   LeaveCriticalSection(CritSection);
 end
 else
 begin
   EnterCriticalSection(CritSection);
   ListSell.Insert(StrToInt(Line),DataLine);
   LeaveCriticalSection(CritSection);
 end;
 except
   on E:Exception do
   begin
    LeaveCriticalSection(CritSection);
    Memo1.Lines.Add('Add:'+E.Message + ' Data:' + DataLine);
   end;
 end;
// LeaveCriticalSection(CritSection);
end;


procedure TFrmBook.UpdateBuyers;
var I:Integer;
    S:TStringList;
begin
  S:=TStringList.Create;
  for I := 0 to ListBuy.Count-1 do
  begin
    SplitColumns(ListBuy.Strings[I],S,':');
    StringGrid1.Cells[0,I+1]:=S[3];
    StringGrid1.Cells[1,I+1]:=S[2];
    StringGrid1.Cells[2,I+1]:=S[1];
  end;
  FreeAndNil(S);
end;

procedure TFrmBook.UpdateLine(NewLine, OldLine, Direction, Value, Qty, Broker: String);
var LO,LN:Integer;
     DataLine:String;
begin
 //  EnterCriticalSection(CritSection);
   Value:=FrmMainTreeView.ChangeDecimalSeparator(Value,'.',',');
    Value:=FormatFloat('0.00',StrToFloat(Value));
   DataLine:=NewLine+':'+Value+':'+Qty+':'+Broker;
   LN:=StrToInt(NewLine);
   LO:=StrToInt(OldLine);
  if Direction = 'A' then
  begin
    if LN <> LO then
    begin
      try
       try
        if ListBuy.Count > LO then
        begin
        EnterCriticalSection(CritSection);
        ListBuy.Delete(LO);
        LeaveCriticalSection(CritSection);
        end;
       except
         on E:Exception do
         begin
         LeaveCriticalSection(CritSection);
         Memo1.Lines.Add('Up:'+E.Message + ' Data:' + DataLine);
         end;
       end;
      finally
       EnterCriticalSection(CritSection);
       ListBuy.Insert(LN,DataLine);
       LeaveCriticalSection(CritSection);
      end;
    end
    else
    begin
      EnterCriticalSection(CritSection);
      ListBuy.Strings[LN]:=DataLine;
      LeaveCriticalSection(CritSection);
    end;
    end
  else
  begin
    if LN <> LO then
    begin
      try
       try
        if ListSell.Count > LO then
        begin
        EnterCriticalSection(CritSection);
        ListSell.Delete(LO);
        LeaveCriticalSection(CritSection);
        end;
       except
        on E:Exception do
         begin
         LeaveCriticalSection(CritSection);
         Memo1.Lines.Add('Up:'+E.Message + ' Data:' + DataLine);
         end;
       end;
      finally
       EnterCriticalSection(CritSection);
       ListSell.Insert(LN,DataLine);
       LeaveCriticalSection(CritSection);
      end;
    end
    else
    begin
      EnterCriticalSection(CritSection);
      ListSell.Strings[LN]:=DataLine;
      LeaveCriticalSection(CritSection);
    end;
  end;
// LeaveCriticalSection(CritSection);
end;

procedure TFrmBook.UpdateRowCount;
begin
  StringGrid1.Refresh;
end;

procedure TFrmBook.UpdateSellers;
var I:Integer;
    S:TStringList;
begin
  S:=TStringList.Create;
  for I := 0 to ListSell.Count-1 do
  begin
    SplitColumns(ListSell.Strings[I],S,':');
    StringGrid1.Cells[3,I+1]:=S[1];
    StringGrid1.Cells[4,I+1]:=S[2];
    StringGrid1.Cells[5,I+1]:=S[3];
  end;
  FreeAndNil(S);
end;

procedure TFrmBook.ApplicationEvents1Exception(Sender: TObject; E: Exception);
begin
 Abort;
end;

procedure TFrmBook.BitBtn1Click(Sender: TObject);
begin
 if Edit1.Text = 'showmeconn' then
 begin
   Edit1.Text:=FSymbol;
   exit;
 end else if Edit1.Text = 'showmecheck' then
 begin
   StatusBar1.Visible:=True;
   Edit1.Text:=FSymbol;
   exit;
 end else if Edit1.Text = 'closecheck' then
 begin
   StatusBar1.Visible:=False;
   Edit1.Text:=FSymbol;
   exit;
 end else if Edit1.Text = 'showmelog' then
 begin
   Memo1.Visible:=True;
   Edit1.Text:=FSymbol;
   exit;
 end else if Edit1.Text = 'closelog' then
 begin
   Memo1.Visible:=False;
   Edit1.Text:=FSymbol;
   exit;
 end;
 Symbol:=UpperCase(Edit1.Text);
 ListBuy.Clear;
 ListSell.Clear;
 SignalThread.WriteLn('sqt '+ Edit1.Text);
 SignalThread.WriteLn('bqt '+ Edit1.Text);
 Self.Caption:='Livro de Ofertas [' +  UpperCase(Edit1.Text) + ']';
end;

procedure TFrmBook.CheckBox1Click(Sender: TObject);
begin
 if CheckBox1.Checked then
 Self.FormStyle:=fsStayOnTop
 else
 Self.FormStyle:=fsNormal;
end;

procedure TFrmBook.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle:= Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent:= GetDesktopWindow;
end;

procedure TFrmBook.DelLine(Line,Direction,DelType: String);
var L:Integer;
begin
EnterCriticalSection(CritSection);
  try
  L:=StrToInt(Line);
  if Direction='A' then
  begin
    if ListBuy.Count >= L then
    begin
      ListBuy.Delete(L);
    end;
  end
  else
  begin
    if ListSell.Count >= L then
    begin
      ListSell.Delete(L);
    end;
  end;
  except
    on E:Exception do
    Memo1.Lines.Add('Del:'+E.Message);
  end;
  LeaveCriticalSection(CritSection);
end;


{ TBookThread }

constructor TBookThread.Create(ABook: TFrmBook);
begin
  FBook:=ABook;
  inherited Create(False);
end;

procedure TBookThread.Execute;
var Data:TStringList;
    Row,I:Integer;
    Line:String;
    IsUpdate:Boolean;
//    DataRead:TStringList;
begin
  Data:=TStringList.Create;
//  DataRead:=TStringList.Create;
  Row:=SignalThread.Data.Count-1;

  while not Terminated do
  begin
    IsUpdate:=False;

    while SignalThread.Data.Count > Row do
    begin
//      try
        try
          Line:=SignalThread.Data.Strings[Row];

          if Line = '' then exit;

//          Line:=RemoveChar(Line,'!');

//          FBook.Memo1.Lines.Add(Line);

          SplitColumns(Line, Data, ':');

          if (Data[0] <> 'B') And (Data[0]<>'T') then
          begin
            Sleep(100);
            Line:='';
            Data.Clear;
            Row:=Row+1;
            Continue;
          end;

          {Book}
          if (Data[0]='B') And (Data[1]=FBook.Symbol) then
          begin
            // Analisamos se � tipo A ( Adiciona )
//            EnterCriticalSection(CritSection);
            if(Data[2]='A')then
            FBook.AddLine(Data[3], Data[4], Data[5], Data[6], Data[7]);

            // Analisamos se � tipo U ( Atualiza )
            if(Data[2]='U')then
            FBook.UpdateLine(Data[3], Data[4],Data[5], Data[6], Data[7], Data[8]);

            // Analisamos se � tipo D ( Deleta )
            if(Data[2]='D')then
             if(Data[3] <> '3')then
             FBook.DelLine(Data[5], Data[4], Data[3]);

//             LeaveCriticalSection(CritSection);

            IsUpdate:=True;
          end;

          if (Data[0]='M') And (Data[1]=FBook.Symbol) then
          begin
            // Analisamos se � tipo A ( Adiciona )
//            EnterCriticalSection(CritSection);
            if(Data[2]='A')then
            FBook.AddLine(Data[3], Data[4], Data[5], Data[6], Data[7]);

            // Analisamos se � tipo U ( Atualiza )
            if(Data[2]='U')then
            FBook.UpdateLine(Data[3], Data[4],Data[5], Data[6], Data[7], Data[8]);

            // Analisamos se � tipo D ( Deleta )
            if(Data[2]='D')then
             if(Data[3] <> '3')then
             FBook.DelLine(Data[5], Data[4], Data[3]);

//             LeaveCriticalSection(CritSection);

            IsUpdate:=True;
          end;

          {Cota��o}
          if (Data[0] = 'T') And ( Data[1] = FBook.FSymbol) then
          begin
            for I:= 3 to Data.Count-1 do
            begin

              if Odd(I) then
              begin

                if Data[I] = '2' then
                FBook.StringGrid2.Cells[0,1]:=Data[I+1];

                if Data[I] = '700' then
                FBook.StringGrid2.Cells[1,1]:=Data[I+1];

                if Data[I] = '3' then
                FBook.StringGrid2.Cells[2,1]:=Data[I+1];

                if Data[I] = '4' then
                FBook.StringGrid2.Cells[3,1]:=Data[I+1];

                if Data[I] = '8' then
                FBook.StringGrid2.Cells[8,1]:=Data[I+1];

                if Data[I] = '11' then
                FBook.StringGrid2.Cells[4,1]:=Data[I+1];

                if Data[I] = '12' then
                FBook.StringGrid2.Cells[5,1]:=Data[I+1];

                if Data[I] = '13' then
                FBook.StringGrid2.Cells[7,1]:=Data[I+1];

                if Data[I] = '14' then
                FBook.StringGrid2.Cells[6,1]:=Data[I+1];

              end;

            end;

          end;
//        finally
          Data.Clear;
//          if FBook.Symbol<>'' then
//          begin
//            DataRead.Add(Line);
//            DataRead.SaveToFile('book_read'+FBook.Symbol+'.log');
//          end;
          Line:='';
          Row:=Row+1;
//        end;
      except
        on E:Exception do
        begin
          LeaveCriticalSection(CritSection);
          FBook.StatusBar1.Panels.Items[1].Text:=E.Message + ' ' + Line;
          Data.Clear;
          Line:='';
          Row:=Row+1;
        end;
      end;

    end;

    {Aguarda 100 milisegundos, sem isso o processo fica muito pesado,
    consumindo muito a CPU}
    Sleep(100);

    {Atualiza Lista}
    FBook.UpdateRowCount;

    Synchronize(ShowIsRunning);

    if Terminated then
    begin
      Data.Clear;
      Break;
    end;
  end;

  FBook.StatusBar1.Panels.Items[1].Text:='Finalizado';

end;

function TBookThread.RemoveChar(Text: String; Char: Char): String;
var
  I: Integer;
  R : String;
begin
  R:='';
  for I := 1 to Length(Text)  do
  begin
    if(Copy(Text,I,1) <> Char) then
    begin
      R:=R + Copy(Text,I,1);
    end;
  end;

  Result:=R;
end;

procedure TBookThread.ShowIsRunning;
begin
  FBook.StatusBar1.Panels.Items[0].Text:='�ltima verifica��o: ' + FormatDateTime('HH:MM:SS',Now) + ' hs';

  if SignalThread.Connection.Connected then
  FBook.StatusBar1.Panels.Items[1].Text:='Online'
  else
  FBook.StatusBar1.Panels.Items[1].Text:='Offline';

end;

initialization
  InitializeCriticalSection(CritSection);

finalization
  DeleteCriticalSection(CritSection);

end.
