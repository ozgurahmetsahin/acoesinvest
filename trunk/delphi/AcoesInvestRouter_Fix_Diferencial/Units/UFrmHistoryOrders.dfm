object FrmHistoryOrders: TFrmHistoryOrders
  Left = 335
  Top = 222
  Caption = 'Hist'#243'rico de Ordens'
  ClientHeight = 252
  ClientWidth = 881
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object HistorySheet: TSheet
    Left = 0
    Top = 0
    Width = 881
    Height = 211
    Align = alClient
    ColCount = 12
    Ctl3D = False
    DefaultColWidth = 70
    DefaultRowHeight = 17
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goRangeSelect, goColSizing]
    ParentCtl3D = False
    PopupMenu = PopupMenu1
    TabOrder = 0
    OnDrawCell = HistorySheetDrawCell
    OnMouseDown = HistorySheetMouseDown
    ColumsVisible = [clQuote, clPicture, clLast, clVar, clBuy, clSell, clStatus, clBaseIn, clObj1, clObj2, clObj3, clObj4]
    StringclQuote = 'C'#243'd.'
    StringclPicture = 'Data'
    StringclLast = 'Validade'
    StringclVar = 'Tipo'
    StringclBuy = 'Ativo'
    StringclSell = 'Pre'#231'o'
    StringclStatus = 'Qtde Ap.'
    StringclBaseIn = 'Dt. Negoc.'
    StringclObj1 = 'Qt. Canc'
    StringclObj2 = 'Qt. Negoc'
    StringclObj3 = 'Pr. Negc'
    StringclObj4 = 'Situa'#231#227'o'
    FilterColums = stAll
    FontColorPaint = clBlack
    EvenColorLine = clBlack
    OddColorLine = clBlack
    ShowClearLine = False
    RowHeights = (
      17
      17)
  end
  object Panel1: TPanel
    Left = 0
    Top = 232
    Width = 881
    Height = 20
    Align = alBottom
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 1
    object Shape1: TShape
      Left = 61
      Top = 2
      Width = 18
      Height = 16
      Brush.Color = clLime
    end
    object Shape2: TShape
      Left = 145
      Top = 2
      Width = 18
      Height = 16
      Brush.Color = clRed
    end
    object Label1: TLabel
      Left = 87
      Top = 3
      Width = 51
      Height = 13
      Caption = 'Executada'
    end
    object Label2: TLabel
      Left = 170
      Top = 3
      Width = 46
      Height = 13
      Caption = 'Rejeitada'
    end
    object Shape3: TShape
      Left = 222
      Top = 2
      Width = 18
      Height = 16
      Brush.Color = clYellow
    end
    object Label3: TLabel
      Left = 248
      Top = 3
      Width = 44
      Height = 13
      Caption = 'Recebida'
    end
    object Shape4: TShape
      Left = 300
      Top = 2
      Width = 18
      Height = 16
      Brush.Color = 16744448
    end
    object Label4: TLabel
      Left = 326
      Top = 3
      Width = 50
      Height = 13
      Caption = 'Cancelada'
    end
    object Label5: TLabel
      Left = 7
      Top = 3
      Width = 50
      Height = 13
      Caption = 'Legendas:'
    end
    object Shape5: TShape
      Left = 384
      Top = 2
      Width = 18
      Height = 16
    end
    object Label6: TLabel
      Left = 410
      Top = 5
      Width = 33
      Height = 13
      Caption = 'Outros'
    end
    object CheckBox1: TCheckBox
      Left = 784
      Top = 2
      Width = 97
      Height = 17
      Caption = 'Sempre Vis'#237'vel'
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = CheckBox1Click
    end
  end
  object TabSet1: TTabSet
    Left = 0
    Top = 211
    Width = 881
    Height = 21
    Align = alBottom
    AutoScroll = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Tabs.Strings = (
      'Todos'
      'Bovespa'
      'BM&&F')
    TabIndex = 0
    Visible = False
    OnChange = TabSet1Change
  end
  object PopupMenu1: TPopupMenu
    Left = 272
    Top = 96
    object Editar1: TMenuItem
      Caption = 'Editar'
      OnClick = Editar1Click
    end
    object Cancelar1: TMenuItem
      Caption = 'Cancelar'
      OnClick = Cancelar1Click
    end
  end
  object Timer1: TTimer
    Interval = 800
    OnTimer = Timer1Timer
    Left = 368
    Top = 96
  end
end
