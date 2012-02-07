unit UFrmMainBar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, pngimage, ExtCtrls, JvExControls, JvLED, URouterLibrary, UFrmDefault;

type
  TfrmMainBar = class(TFrmDefault)
    imgMainBar: TImage;
    ledFix: TJvLED;
    imgSendOrderBuy: TImage;
    imgSendOrderSell: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure imgSendOrderBuyClick(Sender: TObject);
    procedure imgSendOrderSellClick(Sender: TObject);
  private
    { Private declarations }
    procedure SendOrderBuy;
    procedure SendOrderSell;
  public
    { Public declarations }
  end;

var
  frmMainBar: TfrmMainBar;

implementation

uses UFrmSendOrders;

{$R *.dfm}

procedure TfrmMainBar.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

procedure TfrmMainBar.imgSendOrderBuyClick(Sender: TObject);
begin
  SendOrderBuy;
end;

procedure TfrmMainBar.imgSendOrderSellClick(Sender: TObject);
begin
  SendOrderSell;
end;

procedure TfrmMainBar.SendOrderBuy;
var F:TfrmSendOrders;
begin
   // Abre uma boleta de Compra
   F:=TfrmSendOrders.Create(Application);
   F.ConnCenter:= Self.ConnCenter;
   F.OrderDirection:= dcBuy;
   F.Show;
end;

procedure TfrmMainBar.SendOrderSell;
var F:TfrmSendOrders;
begin
   // Abre uma boleta de Venda
   F:=TfrmSendOrders.Create(Application);
   F.ConnCenter:= Self.ConnCenter;
   F.OrderDirection:= dcSell;
   F.Show;
end;

end.
