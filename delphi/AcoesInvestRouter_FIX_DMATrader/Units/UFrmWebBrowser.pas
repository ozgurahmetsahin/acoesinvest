unit UFrmWebBrowser;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ToolWin, ComCtrls, OleCtrls, SHDocVw, ImgList;

type
  TFrmWebBrowser = class(TForm)
    WebBrowser1: TWebBrowser;
    ImageList1: TImageList;
    procedure FormShow(Sender: TObject);
    procedure WebBrowser1DownloadComplete(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure CreateParams(var Params:TCreateParams);override;
  public
    { Public declarations }
    procedure SetSize( Height: Integer; Width : Integer);
  end;

var
  FrmWebBrowser: TFrmWebBrowser;

implementation

{$R *.dfm}

procedure TFrmWebBrowser.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle:= Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent:= GetDesktopWindow;
end;

procedure TFrmWebBrowser.FormShow(Sender: TObject);
begin
  WebBrowser1.Navigate('http://www.acoesinvest.com.br/servicos/acoes/agressivo.php');
end;

procedure TFrmWebBrowser.SetSize(Height, Width: Integer);
begin
  Self.Height:=Height;
  Self.Width:=Width;
end;

procedure TFrmWebBrowser.WebBrowser1DownloadComplete(Sender: TObject);
begin
  //Self.Caption:=WebBrowser1.LocationName + ' - WebBrowser Trading System';
end;

end.
