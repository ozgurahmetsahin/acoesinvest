unit UFrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UDataControl, StdCtrls, Buttons, ExtCtrls, pngimage;

type
  TFrmMain = class(TForm)
    Image1: TImage;
    BtnImgSheet: TImage;
    BtnImgBook: TImage;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure BtnImgSheetClick(Sender: TObject);
    procedure BtnImgBookClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

uses UConsts, UFrmConnectionControl, UFrmSheet, UFrmBook;

{$R *.dfm}

procedure TFrmMain.BtnImgBookClick(Sender: TObject);
begin
  FrmBook:=TFrmBook.Create(Self);
  FrmBook.Show;
end;

procedure TFrmMain.BtnImgSheetClick(Sender: TObject);
begin
  FrmSheet.Show;
end;

procedure TFrmMain.Button1Click(Sender: TObject);
begin
  FrmConnectionControl.Show;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  {Configura Caption do Form}
  Self.Caption:=SAppName + SSpace + SAppVersion
end;

end.
