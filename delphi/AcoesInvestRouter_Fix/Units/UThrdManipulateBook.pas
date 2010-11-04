unit UThrdManipulateBook;

interface

uses
  Classes,IdGlobal,SysUtils;

type
  TManipulateBook = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute; override;

  public
    BookData:String;
  end;

implementation
   uses UFrmMiniBook;
{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure ManipulateBook.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ ManipulateBook }

procedure TManipulateBook.Execute;
begin
end;

end.
