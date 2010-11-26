unit UFrmBrokerageNote;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TFrmBrokerageNote = class(TForm)
    BitBtn1: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmBrokerageNote: TFrmBrokerageNote;

implementation
  uses UFrmMainTreeView;
{$R *.dfm}

procedure TFrmBrokerageNote.BitBtn1Click(Sender: TObject);
var MsgNote: String;
    BMsgNote : TBytes;
begin
  MsgNote:='35=FBN' + #1 + '5017=1' + #1 + '45=7985' + #1 +
            '5019=' + FrmMainTreeView.MarketID + #1 +
            '5209=1' + #1 + #3;
  FrmMainTreeView.Memo1.Lines.Add(MsgNote);

  BMsgNote:=FrmMainTreeView.StrToBytes(MsgNote);

  FrmMainTreeView.Broker.IOHandler.WriteDirect(BMsgNote);
  FrmMainTreeView.Broker.IOHandler.WriteBufferFlush;
end;

end.
