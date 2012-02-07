unit UFrmBook;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, UFrmDefault;

type
  TfrmBook = class(TFrmDefault)
    panTop: TPanel;
    lblActive: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    chbVisivel: TCheckBox;
    lblVisivel: TLabel;
    panCenter: TPanel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmBook: TfrmBook;

implementation

{$R *.dfm}

end.
