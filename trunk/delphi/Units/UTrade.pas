unit UTrade;

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Grids, Forms;


{Objeto para manipulação das cotações}
type TTrade = class(TObject)
  FData:TStringList;
  FSheet:TStringGrid;
  private
  public
   constructor Create(Data:TStringList);
   procedure UpdateSheetCell(Sheet:TStringGrid); overload;
   procedure UpdateSheetCell(Sheet:TStringGrid; AutoFree:Boolean); overload;
   procedure UpdateSheetCell(); overload;
   procedure SetSheet(Sheet:TStringGrid);
end;

implementation
  uses UMain, UMsgs;
{ TTrade }

constructor TTrade.Create(Data: TStringList);
begin
  FData:=Data;
end;

procedure TTrade.UpdateSheetCell(Sheet: TStringGrid);
begin
  UpdateSheetCell(Sheet,True);
end;

procedure TTrade.UpdateSheetCell(Sheet: TStringGrid; AutoFree: Boolean);
var
  Row: Integer;
  Index: Integer;
begin
  { TODO : Fazer try? }
 {Atualiza uma planilha}

 if(not Assigned(FData)) or (FData.Count <= 1) then
 begin
   Self.Free;
   exit;
 end;

 for Row := 0 to Sheet.RowCount - 1 do
 begin
   {Procura pelo ativo}
   if(Sheet.Cells[0, Row]=FData[1])then
   begin
     {Varre pelos indices}
     {Lembrete: Indices estão nos campos impares do vetor}
     for Index := 3 to FData.Count - 1 do
     begin
      if(Index mod 2<>0)then
      begin
       {Último Valor}
       if(FData[Index]='2')then
       begin
         Sheet.Cells[1,Row]:=FData[Index+1];
       end;
       {Oscilacao}
       if(FData[Index]='664')or(FData[Index]='700') then
       begin
         Sheet.Cells[2,Row]:=FData[Index+1];
       end;
       {Melhor Compra}
       if(FData[Index]='3')then
       begin
         Sheet.Cells[3,Row]:=FData[Index+1];
       end;
       {Melhor Venda}
       if(FData[Index]='4')then
       begin
         Sheet.Cells[4,Row]:=FData[Index+1];
       end;
       {Máxima}
       if(FData[Index]='11')then
       begin
         Sheet.Cells[5,Row]:=FData[Index+1];
       end;
       {Mínima}
       if(FData[Index]='12')then
       begin
         Sheet.Cells[6,Row]:=FData[Index+1];
       end;
       {Abertura}
       if(FData[Index]='14')then
       begin
         Sheet.Cells[7,Row]:=FData[Index+1];
       end;
       {Fechamento}
       if(FData[Index]='13')then
       begin
         Sheet.Cells[8,Row]:=FData[Index+1];
       end;
       {Número de Negocios}
       if(FData[Index]='8')then
       begin
         Sheet.Cells[9,Row]:=FData[Index+1];
       end;
      end;// if mod 2
     end; // for FData
   end; // if fdata[0]
 end; // for Row Sheet

 {se auto free}
 if(AutoFree)then
 Self.Free;

end;

procedure TTrade.SetSheet(Sheet: TStringGrid);
begin
 FSheet:=Sheet;
end;

procedure TTrade.UpdateSheetCell;
begin
 if Assigned(FSheet) then
 UpdateSheetCell(FSheet);
end;

end.
