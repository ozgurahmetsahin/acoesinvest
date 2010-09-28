unit UFrmOpenChart;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ShellApi;

type
  TFrmOpenChart = class(TForm)
    LabeledEdit1: TLabeledEdit;
    ComboBox1: TComboBox;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmOpenChart: TFrmOpenChart;

implementation

{$R *.dfm}

procedure TFrmOpenChart.Button1Click(Sender: TObject);
var BatFile:TStringList;
begin
  BatFile:=TStringList.Create;
  case ComboBox1.ItemIndex of
    0: BatFile.Add('java -jar Grafix.jar INVEST ' + LabeledEdit1.Text + ' 1');
    1: BatFile.Add('java -jar Grafix.jar INVEST ' + LabeledEdit1.Text + ' 5');
    2: BatFile.Add('java -jar Grafix.jar INVEST ' + LabeledEdit1.Text + ' 10');
    3: BatFile.Add('java -jar Grafix.jar INVEST ' + LabeledEdit1.Text + ' 15');
    4: BatFile.Add('java -jar Grafix.jar INVEST ' + LabeledEdit1.Text + ' 30');
    5: BatFile.Add('java -jar Grafix.jar INVEST ' + LabeledEdit1.Text + ' D');
    6: BatFile.Add('java -jar Grafix.jar INVEST ' + LabeledEdit1.Text + ' M');
    else
    BatFile.Add('java -jar Grafix.jar INVEST ' + LabeledEdit1.Text + ' ' + ComboBox1.Text);
  end;

  BatFile.SaveToFile(ExtractFilePath(ParamStr(0))+'JGrafix/chartRun.bat');

 ShellExecute(Handle,'open','chartRun.bat','',PChar(ExtractFilePath(ParamStr(0))+'JGrafix/'),SW_HIDE);
end;

procedure TFrmOpenChart.Button2Click(Sender: TObject);
begin
 Self.Close;
end;

end.
