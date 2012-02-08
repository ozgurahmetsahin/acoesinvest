unit UFrmConsultOrders;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, JvExDBGrids, JvDBGrid, ExtCtrls, DB, DBClient,
  Menus, StdCtrls, ImgList, IdGlobal, ComCtrls, UConnectionCenter, UFrmDefault;

type
  TFrmConsultOrders3 = class(TFrmDefault)
    Panel1: TPanel;
    gridOrders: TJvDBGrid;
    cdsOrdersData: TClientDataSet;
    cdsOrdersDataorderid: TStringField;
    dsOrdersData: TDataSource;
    PopupMenu1: TPopupMenu;
    cdsOrdersDatatransacttime: TDateTimeField;
    cdsOrdersDatasymbol: TStringField;
    cdsOrdersDataaccount: TIntegerField;
    cdsOrdersDataprice: TFloatField;
    cdsOrdersDataquantity: TIntegerField;
    cdsOrdersDataaverage_price: TFloatField;
    cdsOrdersDatalast_quantity: TIntegerField;
    cdsOrdersDatalast_price: TFloatField;
    cdsOrdersDatastatus: TStringField;
    Panel3: TPanel;
    Shape1: TShape;
    Shape2: TShape;
    Label3: TLabel;
    Label4: TLabel;
    Shape3: TShape;
    Label5: TLabel;
    Shape4: TShape;
    Label6: TLabel;
    Label7: TLabel;
    Shape5: TShape;
    Label8: TLabel;
    Label9: TLabel;
    Shape6: TShape;
    Label10: TLabel;
    Shape7: TShape;
    Label11: TLabel;
    Shape8: TShape;
    Label12: TLabel;
    Shape9: TShape;
    Label13: TLabel;
    Shape10: TShape;
    Label14: TLabel;
    Shape11: TShape;
    Label15: TLabel;
    CheckBox1: TCheckBox;
    cdsOrdersDatavalidity: TStringField;
    cdsOrdersDatadescription: TStringField;
    ExibirLegenda1: TMenuItem;
    cdsOrdersDatadirection: TStringField;
    cdsOrdersDataeditable: TStringField;
    cdsOrdersDatacancelable: TStringField;
    ImageList1: TImageList;
    cdsOrdersDatashadow_code: TStringField;
    cdsOrdersDatainternal_id: TIntegerField;
    StatusBar1: TStatusBar;
    procedure gridOrdersDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure ExibirLegenda1Click(Sender: TObject);
    procedure gridOrdersCellClick(Column: TColumn);
    procedure gridOrdersMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cdsOrdersDataBeforeInsert(DataSet: TDataSet);
    procedure cdsOrdersDataAfterPost(DataSet: TDataSet);
    procedure gridOrdersTitleClick(Column: TColumn);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    CdsClone:TClientDataSet;
    CanClick:Boolean;
    PositionGrid:Integer;
    procedure CreateClone;
    procedure CreateOrderData;
    procedure CallOrderMass;
    procedure EditOR(DataSet:TClientDataSet);
    procedure CancelOR(DataSet:TClientDataSet);
  public
    { Public declarations }
  end;

var
  FrmConsultOrders3: TFrmConsultOrders3;

implementation

{$R *.dfm}

{ TFrmConsultOrders3 }

procedure TFrmConsultOrders3.CallOrderMass;
begin
end;

procedure TFrmConsultOrders3.CancelOR(DataSet: TClientDataSet);
begin

end;

procedure TFrmConsultOrders3.cdsOrdersDataAfterPost(DataSet: TDataSet);
begin
  if (dsOrdersData.Enabled) and (not cdsOrdersData.Eof) then
  cdsOrdersData.RecNo:=PositionGrid;

  StatusBar1.SimpleText:='Total:' + IntToStr(cdsOrdersData.RecordCount);
end;

procedure TFrmConsultOrders3.cdsOrdersDataBeforeInsert(DataSet: TDataSet);
begin
  if (dsOrdersData.Enabled) and (not cdsOrdersData.Eof) then
  PositionGrid:=cdsOrdersData.RecNo;
