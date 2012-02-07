unit UFrmSheetDiffusion;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, UFrmDefault;

type
  TfrmSheetDiffusion = class(TFrmDefault)
    lblActive: TLabel;
    edtActive: TEdit;
    btnOk: TButton;
    btnDelete: TButton;
    panTop: TPanel;
    chbVisible: TCheckBox;
    lblVisible: TLabel;
    btnClear: TButton;
    grdDiffusion: TStringGrid;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSheetDiffusion: TfrmSheetDiffusion;

implementation

{$R *.dfm}

end.
