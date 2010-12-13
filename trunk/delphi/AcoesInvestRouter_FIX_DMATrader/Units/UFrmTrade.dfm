object FrmTrade: TFrmTrade
  Left = 321
  Top = 311
  Caption = 'Planilha de Cota'#231#245'es'
  ClientHeight = 315
  ClientWidth = 742
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesigned
  PixelsPerInch = 96
  TextHeight = 13
  object TradeSheet: TSheet
    Left = 0
    Top = 28
    Width = 742
    Height = 287
    Align = alClient
    BiDiMode = bdLeftToRight
    Color = 4194304
    ColCount = 11
    Ctl3D = False
    DefaultRowHeight = 17
    DoubleBuffered = True
    FixedCols = 0
    RowCount = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Options = [goFixedVertLine, goRangeSelect, goColSizing]
    ParentBiDiMode = False
    ParentCtl3D = False
    ParentDoubleBuffered = False
    ParentFont = False
    PopupMenu = PopupMenu1
    TabOrder = 0
    OnDblClick = TradeSheetDblClick
    OnDrawCell = TradeSheetDrawCell
    OnKeyDown = TradeSheetKeyDown
    OnKeyPress = TradeSheetKeyPress
    ColumsVisible = [clQuote, clLast, clVar, clBuy, clSell, clMax, clMin, clOpen, clClose, clNeg, clVarWeek]
    StringclQuote = 'Ativo'
    StringclPicture = 'Hora'
    StringclLast = #218'ltimo'
    StringclVar = 'Osc. ( % )'
    StringclBuy = 'M. Compra'
    StringclSell = 'M. Venda'
    StringclMax = 'M'#225'xima'
    StringclMin = 'M'#237'nima'
    StringclOpen = 'Abertura'
    StringclClose = 'Fech. Anterior'
    StringclNeg = 'N'#250'm. Neg'#243'cios'
    StringclVarWeek = 'Hora'
    FilterColums = stAll
    FontColorPaint = clBlack
    EvenColorLine = 12908023
    OddColorLine = 15203838
    ShowClearLine = False
    BlinkCellValue = True
    ColWidths = (
      64
      64
      64
      64
      64
      64
      64
      64
      79
      74
      64)
    RowHeights = (
      17
      17)
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 742
    Height = 28
    Align = alTop
    Color = clBlack
    ParentBackground = False
    TabOrder = 1
    object Label1: TLabel
      Left = 5
      Top = 6
      Width = 63
      Height = 13
      Caption = 'Novo ativo:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object SpeedButton1: TSpeedButton
      Left = 178
      Top = 3
      Width = 23
      Height = 22
      Hint = 'Excluir ativo selecionado'
      Caption = '-'
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      Left = 206
      Top = 3
      Width = 23
      Height = 22
      Hint = 'Limpar toda planilha'
      Caption = '--'
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton2Click
    end
    object Label2: TLabel
      Left = 668
      Top = 7
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
      Left = 68
      Top = 4
      Width = 72
      Height = 19
      Hint = 'Digite o ativo '#224' ser adicionado'
      Ctl3D = False
      ParentCtl3D = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
    object Button1: TButton
      Left = 139
      Top = 3
      Width = 34
      Height = 21
      Hint = 'Adicionar ativo '#224' planilha'
      Caption = '+'
      Default = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = Button1Click
    end
    object CheckBox1: TCheckBox
      Left = 651
      Top = 6
      Width = 86
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
  object PopupMenu1: TPopupMenu
    Left = 192
    Top = 120
    object MoverparCima1: TMenuItem
      Caption = 'Mover para cima     ( Pg Up )'
      OnClick = MoverparCima1Click
    end
    object Moverparabaixo1: TMenuItem
      Caption = 'Mover para baixo    ( Pg Down)'
      OnClick = Moverparabaixo1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Excluirativo1: TMenuItem
      Caption = 'Excluir ativo'
      ShortCut = 46
      OnClick = Excluirativo1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Book5Melhores1: TMenuItem
      Caption = 'Livro de Ofertas'
      ShortCut = 16450
      OnClick = Book5Melhores1Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object Compra1: TMenuItem
      Caption = 'Compra (F5)'
      OnClick = Compra1Click
    end
    object Venda1: TMenuItem
      Caption = 'Venda (F9)'
      OnClick = Venda1Click
    end
  end
  object BalloonHint1: TBalloonHint
    Left = 312
    Top = 120
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 10
    OnTimer = Timer1Timer
    Left = 400
    Top = 112
  end
end