end;

procedure TFrmConsultOrders3.CreateClone;
begin
  CdsClone:=TClientDataSet.Create(Self);
  CdsClone.CloneCursor(TClientDataSet(cdsOrdersData),True);
  CdsClone.BeforeInsert:=cdsOrdersDataBeforeInsert;
  CdsClone.AfterPost:=cdsOrdersDataAfterPost;
end;

procedure TFrmConsultOrders3.CreateOrderData;
begin
  cdsOrdersData.CreateDataSet;
end;

procedure TFrmConsultOrders3.EditOR(DataSet: TClientDataSet);
begin
  
end;

procedure TFrmConsultOrders3.ExibirLegenda1Click(Sender: TObject);
begin
  Panel3.Visible:=ExibirLegenda1.Checked;
end;

procedure TFrmConsultOrders3.FormShow(Sender: TObject);
begin
  if not dsOrdersData.Enabled then
  begin
    CreateOrderData;
    CreateClone;
    CallOrderMass;
  end;
end;

procedure TFrmConsultOrders3.gridOrdersCellClick(Column: TColumn);
begin
if (Column.FieldName = 'editable') and (CanClick) then
  begin
      if (gridOrders.DataSource.DataSet.FieldByName('status').Value = 'RE') or
      (gridOrders.DataSource.DataSet.FieldByName('status').Value = 'EM') or
      (gridOrders.DataSource.DataSet.FieldByName('status').Value = 'PX') or
      (gridOrders.DataSource.DataSet.FieldByName('status').Value = 'PE') or
      (gridOrders.DataSource.DataSet.FieldByName('status').Value = 'ED')then
      begin
        EditOR(TClientDataSet( gridOrders.DataSource.DataSet ));
      end;
  end;

  if (Column.FieldName = 'cancelable') and (CanClick)  then
  begin
      if (gridOrders.DataSource.DataSet.FieldByName('status').Value = 'RE') or
      (gridOrders.DataSource.DataSet.FieldByName('status').Value = 'EM') or
      (gridOrders.DataSource.DataSet.FieldByName('status').Value = 'PX') or
      (gridOrders.DataSource.DataSet.FieldByName('status').Value = 'PE') or
      (gridOrders.DataSource.DataSet.FieldByName('status').Value = 'ED')then
      begin
        CancelOR(TClientDataSet( gridOrders.DataSource.DataSet));
      end;
   end;

  CanClick:=False;
end;

