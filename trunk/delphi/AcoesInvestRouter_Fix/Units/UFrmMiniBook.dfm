object FrmMiniBook: TFrmMiniBook
  Left = 496
  Top = 488
  Caption = 'Livro'
  ClientHeight = 220
  ClientWidth = 519
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesigned
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Dados: TStringGrid
    Left = 0
    Top = 46
    Width = 519
    Height = 174
    Align = alClient
    Color = clWhite
    ColCount = 6
    Ctl3D = False
    DefaultColWidth = 73
    DefaultRowHeight = 18
    DoubleBuffered = True
    FixedCols = 0
    RowCount = 6
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Options = [goFixedVertLine, goRangeSelect, goColSizing]
    ParentCtl3D = False
    ParentDoubleBuffered = False
    ParentFont = False
    TabOrder = 0
    OnDblClick = DadosDblClick
    OnDrawCell = DadosDrawCell
    OnKeyPress = DadosKeyPress
    ColWidths = (
      121
      64
      66
      65
      62
      123)
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 519
    Height = 46
    Align = alTop
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Color = 4194304
    Ctl3D = False
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 1
    object Label3: TLabel
      Left = 174
      Top = 23
      Width = 22
      Height = 13
      Caption = 'Osc.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 198
      Top = 23
      Width = 22
      Height = 13
      Caption = '0.00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 249
      Top = 23
      Width = 24
      Height = 13
      Caption = 'M'#225'x.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 275
      Top = 23
      Width = 22
      Height = 13
      Caption = '0.00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 328
      Top = 23
      Width = 20
      Height = 13
      Caption = 'M'#237'n.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label8: TLabel
      Left = 354
      Top = 23
      Width = 22
      Height = 13
      Caption = '0.00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label9: TLabel
      Left = 98
      Top = 23
      Width = 17
      Height = 13
      Caption = #218'lt:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label10: TLabel
      Left = 121
      Top = 23
      Width = 22
      Height = 13
      Caption = '0.00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label1: TLabel
      Left = 427
      Top = 25
      Width = 68
      Height = 13
      Caption = 'Sempre Vis'#237'vel'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Edit1: TEdit
      Left = 0
      Top = 21
      Width = 64
      Height = 19
      CharCase = ecUpperCase
      TabOrder = 0
    end
    object Button1: TButton
      Left = 63
      Top = 20
      Width = 29
      Height = 21
      Caption = 'OK'
      Default = True
      TabOrder = 1
      OnClick = Button1Click
    end
    object CheckBox1: TCheckBox
      Left = 411
      Top = 23
      Width = 16
      Height = 17
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = CheckBox1Click
    end
    object TabSet1: TTabSet
      Left = 0
      Top = 0
      Width = 517
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
  object StringGrid1: TStringGrid
    Left = 48
    Top = 88
    Width = 419
    Height = 273
    ColCount = 6
    DoubleBuffered = True
    FixedCols = 0
    RowCount = 3000
    ParentDoubleBuffered = False
    TabOrder = 2
    Visible = False
    ColWidths = (
      64
      64
      64
      64
      64
      64)
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 200
    OnTimer = Timer1Timer
    Left = 200
    Top = 104
  end
  object Timer2: TTimer
    Interval = 200
    OnTimer = Timer2Timer
    Left = 240
    Top = 104
  end
end
