object FrmBook: TFrmBook
  Left = 0
  Top = 0
  Caption = 'Livro de Ofertas'
  ClientHeight = 190
  ClientWidth = 605
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 24
    Width = 605
    Height = 166
    Align = alClient
    TabOrder = 0
    object StringGrid1: TStringGrid
      Left = 1
      Top = 22
      Width = 603
      Height = 143
      Align = alClient
      ColCount = 6
      DefaultRowHeight = 17
      FixedCols = 0
      RowCount = 6
      TabOrder = 0
      OnDrawCell = StringGrid1DrawCell
      ColWidths = (
        133
        72
        76
        76
        77
        139)
    end
    object TabSet1: TTabSet
      Left = 1
      Top = 1
      Width = 603
      Height = 21
      Align = alTop
      AutoScroll = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      SoftTop = True
      Style = tsSoftTabs
      Tabs.Strings = (
        '5'
        '10'
        '15'
        'Completo')
      TabIndex = 0
      TabPosition = tpTop
      OnChange = TabSet1Change
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 605
    Height = 24
    Align = alTop
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 1
    object Edit1: TEdit
      Left = 2
      Top = 2
      Width = 70
      Height = 19
      TabOrder = 0
    end
    object BitBtn1: TBitBtn
      Left = 78
      Top = 0
      Width = 35
      Height = 24
      Caption = 'Ok'
      Default = True
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 1
      OnClick = BitBtn1Click
    end
    object CheckBox1: TCheckBox
      Left = 509
      Top = 3
      Width = 97
      Height = 17
      Caption = 'Sempre Vis'#237'vel'
      TabOrder = 2
      OnClick = CheckBox1Click
    end
  end
end
