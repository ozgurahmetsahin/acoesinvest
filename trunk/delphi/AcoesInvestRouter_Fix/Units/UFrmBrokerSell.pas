unit UFrmBrokerSell;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrmBrokerBuy, ExtCtrls, StdCtrls, Buttons, ComCtrls;

type
  TFrmBrokerSell = class(TFrmBrokerBuy)
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmBrokerSell: TFrmBrokerSell;

implementation

{$R *.dfm}

procedure TFrmBrokerSell.FormShow(Sender: TObject);
begin
  inherited;
  LabeledEdit4.EditLabel.Caption:='';
end;

end.
