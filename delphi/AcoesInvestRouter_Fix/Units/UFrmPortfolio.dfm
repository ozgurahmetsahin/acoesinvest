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
    Height = 240
    Align = alClient
    ColCount = 9
    DefaultRowHeight = 17
    FixedCols = 0
    RowCount = 2
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
    Top = 240
    Width = 798
    Height = 96
    Align = alBottom
    BevelKind = bkFlat
    BevelOuter = bvNone
    Color = clWhite
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
      Left = 3
      Top = 1
      Width = 156
      Height = 16
      Caption = 'Total em cust'#243'dia atual:'
    end
    object Label2: TLabel
      Left = 3
      Top = 18
      Width = 137
      Height = 16
      Caption = 'Total Lucro/Prejuizo:'
    end
    object Label3: TLabel
      Left = 162
      Top = 1
      Width = 60
      Height = 16
      Caption = '10000,00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 162
      Top = 18
      Width = 60
      Height = 16
      Caption = '10000,00'
    end
    object Label5: TLabel
      Left = 302
      Top = 1
      Width = 105
      Height = 16
      Caption = 'Saldo em Conta:'
    end
    object Label6: TLabel
      Left = 422
      Top = 1
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
    object Label7: TLabel
      Left = 422
      Top = 70
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
    object Label8: TLabel
      Left = 295
      Top = 70
      Width = 112
      Height = 16
      Caption = 'Saldo  Projetado:'
    end
    object Label9: TLabel
      Left = 4
      Top = 36
      Width = 117
      Height = 16
      Caption = 'Patrim'#244'nio Online:'
    end
    object Label10: TLabel
      Left = 162
      Top = 36
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
    object Label11: TLabel
      Left = 374
      Top = 18
      Width = 27
      Height = 14
      Caption = 'D+1:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label12: TLabel
      Left = 422
      Top = 18
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
    object Label17: TLabel
      Left = 374
      Top = 36
      Width = 27
      Height = 14
      Caption = 'D+2:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label18: TLabel
      Left = 422
      Top = 36
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
    object Label21: TLabel
      Left = 374
      Top = 54
      Width = 27
      Height = 14
      Caption = 'D+3:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label22: TLabel
      Left = 422
      Top = 54
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
    object Label23: TLabel
      Left = 574
      Top = 1
      Width = 129
      Height = 16
      Caption = 'Ordens Executadas:'
    end
    object Label25: TLabel
      Left = 611
      Top = 18
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
    object Label26: TLabel
      Left = 660
      Top = 18
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
    object Label28: TLabel
      Left = 660
      Top = 36
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
    object Label29: TLabel
      Left = 617
      Top = 36
      Width = 39
      Height = 14
      Caption = 'Venda:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label30: TLabel
      Left = 624
      Top = 56
      Width = 32
      Height = 14
      Caption = 'Total:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label31: TLabel
      Left = 660
      Top = 56
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
  end
  object Calculator: TTimer
    OnTimer = CalculatorTimer
    Left = 360
    Top = 128
  end
end
