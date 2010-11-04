unit UFrmTradeCentral;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, Sheet;

type
  TFrmCentral = class(TForm)
    CentralSheet: TSheet;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure AddSymbol( Symbol : String);
    procedure RecallSymbols;
  end;

var
  FrmCentral: TFrmCentral;

implementation

uses UFrmMainTreeView;

{$R *.dfm}

{ TFrmCentral }

procedure TFrmCentral.AddSymbol(Symbol: String);
begin
  CentralSheet.NewLine(Symbol);
  FrmMainTreeView.DaileonFW.IOHandler.WriteLn('sqt ' + LowerCase(Symbol));
  FrmMainTreeView.DaileonFW.IOHandler.WriteBufferFlush;
end;



procedure TFrmCentral.RecallSymbols;
var
  I: Integer;
begin
  if CentralSheet.RowCount >= 2 then
  begin
    for I := 1 to CentralSheet.RowCount do
    begin
      if(CentralSheet.Cells[0,I] <> '') then
      begin
        FrmMainTreeView.DaileonFW.IOHandler.WriteLn('sqt ' + CentralSheet.Cells[0,I]);
        FrmMainTreeView.DaileonFW.IOHandler.WriteBufferFlush;
      end;
    end;

  end;

end;

end.
