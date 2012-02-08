object FrmConsultOrders3: TFrmConsultOrders3
  Left = 0
  Top = 0
  Caption = 'Consulta de Orders'
  ClientHeight = 283
  ClientWidth = 1073
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1073
    Height = 283
    Align = alClient
    TabOrder = 0
    object gridOrders: TJvDBGrid
      Left = 1
      Top = 1
      Width = 1071
      Height = 235
      Align = alClient
      Color = clBlack
      DataSource = dsOrdersData
      DrawingStyle = gdsClassic
      Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgTitleClick, dgTitleHotTrack]
      PopupMenu = PopupMenu1
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnCellClick = gridOrdersCellClick
      OnDrawColumnCell = gridOrdersDrawColumnCell
      OnMouseDown = gridOrdersMouseDown
      OnTitleClick = gridOrdersTitleClick
      AutoSort = False
      ClearSelection = False
      SelectColumnsDialogStrings.Caption = 'Select columns'
      SelectColumnsDialogStrings.OK = '&OK'
      SelectColumnsDialogStrings.NoSelectionWarning = 'At least one column must be visible!'
      CanDelete = False
      EditControls = <>
      AutoSizeRows = False
      RowsHeight = 17
      TitleRowHeight = 17
      BooleanEditor = False
      Columns = <
        item
          Expanded = False
          FieldName = 'cancelable'
          Width = 35
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'editable'
          Width = 25
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'orderid'
          Width = 98
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'transacttime'
          Width = 45
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'symbol'
          Width = 50
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'account'
          Width = 48
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'direction'
          Width = 68
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'price'
          Width = 46
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'quantity'
          Width = 68
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'average_price'
          Width = 56
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'last_quantity'
          Width = 59
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'last_price'
          Width = 52
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'status'
          Width = 49
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'validity'
          Width = 50
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'description'
          Width = 612
          Visible = True
        end>
    end
    object Panel3: TPanel
      Left = 1
      Top = 255
      Width = 1071
      Height = 27
      Align = alBottom
      BevelOuter = bvNone
      Color = clBlack
      Ctl3D = False
      ParentBackground = False
      ParentCtl3D = False
      TabOrder = 1
      Visible = False
      DesignSize = (
        1071
        27)
      object Shape1: TShape
        Left = 61
        Top = 5
        Width = 18
        Height = 16
        Brush.Color = clBlue
      end
      object Shape2: TShape
        Left = 145
        Top = 5
        Width = 18
        Height = 16
        Brush.Color = clFuchsia
      end
      object Label3: TLabel
        Left = 85
        Top = 6
        Width = 46
        Height = 13
        Caption = 'PEndente'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label4: TLabel
        Left = 170
        Top = 6
        Width = 48
        Height = 13
        Caption = 'ReJeitada'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Shape3: TShape
        Left = 222
        Top = 5
        Width = 18
        Height = 16
        Brush.Color = clRed
      end
      object Label5: TLabel
        Left = 246
        Top = 6
        Width = 51
        Height = 13
        Caption = 'CAncelada'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Shape4: TShape
        Left = 300
        Top = 5
        Width = 18
        Height = 16
        Brush.Color = 38656
      end
      object Label6: TLabel
        Left = 324
        Top = 6
        Width = 51
        Height = 13
        Caption = 'EXecutada'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label7: TLabel
        Left = 7
        Top = 6
        Width = 50
        Height = 13
        Caption = 'Legendas:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Shape5: TShape
        Left = 384
        Top = 5
        Width = 18
        Height = 16
        Brush.Color = clLime
      end
      object Label8: TLabel
        Left = 411
        Top = 6
        Width = 79
        Height = 13
        Caption = 'Parc. eXecutada'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label9: TLabel
        Left = 1315
        Top = 6
        Width = 29
        Height = 13
        Anchors = []
        Caption = 'Vis'#237'vel'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitLeft = 833
      end
      object Shape6: TShape
        Left = 496
        Top = 5
        Width = 18
        Height = 16
        Brush.Color = 14079702
      end
      object Label10: TLabel
        Left = 522
        Top = 8
        Width = 42
        Height = 13
        Caption = 'ExPirada'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Shape7: TShape
        Left = 573
        Top = 6
        Width = 18
        Height = 16
        Brush.Color = 16744703
      end
      object Label11: TLabel
        Left = 597
        Top = 7
        Width = 70
        Height = 13
        Caption = 'Esp. Altera'#231#227'o'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Shape8: TShape
        Left = 670
        Top = 5
        Width = 18
        Height = 16
        Brush.Color = 9830399
      end
      object Label12: TLabel
        Left = 695
        Top = 8
        Width = 44
        Height = 13
        Caption = 'REcebida'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Shape9: TShape
        Left = 746
        Top = 6
        Width = 18
        Height = 16
        Brush.Color = 11796403
      end
      object Label13: TLabel
        Left = 772
        Top = 8
        Width = 65
        Height = 13
        Caption = 'Esp. Mercado'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Shape10: TShape
        Left = 842
        Top = 5
        Width = 18
        Height = 16
        Brush.Color = 12426242
      end
      object Label14: TLabel
        Left = 868
        Top = 8
        Width = 36
        Height = 13
        Caption = 'Editada'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Shape11: TShape
        Left = 923
        Top = 5
        Width = 18
        Height = 16
        Brush.Color = clMaroon
      end
      object Label15: TLabel
        Left = 949
        Top = 8
        Width = 85
        Height = 13
        Caption = 'Cancel. Pendente'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object CheckBox1: TCheckBox
        Left = 1293
        Top = 5
        Width = 17
        Height = 17
        Anchors = []
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
    end
    object StatusBar1: TStatusBar
      Left = 1
      Top = 236
      Width = 1071
      Height = 19
      Panels = <>
      SimplePanel = True
    end
  end
  object cdsOrdersData: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <
      item
        Name = 'cdsIdxDefault'
        Fields = 'orderid'
        Options = [ixDescending]
      end>
    IndexName = 'cdsIdxDefault'
    Params = <>
    StoreDefs = True
    Left = 304
    Top = 80
    object cdsOrdersDataorderid: TStringField
      DisplayLabel = 'C'#243'd.'
      FieldName = 'orderid'
      Size = 30
    end
    object cdsOrdersDatatransacttime: TDateTimeField
      DisplayLabel = 'Data'
      FieldName = 'transacttime'
      EditMask = '!99/99/00 - !99:99:99;1;_'
    end
    object cdsOrdersDatasymbol: TStringField
      DisplayLabel = 'Ativo'
      FieldName = 'symbol'
    end
    object cdsOrdersDataaccount: TIntegerField
      DisplayLabel = 'Cliente'
      FieldName = 'account'
    end
    object cdsOrdersDataprice: TFloatField
      DisplayLabel = 'Pre'#231'o'
      FieldName = 'price'
      DisplayFormat = '0.00'
    end
    object cdsOrdersDataquantity: TIntegerField
      DisplayLabel = 'Qtde. Solic.'
      FieldName = 'quantity'
      DisplayFormat = '###,###,###'
    end
    object cdsOrdersDataaverage_price: TFloatField
      DisplayLabel = 'Pr. M'#233'dio'
      FieldName = 'average_price'
      DisplayFormat = '0.00'
    end
    object cdsOrdersDatalast_quantity: TIntegerField
      DisplayLabel = 'Qtde. Neg.'
      FieldName = 'last_quantity'
      DisplayFormat = '###,###,###'
    end
    object cdsOrdersDatalast_price: TFloatField
      DisplayLabel = 'Pr. Neg.'
      FieldName = 'last_price'
      DisplayFormat = '0.00'
    end
    object cdsOrdersDatastatus: TStringField
      DisplayLabel = 'Situa'#231#227'o'
      FieldName = 'status'
      Size = 2
    end
    object cdsOrdersDatavalidity: TStringField
      DisplayLabel = 'Validade'
      FieldName = 'validity'
    end
    object cdsOrdersDatadescription: TStringField
      DisplayLabel = 'Descri'#231#227'o'
      FieldName = 'description'
      Size = 255
    end
    object cdsOrdersDatadirection: TStringField
      DisplayLabel = 'Dire'#231#227'o'
      FieldName = 'direction'
      Size = 10
    end
    object cdsOrdersDataeditable: TStringField
      DisplayLabel = 'Ed.'
      FieldName = 'editable'
      Size = 1
    end
    object cdsOrdersDatacancelable: TStringField
      DisplayLabel = 'Canc.'
      FieldName = 'cancelable'
      Size = 1
    end
    object cdsOrdersDatashadow_code: TStringField
      FieldName = 'shadow_code'
      Size = 255
    end
    object cdsOrdersDatainternal_id: TIntegerField
      FieldName = 'internal_id'
    end
  end
  object dsOrdersData: TDataSource
    DataSet = cdsOrdersData
    Enabled = False
    Left = 304
    Top = 136
  end
  object PopupMenu1: TPopupMenu
    Left = 408
    Top = 80
    object ExibirLegenda1: TMenuItem
      AutoCheck = True
      Caption = 'Exibir Legenda'
      OnClick = ExibirLegenda1Click
    end
  end
  object ImageList1: TImageList
    Left = 408
    Top = 136
    Bitmap = {
      494C010102004800480010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000555BBC00343C
      B2000F19A7000F19A7000F19A7000F19A7000F19A7000F19A7000F19A7000F19
      A700343CB200555BBC000000000000000000F3995C00EC915300E48A4B00DD82
      4200D67A3900CE733100C76B2800C0631F00B85C1700BA591000C35D0E00C35D
      0E00CC610C00D6650B0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000545ABC005B69E1006877
      EE006575EE006273ED005F71ED005C6EEC00596CEC00566AEB005268EB004F66
      EA004C63EA003F54DD00545ABC0000000000F0803300FFF2F200FFF1F100FFF0
      EF00FFEEEE00FFEAEA00FFE9E900FFE8E700FFE7E600FFE6E500FFE6E500FFE6
      E500FFE6E500D9670E0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000333BB2006D7BEE005766
      E5003E4FDA003445D5003345D4003343D3003142D2003141D1003040CF003647
      D3004357DF004C63EA003D47BC0000000000EF731F00FFE6E600B1B1B100AEAE
      AE00AAAAAA008E8E8E008C8C8C008A8A8A008888880086868600FFE9E8008D8D
      8D00FFE9E800D164170000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000F19A700707DEF004354
      DD004354DA00C5CAF300606DDD003446D5003345D4005F6BDB00C4C8F000404E
      D2003445D1004F66EA00202DB80000000000F17A2F00FFE8E700FFF1F000FFF0
      EF004A4A4A004A4A4A00007373000073730025730000BBAFAE00BBB1B100FFE7
      E600FFECEC00C65F140000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000F19A700737FEF004657
      DF00C5CAF300FFFFFF00F3F4FD00606EDE00606DDD00F3F4FC00FFFFFF00C4C8
      F0003040CF005268EB00202EB80000000000F2813F00FFEAE900C5C5C500C0C0
      C0009292920000B9B90000969600007373002573000000505000BBB3B300CDBD
      BD00FFEFEF00D164170000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000F19A7007681EF004859
      E1006270E300F3F4FD00FFFFFF00F3F4FD00F3F4FD00FFFFFF00F3F4FC005F6B
      DB003141D000566AEB00222FB80000000000F4884F00FFEBEB00FFF2F100FFF2
      F10000DCDC0000B9B90000B9B90025730000009600002573000000505000CDBE
      BD00CDC4C400DB6A1A0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000F19A7007A87F000495B
      E300384CDE006371E400F3F4FD00FFFFFF00FFFFFF00F3F4FD00606DDD003343
      D3003142D1005C71EC002735B90000000000F5905E00FFEDED00E6E6E600E6E6
      E6000096960000DCDC00009600000096000000B9000000960000257300000050
      5000CDA7A4009E61390000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000F19A7008697F3005066
      E7004059E3006778E700F3F4FD00FFFFFF00FFFFFF00F3F4FD006373DF003B50
      D700394FD5006983EF002A39BA0000000000F9A18000FFEFEE00FFF4F300FFF3
      F20000B9000000B9000000DC490000B900000096000000B90000009600002573
      000000505000A35A260000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000F19A7008EA3F4006484
      ED007994EE00F5F7FD00FFFFFF00F5F7FD00F5F7FD00FFFFFF00F5F7FD00758E
      E6004F71DE007491F2002B3BBA0000000000FAAB9200FFF0F000FFF5F400FFF4
      F300FFF3F20000B9000000FF000000DC490000B900000096000000B900000096
      0000257300000050500000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000F19A70091A4F4006685
      EE00CED7F900FFFFFF00F5F7FD007792EC007791EA00F5F7FD00FFFFFF00CCD5
      F5004F71DE007693F2002B3BBA0000000000FCB5A400FFF2F200FFF1F000FFEF
      EF00FFEEEE00FFECEC0000B9000000FF000000DC490000B900000096000000B9
      000000960000009600007A7A7A00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000F19A70092A4F5006686
      EF006283EE00CDD7F8007892EE005277E8005175E600758FE900CBD5F6005C7A
      E3005475E1007894F2002D3CBA0000000000FCB5A400FBAE9600FAA68900F89E
      7C00F6966B00F58E5A00F4854A0000DC490000FF000000DC490000B900000096
      000000B900000096000092929200000096000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000002C35AE008FA0F500778D
      F2005D7BEE005C7AED005B79EC005977EA005876E8005674E7005473E6005371
      E400647FEA00748DF2003F4ABB00000000000000000000000000000000000000
      00000000000000000000000000000000000000DC490000FF000000DC490000B9
      000000960000009600009E9E9E00000096000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000464CB5007783E7008998
      F4008795F4008493F4008191F3007E90F3007B8EF300798DF300768AF3007389
      F3007187F2005F73E300464CB500000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FF000000DC490000B9
      0000009600009E9E9E00003DB900003DB9000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000464CB5002D35
      AE000F19A7000F19A7000F19A7000F19A7000F19A7000F19A7000F19A7000F19
      A7002D35AE00464CB50000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000CECECE00F2F2
      F200CECECE000055FF00003DB900003DB9000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000055
      FF000055FF000055FF000049DC00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
  end
end
