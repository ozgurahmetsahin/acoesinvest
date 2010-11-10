object FrmPortfolio: TFrmPortfolio
  Left = 0
  Top = 0
  Caption = 'Carteira'
  ClientHeight = 336
  ClientWidth = 798
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
  object Label13: TLabel
    Left = 242
    Top = 26
    Width = 79
    Height = 13
    Caption = 'Saldo em Conta:'
  end
  object Label14: TLabel
    Left = 353
    Top = 26
    Width = 49
    Height = 16
    Caption = 'R$ 0,00'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label15: TLabel
    Left = 250
    Top = 34
    Width = 79
    Height = 13
    Caption = 'Saldo em Conta:'
  end
  object Label16: TLabel
    Left = 361
    Top = 34
    Width = 49
    Height = 16
    Caption = 'R$ 0,00'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label19: TLabel
    Left = 258
    Top = 42
    Width = 79
    Height = 13
    Caption = 'Saldo em Conta:'
  end
  object Label20: TLabel
    Left = 369
    Top = 42
    Width = 49
    Height = 16
    Caption = 'R$ 0,00'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label24: TLabel
    Left = 660
    Top = 25
    Width = 43
    Height = 14
    Caption = 'R$ 0,00'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label27: TLabel
    Left = 611
    Top = 25
    Width = 45
    Height = 14
    Caption = 'Compra:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Portfolio: TSheet
    Left = 0
    Top = 0
    Width = 798
    Height = 208
    Align = alClient
    ColCount = 9
    DefaultRowHeight = 17
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
    TabOrder = 0
    ColumsVisible = [clQuote, clPicture, clLast, clSell, clStatus, clBaseIn, clObj1, clObj2, clObj3]
    StringclQuote = 'Ativo'
    StringclPicture = 'Qtde. Total'
    StringclLast = 'Quant. Disp.'
    StringclSell = 'Pr. Medio'
    StringclStatus = 'Pr. Atual'
    StringclBaseIn = 'Total Custodia'
    StringclObj1 = 'Total Atual'
    StringclObj2 = 'Lucro/Preju R$'
    StringclObj3 = 'Lucro/Preju %'
    FilterColums = stAll
    FontColorPaint = clBlack
    EvenColorLine = clBlack
    OddColorLine = clBlack
    ShowClearLine = False
    ExplicitHeight = 240
    ColWidths = (
      68
      70
      70
      63
      71
      81
      64
      110
      89)
    RowHeights = (
      17
      17)
  end
  object Panel1: TPanel
    Left = 0
    Top = 208
    Width = 798
    Height = 128
    Align = alBottom
    BevelKind = bkFlat
    BevelOuter = bvNone
    Color = clBlack
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 1
    object Label1: TLabel
      Left = 9
      Top = 26
      Width = 139
      Height = 16
      Caption = 'Total em cust'#243'dia atual:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 9
      Top = 43
      Width = 120
      Height = 16
      Caption = 'Total Lucro/Prejuizo:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 168
      Top = 26
      Width = 53
      Height = 16
      Caption = '10000,00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 168
      Top = 43
      Width = 53
      Height = 16
      Caption = '10000,00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 304
      Top = 26
      Width = 96
      Height = 16
      Caption = 'Saldo em Conta:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 422
      Top = 26
      Width = 44
      Height = 16
      Caption = 'R$ 0,00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 422
      Top = 95
      Width = 44
      Height = 16
      Caption = 'R$ 0,00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label8: TLabel
      Left = 300
      Top = 95
      Width = 100
      Height = 16
      Caption = 'Saldo  Projetado:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label9: TLabel
      Left = 10
      Top = 61
      Width = 106
      Height = 16
      Caption = 'Patrim'#244'nio Online:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label10: TLabel
      Left = 168
      Top = 61
      Width = 44
      Height = 16
      Caption = 'R$ 0,00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label11: TLabel
      Left = 374
      Top = 43
      Width = 28
      Height = 16
      Caption = 'D+1:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label12: TLabel
      Left = 422
      Top = 43
      Width = 44
      Height = 16
      Caption = 'R$ 0,00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label17: TLabel
      Left = 374
      Top = 61
      Width = 28
      Height = 16
      Caption = 'D+2:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label18: TLabel
      Left = 422
      Top = 61
      Width = 44
      Height = 16
      Caption = 'R$ 0,00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label21: TLabel
      Left = 374
      Top = 79
      Width = 28
      Height = 16
      Caption = 'D+3:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label22: TLabel
      Left = 422
      Top = 79
      Width = 44
      Height = 16
      Caption = 'R$ 0,00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label23: TLabel
      Left = 558
      Top = 26
      Width = 114
      Height = 16
      Caption = 'Ordens Executadas:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label25: TLabel
      Left = 584
      Top = 43
      Width = 50
      Height = 16
      Caption = 'Compra:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label26: TLabel
      Left = 638
      Top = 43
      Width = 25
      Height = 16
      Caption = '0.00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label28: TLabel
      Left = 638
      Top = 61
      Width = 25
      Height = 16
      Caption = '0.00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label29: TLabel
      Left = 590
      Top = 61
      Width = 41
      Height = 16
      Caption = 'Venda:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label30: TLabel
      Left = 487
      Top = 79
      Width = 144
      Height = 16
      Caption = 'Total de Movimenta'#231#245'es:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label31: TLabel
      Left = 638
      Top = 81
      Width = 44
      Height = 16
      Caption = 'R$ 0,00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label32: TLabel
      Left = 535
      Top = 101
      Width = 90
      Height = 16
      Caption = 'Saldo Mov. Dia:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label33: TLabel
      Left = 638
      Top = 101
      Width = 44
      Height = 16
      Caption = 'R$ 0,00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label34: TLabel
      Left = 10
      Top = 5
      Width = 133
      Height = 16
      Caption = 'Resumo da Carteira:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Shape1: TShape
      Left = -1
      Top = 23
      Width = 791
      Height = 1
      Pen.Color = clWhite
    end
    object BitBtn1: TBitBtn
      Left = 10
      Top = 94
      Width = 131
      Height = 25
      Caption = 'Atualizar dados'
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 0
      OnClick = BitBtn1Click
    end
  end
  object Calculator: TTimer
    OnTimer = CalculatorTimer
    Left = 360
    Top = 128
  end
end
