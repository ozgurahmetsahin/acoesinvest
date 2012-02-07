unit UFrmDefault;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UConnectionCenter;

type
  TFrmDefault = class(TForm)
  private
    FConnCenter: TConnectionCenter;
    { Private declarations }
  published
    property ConnCenter:TConnectionCenter read FConnCenter write FConnCenter;
  public
    { Public declarations }
  end;

var
  FrmDefault: TFrmDefault;

implementation

{$R *.dfm}

end.
