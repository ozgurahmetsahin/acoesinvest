object FrmMiniBook: TFrmMiniBook
  Left = 496
  Top = 488
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = 'Livro'
  ClientHeight = 140
  ClientWidth = 499
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
  object StringGrid1: TStringGrid
    Left = 0
    Top = 21
    Width = 499
    Height = 119
    Align = alClient
    Color = 4194304
    ColCount = 6
    Ctl3D = False
    DefaultColWidth = 73
    DefaultRowHeight = 18
    FixedCols = 0
    RowCount = 6
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Options = [goFixedVertLine, goRangeSelect]
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 0
    OnDblClick = StringGrid1DblClick
    OnDrawCell = StringGrid1DrawCell
    OnKeyPress = StringGrid1KeyPress
    ColWidths = (
      73
      84
      82
      73
      96
      77)
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 499
    Height = 21
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
      Top = 2
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
      Top = 2
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
      Top = 2
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
      Top = 2
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
      Top = 2
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
      Top = 2
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
      Top = 2
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
      Top = 2
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
      Top = 4
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
      Top = 0
      Width = 64
      Height = 19
      CharCase = ecUpperCase
      TabOrder = 0
    end
    object Button1: TButton
      Left = 63
      Top = -1
      Width = 29
      Height = 21
      Caption = 'OK'
      Default = True
      TabOrder = 1
      OnClick = Button1Click
    end
    object CheckBox1: TCheckBox
      Left = 411
      Top = 2
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
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 200
    Top = 64
  end
end
