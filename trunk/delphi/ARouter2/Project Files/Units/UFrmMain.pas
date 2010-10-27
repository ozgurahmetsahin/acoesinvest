unit UFrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UDataControl, StdCtrls, Buttons;

type
  TFrmMain = class(TForm)
    BitBtn1: TBitBtn;
    Memo1: TMemo;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

uses UConsts, UFrmConnectionControl, UFrmSheet;

{$R *.dfm}

procedure TFrmMain.BitBtn1Click(Sender: TObject);
begin
  FrmConnectionControl.Show;
end;

procedure TFrmMain.Button1Click(Sender: TObject);
begin
 FrmSheet.Show;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  {Configura Caption do Form}
  Self.Caption:=SAppName + SSpace + SAppVersion
end;

end.
