unit UFrmConfirmSendOrder;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, URouterLibrary, UFrmDefault;

type
  TfrmConfirmOrderBeforeSend = class(TFrmDefault)
    Panel1: TPanel;
    Label1: TLabel;
    Shape1: TShape;
    Label2: TLabel;
    lblClientAccount: TLabel;
    lblClientName: TLabel;
    Label5: TLabel;
    lblSymbol: TLabel;
    Label7: TLabel;
    lblQuantity: TLabel;
    Label9: TLabel;
    lblPrice: TLabel;
    Label11: TLabel;
    lblValidity: TLabel;
    Label13: TLabel;
    lblInformations: TLabel;
    Shape2: TShape;
    Shape3: TShape;
    Button1: TButton;
    Button2: TButton;
    Label15: TLabel;
    lblOrderDirection: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
    function ConfirmOrder(ClientAccount, ClientName, Symbol, Quantity, Price: String;
    Direction:TDirectionOrderFix; Validity:TValidityOrderFix; UntilDate:TDate; Informations:String):Integer;
  end;

var
  frmConfirmOrderBeforeSend: TfrmConfirmOrderBeforeSend;

implementation

{$R *.dfm}

{ TForm1 }

function TfrmConfirmOrderBeforeSend.ConfirmOrder(ClientAccount, ClientName, Symbol, Quantity,
  Price: String; Direction: TDirectionOrderFix; Validity: TValidityOrderFix;  UntilDate:TDate;
  Informations: String): Integer;
begin
  // Configura dados
  lblClientAccount.Caption:=ClientAccount;
  lblClientName.Caption:=ClientName;
  lblSymbol.Caption:= Symbol;
  lblQuantity.Caption:=Quantity;
  lblPrice.Caption:=Price;

  if Direction = dcBuy then
  lblOrderDirection.Caption:='Compra'
  else if Direction = dcSell then
       lblOrderDirection.Caption:='Venda';

  case Validity of
    vdToday: lblValidity.Caption:='Dia';
    vdGoodTillCancel: lblValidity.Caption:='Até Cancelar';
    vdParcExecOrCancel: lblValidity.Caption:='Exec. Parc. ou Cancela';
    vdExecOrCancel: lblValidity.Caption:='Exec. ou Canc.';
    vdGoodTillDate: lblValidity.Caption:=FormatDateTime('dd/mm/yyyy', UntilDate);
  end;

  lblInformations.Caption:=Informations;

  // Exibe
  Result:= Self.ShowModal;

end;

end.
