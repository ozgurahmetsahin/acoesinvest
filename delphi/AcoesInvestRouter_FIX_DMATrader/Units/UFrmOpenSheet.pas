
{$WARNINGS ON}
{$HINTS ON}
{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
unit UFrmOpenSheet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, FileCtrl;

type
  TFrmOpenSheet = class(TForm)
    FileListBox1: TFileListBox;
    Panel1: TPanel;
    btnOpen: TBitBtn;
    btnCancel: TBitBtn;
    btnDelete: TBitBtn;
    procedure btnOpenClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure FileListBox1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmOpenSheet: TFrmOpenSheet;

implementation

uses UFrmSheet;

{$R *.dfm}

procedure TFrmOpenSheet.btnOpenClick(Sender: TObject);
begin
  FrmSheet.Load(FileListBox1.FileName);
  Self.Close;
end;

procedure TFrmOpenSheet.btnCancelClick(Sender: TObject);
begin
 Self.Close;
end;

procedure TFrmOpenSheet.btnDeleteClick(Sender: TObject);
begin
 if FrmSheet.SheetName <> ExtractFileName(FileListBox1.FileName) then
 DeleteFile(FileListBox1.FileName)
 else
 MessageDlg('Esta planilha está atualmente aberta.', mtInformation, [mbOk], 0);

 FileListBox1.Update;
end;

procedure TFrmOpenSheet.FileListBox1DblClick(Sender: TObject);
begin
 if FileListBox1.SelCount=1 then
 btnOpenClick(Self);
end;

end.