procedure TFrmConsultOrders3.gridOrdersDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var Bmp:TBitmap;
begin

  if gridOrders.DataSource.DataSet.FieldByName('status').Value = 'PE' then
  begin
    gridOrders.Canvas.Brush.Color:=Shape1.Brush.Color;
    gridOrders.Canvas.Font.Color:=clWhite;
  end;

  if gridOrders.DataSource.DataSet.FieldByName('status').Value = 'RJ' then
  gridOrders.Canvas.Brush.Color:=Shape2.Brush.Color;

  if gridOrders.DataSource.DataSet.FieldByName('status').Value = 'CA' then
  begin
    gridOrders.Canvas.Brush.Color:=Shape3.Brush.Color;
    gridOrders.Canvas.Font.Color:=clWhite;
  end;

  if gridOrders.DataSource.DataSet.FieldByName('status').Value = 'EX' then
  begin
    gridOrders.Canvas.Brush.Color:=Shape4.Brush.Color;
    gridOrders.Canvas.Font.Color:=clWhite;
  end;

  if gridOrders.DataSource.DataSet.FieldByName('status').Value = 'PX' then
  gridOrders.Canvas.Brush.Color:=Shape5.Brush.Color;

  if gridOrders.DataSource.DataSet.FieldByName('status').Value = 'EP' then
  gridOrders.Canvas.Brush.Color:=Shape6.Brush.Color;

  if gridOrders.DataSource.DataSet.FieldByName('status').Value = 'EA' then
  gridOrders.Canvas.Brush.Color:=Shape7.Brush.Color;

  if gridOrders.DataSource.DataSet.FieldByName('status').Value = 'RE' then
  gridOrders.Canvas.Brush.Color:=Shape8.Brush.Color;

  if gridOrders.DataSource.DataSet.FieldByName('status').Value = 'EM' then
  gridOrders.Canvas.Brush.Color:=Shape9.Brush.Color;

  if gridOrders.DataSource.DataSet.FieldByName('status').Value = 'CG' then
  gridOrders.Canvas.Brush.Color:=Shape10.Brush.Color;

  if gridOrders.DataSource.DataSet.FieldByName('status').Value = 'ED' then
  gridOrders.Canvas.Brush.Color:=Shape10.Brush.Color;

  if gridOrders.DataSource.DataSet.FieldByName('status').Value = 'CP' then
  begin
    gridOrders.Canvas.Brush.Color:=Shape11.Brush.Color;
    gridOrders.Canvas.Font.Color:=clWhite;
  end;

   if (gdSelected in State) then
  begin
    gridOrders.Canvas.Font.Color:=clBlack;
  end;

  gridOrders.DefaultDrawColumnCell(Rect, DataCol, Column, State);

  if Column.FieldName='editable' then
  begin
    if (gridOrders.DataSource.DataSet.FieldByName('status').AsString = 'RE') or
    (gridOrders.DataSource.DataSet.FieldByName('status').AsString = 'PE') or
    (gridOrders.DataSource.DataSet.FieldByName('status').AsString = 'PX') or
    (gridOrders.DataSource.DataSet.FieldByName('status').AsString = 'ED') then
    begin
      try
        Bmp:=TBitmap.Create;
        Bmp.TransparentColor:=clWhite;
        Bmp.Transparent:=True;
        ImageList1.GetBitmap(1,Bmp);
        gridOrders.Canvas.Draw(Rect.Left+3,Rect.Top,Bmp);
      finally
        if Assigned(Bmp) then
        Bmp.Free;
      end;
    end;
  end;

  if Column.FieldName='cancelable' then
  begin
    if (gridOrders.DataSource.DataSet.FieldByName('status').AsString = 'RE') or
    (gridOrders.DataSource.DataSet.FieldByName('status').AsString = 'PE') or
    (gridOrders.DataSource.DataSet.FieldByName('status').AsString = 'PX') or
    (gridOrders.DataSource.DataSet.FieldByName('status').AsString = 'ED') then
    begin
      try
        Bmp:=TBitmap.Create;
        Bmp.TransparentColor:=clWhite;
        Bmp.Transparent:=True;
        ImageList1.GetBitmap(0,Bmp);
        gridOrders.Canvas.Draw(Rect.Left+3,Rect.Top,Bmp);
      finally
        Bmp.Free;
      end;
    end;
  end;
end;

procedure TFrmConsultOrders3.gridOrdersMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  CanClick:= True;
end;

procedure TFrmConsultOrders3.gridOrdersTitleClick(Column: TColumn);
var
  indice: string;
  existe: boolean;
  clientdataset_idx: tclientdataset;
begin

  indice:= Column.FieldName + '_Idx_ASC';

  clientdataset_idx := TClientDataset(cdsOrdersData);

  if clientdataset_idx.IndexName <> indice then
  begin
     try
      clientdataset_idx.IndexDefs.Find(indice);
      existe := true;
    except
      existe := false;
    end;

    if not existe then
    with clientdataset_idx.IndexDefs.AddIndexDef do begin
      Name := indice;
      Fields := Column.FieldName;
    end;
    clientdataset_idx.IndexName := indice;
  end
  else
  begin
    indice:=Column.FieldName + '_Idx_DESC';
    try
      clientdataset_idx.IndexDefs.Find(indice);
      existe := true;
    except
      existe := false;
    end;

    if not existe then
    with clientdataset_idx.IndexDefs.AddIndexDef do begin
      Name := indice;
      Fields := Column.FieldName;
      Options := [ixDescending];
    end;
    clientdataset_idx.IndexName := indice;
  end;
  if clientdataset_idx.RecordCount>0 then
  clientdataset_idx.RecNo:=1;
end;

end.
