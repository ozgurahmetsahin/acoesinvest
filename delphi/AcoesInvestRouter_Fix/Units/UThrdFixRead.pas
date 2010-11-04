unit UThrdFixRead;

interface

uses
  Classes, IdException,IdExceptionCore;

type
  TFixRead = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute; override;
  end;

implementation
   uses UFrmMainTreeView;
{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure TFixRead.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ TFixRead }

procedure TFixRead.Execute;
var FixRead:String;
    MsgFix:String;
begin
  { Place thread code here }


  while FrmMainTreeView.Fix.Connected do
  begin

    try

      FixRead:='';
      MsgFix:='';

      repeat
       FixRead:= FrmMainTreeView.Fix.IOHandler.ReadLn(#01);
       if FixRead <> '' then
        if MsgFix <> '' then MsgFix:= MsgFix + #01+ FixRead else MsgFix:= FixRead;

      until (Copy(FixRead,1,3) = '10=');

      FrmMainTreeView.Memo1.Lines.Add(MsgFix);

      FrmMainTreeView.RouterLibrary1.ReadMsg(MsgFix);

    except
      on E: EIdConnClosedGracefully do
      begin
        FrmMainTreeView.MsgErr:='Você foi desconectado do servidor BMF';
        FrmMainTreeView.ShowMsgErr;
        break;
      end;
      on E:EIdException do
      begin
        FrmMainTreeView.MsgErr:='Você foi desconectado do servidor BMF';
        FrmMainTreeView.ShowMsgErr;
        break;
      end;
    end;

  end;


end;

end.
