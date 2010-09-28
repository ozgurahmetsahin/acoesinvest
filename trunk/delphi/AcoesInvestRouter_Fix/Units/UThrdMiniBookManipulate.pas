unit UThrdMiniBookManipulate;

interface

uses
  Classes,IdGlobal,SysUtils;

type
  TThrdMiniBookManipulate = class(TThread)
  private
    { Private declarations }
    procedure SynchBook;
  public
    DataMBook:String;
  protected
    procedure Execute; override;
  end;

implementation

{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure ThrdMiniBookManipulate.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ ThrdMiniBookManipulate }

uses UFrmMiniBook,UFrmMainTreeView;

procedure TThrdMiniBookManipulate.Execute;
begin
  { Place thread code here }
  SynchBook;
end;

procedure TThrdMiniBookManipulate.SynchBook;
var SplitData:TStringList;
    Line : Integer;
  I: Integer;
  K: Integer;
  Form : TFrmMiniBook;
begin

try

  { Place thread code here }

  SplitData:=TStringList.Create;

  SplitColumns(DataMBook,SplitData,':');

   for K := 1 to 20 do
   begin
    if Assigned(FrmMainTreeView.FrmsBooks[K]) then
    begin
      if FrmMainTreeView.FrmsBooks[K].Symbol = SplitData[1] then
      begin
        Form := FrmMainTreeView.FrmsBooks[K];
        break;
      end;
   end;
  end;

  if Assigned(Form) then
  begin

  //Adiciona
  if SplitData[2] = 'A' then
  begin
     //Linha
     Line:= StrToInt(SplitData[3]) + 1;

     //Compra ou venda
     if SplitData[4] = 'A' then
     begin
       //Manda tudo pra baixo
       for I := 5 downto 1 do
       begin
        Form.StringGrid1.Cells[1,Line]:=SplitData[6];
        Form.StringGrid1.Cells[2,Line]:=SplitData[5];
        Form.StringGrid1.Cells[0,Line]:=SplitData[7];
       end;

       //Compra
       Form.StringGrid1.Cells[1,Line]:=SplitData[6];
       Form.StringGrid1.Cells[2,Line]:=SplitData[5];
       Form.StringGrid1.Cells[0,Line]:=SplitData[7];
     end
     else
     begin
       //Venda
       Form.StringGrid1.Cells[4,Line]:=SplitData[6];
       Form.StringGrid1.Cells[3,Line]:=SplitData[5];
       Form.StringGrid1.Cells[5,Line]:=SplitData[7];
     end;
  end;

  //Atualiza
  if SplitData[2] = 'U' then
  begin
     Line:= StrToInt(SplitData[3]) + 1;

     //Compra ou venda
     if SplitData[5] = 'A' then
     begin
       //Compra
       Form.StringGrid1.Cells[1,Line]:=SplitData[7];
       Form.StringGrid1.Cells[2,Line]:=SplitData[6];
       Form.StringGrid1.Cells[0,Line]:=SplitData[8];
     end
     else
     begin
       //Venda
       Form.StringGrid1.Cells[4,Line]:=SplitData[7];
       Form.StringGrid1.Cells[3,Line]:=SplitData[6];
       Form.StringGrid1.Cells[5,Line]:=SplitData[8];
     end;
  end;

  //Deleta
  if SplitData[2] = 'D' then
  begin
     //Somente ela ( tipo 1 )
     if SplitData[3] = '1' then
     begin
        //Linha cancelada
        Line:= StrToInt(SplitData[5]) + 1;

        //Compra ou venda
        if SplitData[4] = 'A' then
        begin

          //Limpa linha cancelada
          Form.StringGrid1.Cells[1,Line]:='';
          Form.StringGrid1.Cells[2,Line]:='';
          Form.StringGrid1.Cells[0,Line]:='';



          //Sobe tudo abaixo da cancelada
          for I := Line+1 to 6 do
          begin
           Form.StringGrid1.Cells[1,I-1]:=FrmMiniBook.StringGrid1.Cells[1,I];
           Form.StringGrid1.Cells[2,I-1]:=FrmMiniBook.StringGrid1.Cells[2,I];
           Form.StringGrid1.Cells[0,I-1]:=FrmMiniBook.StringGrid1.Cells[0,I];
           Form.StringGrid1.Cells[1,I]:='';
           Form.StringGrid1.Cells[2,I]:='';
           Form.StringGrid1.Cells[0,I]:='';
          end;

        end
        else
        begin
          //Limpa linha cancelada
          Form.StringGrid1.Cells[4,Line]:='';
          Form.StringGrid1.Cells[3,Line]:='';
          Form.StringGrid1.Cells[5,Line]:='';



          //Sobe tudo abaixo da cancelada
          for I := Line+1 to 6 do
          begin
           Form.StringGrid1.Cells[4,I-1]:=FrmMiniBook.StringGrid1.Cells[4,I];
           Form.StringGrid1.Cells[3,I-1]:=FrmMiniBook.StringGrid1.Cells[3,I];
           Form.StringGrid1.Cells[5,I-1]:=FrmMiniBook.StringGrid1.Cells[5,I];
           Form.StringGrid1.Cells[4,I]:='';
           Form.StringGrid1.Cells[3,I]:='';
           Form.StringGrid1.Cells[5,I]:='';
         end;

     end;
  end;
  end;
  end;
finally
  //
end;
end;

end.
