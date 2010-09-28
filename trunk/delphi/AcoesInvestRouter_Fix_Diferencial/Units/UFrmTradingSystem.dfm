inherited FrmTradingSystem: TFrmTradingSystem
  Caption = 'Planilha Trading System'
  ClientHeight = 432
  ClientWidth = 947
  OnShow = FormShow
  ExplicitWidth = 963
  ExplicitHeight = 468
  PixelsPerInch = 96
  TextHeight = 13
  object Label28: TLabel [0]
    Left = 197
    Top = 63
    Width = 30
    Height = 13
    Caption = 'Obj. 3'
  end
  object Label29: TLabel [1]
    Left = 200
    Top = 75
    Width = 46
    Height = 13
    Caption = '90000.00'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  inherited TradeSheet: TSheet
    Width = 947
    Height = 255
    ColCount = 17
    OnClick = TradeSheetClick
    ColumsVisible = [clQuote, clPicture, clLast, clVar, clBuy, clSell, clStatus, clBaseIn, clObj1, clObj2, clObj3, clObj4, clMax, clMin, clOpen, clClose, clNeg]
    StringclStatus = 'Situa'#231#227'o'
    StringclBaseIn = 'Pt. C/V em'
    StringclObj1 = 'Obj. 1'
    StringclObj2 = 'Obj. 2'
    StringclObj3 = 'Obj. 3'
    StringclObj4 = 'Obj. 4'
    ExplicitWidth = 947
    ExplicitHeight = 255
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
      64
      64
      64
      64
      64
      64
      64)
  end
  inherited Panel1: TPanel
    Width = 947
    ExplicitWidth = 947
    object SpeedButton3: TSpeedButton [3]
      Left = 235
      Top = 0
      Width = 23
      Height = 22
      Hint = 'Ocultar Painel'
      Caption = 'H'
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton3Click
    end
  end
  object GroupBox1: TGroupBox [4]
    Left = 0
    Top = 277
    Width = 947
    Height = 155
    Align = alBottom
    Caption = 'ATIVO:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    Visible = False
    object Bevel6: TBevel
      Left = 621
      Top = 32
      Width = 61
      Height = 76
      Shape = bsFrame
    end
    object Bevel3: TBevel
      Left = 621
      Top = 117
      Width = 61
      Height = 33
      Shape = bsFrame
    end
    object Bevel2: TBevel
      Left = 315
      Top = 32
      Width = 305
      Height = 76
      Shape = bsFrame
    end
    object Bevel1: TBevel
      Left = 118
      Top = 32
      Width = 193
      Height = 76
      Shape = bsFrame
    end
    object Label2: TLabel
      Left = 134
      Top = 42
      Width = 18
      Height = 13
      Caption = 'Dia'
    end
    object Label3: TLabel
      Left = 176
      Top = 42
      Width = 22
      Height = 13
      Caption = '0.00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 134
      Top = 68
      Width = 31
      Height = 13
      Caption = 'Sem. '
    end
    object Label5: TLabel
      Left = 176
      Top = 68
      Width = 22
      Height = 13
      Caption = '0.00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 223
      Top = 42
      Width = 23
      Height = 13
      Caption = 'M'#234's'
    end
    object Label7: TLabel
      Left = 262
      Top = 42
      Width = 22
      Height = 13
      Caption = '0.00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label8: TLabel
      Left = 223
      Top = 68
      Width = 22
      Height = 13
      Caption = 'Ano'
    end
    object Label9: TLabel
      Left = 262
      Top = 68
      Width = 22
      Height = 13
      Caption = '0.00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label10: TLabel
      Left = 386
      Top = 38
      Width = 18
      Height = 13
      Caption = 'Dia'
    end
    object Label11: TLabel
      Left = 439
      Top = 38
      Width = 46
      Height = 13
      Caption = 'Semana'
    end
    object Label12: TLabel
      Left = 506
      Top = 38
      Width = 23
      Height = 13
      Caption = 'M'#234's'
    end
    object Label14: TLabel
      Left = 379
      Top = 57
      Width = 46
      Height = 13
      Caption = '90000.00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label15: TLabel
      Left = 442
      Top = 57
      Width = 46
      Height = 13
      Caption = '90000.00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label16: TLabel
      Left = 502
      Top = 57
      Width = 46
      Height = 13
      Caption = '90000.00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label13: TLabel
      Left = 566
      Top = 38
      Width = 22
      Height = 13
      Caption = 'Ano'
    end
    object Label17: TLabel
      Left = 563
      Top = 57
      Width = 46
      Height = 13
      Caption = '90000.00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label18: TLabel
      Left = 631
      Top = 120
      Width = 26
      Height = 13
      Caption = 'Stop'
    end
    object Label19: TLabel
      Left = 631
      Top = 132
      Width = 22
      Height = 13
      Caption = '0.00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Bevel4: TBevel
      Left = 7
      Top = 117
      Width = 304
      Height = 33
      Shape = bsFrame
    end
    object Label20: TLabel
      Left = 14
      Top = 120
      Width = 62
      Height = 13
      Caption = 'Pt. Compra'
    end
    object Label21: TLabel
      Left = 14
      Top = 132
      Width = 46
      Height = 13
      Caption = '90000.00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label22: TLabel
      Left = 85
      Top = 132
      Width = 46
      Height = 13
      Caption = '90000.00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label23: TLabel
      Left = 85
      Top = 120
      Width = 32
      Height = 13
      Caption = 'Obj. 1'
    end
    object Label24: TLabel
      Left = 140
      Top = 120
      Width = 32
      Height = 13
      Caption = 'Obj. 2'
    end
    object Label25: TLabel
      Left = 140
      Top = 132
      Width = 46
      Height = 13
      Caption = '90000.00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label26: TLabel
      Left = 199
      Top = 132
      Width = 46
      Height = 13
      Caption = '90000.00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label27: TLabel
      Left = 197
      Top = 120
      Width = 32
      Height = 13
      Caption = 'Obj. 3'
    end
    object Label30: TLabel
      Left = 254
      Top = 120
      Width = 32
      Height = 13
      Caption = 'Obj. 4'
    end
    object Label31: TLabel
      Left = 256
      Top = 132
      Width = 46
      Height = 13
      Caption = '90000.00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Bevel5: TBevel
      Left = 316
      Top = 117
      Width = 304
      Height = 33
      Shape = bsFrame
    end
    object Label32: TLabel
      Left = 323
      Top = 120
      Width = 53
      Height = 13
      Caption = 'Pt. Venda'
    end
    object Label33: TLabel
      Left = 323
      Top = 132
      Width = 46
      Height = 13
      Caption = '90000.00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label34: TLabel
      Left = 394
      Top = 132
      Width = 46
      Height = 13
      Caption = '90000.00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label35: TLabel
      Left = 394
      Top = 120
      Width = 32
      Height = 13
      Caption = 'Obj. 1'
    end
    object Label36: TLabel
      Left = 449
      Top = 120
      Width = 32
      Height = 13
      Caption = 'Obj. 2'
    end
    object Label37: TLabel
      Left = 449
      Top = 132
      Width = 46
      Height = 13
      Caption = '90000.00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label38: TLabel
      Left = 508
      Top = 132
      Width = 46
      Height = 13
      Caption = '90000.00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label39: TLabel
      Left = 506
      Top = 120
      Width = 32
      Height = 13
      Caption = 'Obj. 3'
    end
    object Label40: TLabel
      Left = 563
      Top = 120
      Width = 32
      Height = 13
      Caption = 'Obj. 4'
    end
    object Label41: TLabel
      Left = 565
      Top = 132
      Width = 46
      Height = 13
      Caption = '90000.00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label42: TLabel
      Left = 317
      Top = 13
      Width = 114
      Height = 13
      Caption = 'M'#225'ximas e M'#237'nimas:'
    end
    object Label43: TLabel
      Left = 379
      Top = 79
      Width = 46
      Height = 13
      Caption = '90000.00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label44: TLabel
      Left = 639
      Top = 38
      Width = 24
      Height = 13
      Caption = 'Sup.'
    end
    object Label45: TLabel
      Left = 442
      Top = 79
      Width = 46
      Height = 13
      Caption = '90000.00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label46: TLabel
      Left = 502
      Top = 79
      Width = 46
      Height = 13
      Caption = '90000.00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label47: TLabel
      Left = 639
      Top = 74
      Width = 24
      Height = 13
      Caption = 'Res.'
    end
    object Label49: TLabel
      Left = 563
      Top = 79
      Width = 46
      Height = 13
      Caption = '90000.00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label50: TLabel
      Left = 321
      Top = 57
      Width = 54
      Height = 13
      Caption = 'M'#225'ximas:'
    end
    object Label51: TLabel
      Left = 321
      Top = 79
      Width = 50
      Height = 13
      Caption = 'M'#237'nimas:'
    end
    object Label52: TLabel
      Left = 121
      Top = 13
      Width = 70
      Height = 13
      Caption = 'Percentuais:'
    end
    object Label48: TLabel
      Left = 640
      Top = 55
      Width = 22
      Height = 13
      Caption = '0.00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label53: TLabel
      Left = 640
      Top = 89
      Width = 22
      Height = 13
      Caption = '0.00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Chart1: TChart
      Left = 683
      Top = 6
      Width = 258
      Height = 127
      Legend.Visible = False
      MarginLeft = 7
      MarginRight = 7
      Title.Font.Color = clBlack
      Title.Font.Style = [fsBold]
      Title.Text.Strings = (
        'Pre'#231'o m'#233'dio dos '#250'ltimos 30 preg'#245'es: 68000,00')
      LeftAxis.GridCentered = True
      LeftAxis.Logarithmic = True
      LeftAxis.StartPosition = 13.000000000000000000
      LeftAxis.EndPosition = 88.000000000000000000
      LeftAxis.Visible = False
      Pages.MaxPointsPerPage = 5
      RightAxis.Visible = False
      TopAxis.Visible = False
      View3DWalls = False
      BevelOuter = bvNone
      TabOrder = 0
      PrintMargins = (
        15
        22
        15
        22)
      object Series1: TBarSeries
        BarBrush.Color = clWhite
        BarBrush.Style = bsDiagCross
        BarBrush.Image.Data = {
          07544269746D61707E000000424D7E000000000000003E000000280000001000
          0000100000000100010000000000400000000000000000000000020000000200
          000000000000FFFFFF00BBBB000077770000EEEE0000DDDD0000BBBB00007777
          0000EEEE0000DDDD0000BBBB000077770000EEEE0000DDDD0000BBBB00007777
          0000EEEE0000DDDD0000}
        Marks.Arrow.Visible = True
        Marks.Callout.Brush.Color = clBlack
        Marks.Callout.Arrow.Visible = True
        Marks.Frame.Visible = False
        Marks.Style = smsValue
        Marks.Transparent = True
        Marks.Visible = True
        Transparency = 22
        BarStyle = bsRectGradient
        BarWidthPercent = 55
        DepthPercent = 50
        Gradient.Direction = gdTopBottom
        SideMargins = False
        StackGroup = 16
        XValues.Name = 'X'
        XValues.Order = loAscending
        YValues.Name = 'Bar'
        YValues.Order = loNone
        Data = {
          04060000000000000000605340FF0200000030300000000000806140FF020000
          0030300000000000606D40FF0200000030300000000000507440FF0200000030
          300000000000307140FF0200000030300000000000B87540FF020000003030}
      end
    end
    object ScrollBar1: TScrollBar
      Left = 683
      Top = 133
      Width = 258
      Height = 17
      PageSize = 0
      TabOrder = 1
      OnChange = ScrollBar1Change
    end
    object GroupBox2: TGroupBox
      Left = 5
      Top = 13
      Width = 112
      Height = 95
      Caption = 'Term. Ibovespa:'
      TabOrder = 2
      object Gauge1: TGauge
        Left = 11
        Top = 19
        Width = 26
        Height = 63
        BorderStyle = bsNone
        ForeColor = clLime
        Kind = gkVerticalBar
        MaxValue = 66
        Progress = 50
        ShowText = False
      end
      object Label54: TLabel
        Left = 16
        Top = 42
        Width = 14
        Height = 13
        Caption = '66'
      end
      object Label55: TLabel
        Left = 12
        Top = 81
        Width = 23
        Height = 13
        Caption = 'Alta'
      end
      object Label56: TLabel
        Left = 42
        Top = 81
        Width = 27
        Height = 13
        Caption = 'Lado'
      end
      object Gauge2: TGauge
        Left = 43
        Top = 19
        Width = 26
        Height = 63
        BorderStyle = bsNone
        ForeColor = clYellow
        Kind = gkVerticalBar
        MaxValue = 66
        Progress = 50
        ShowText = False
      end
      object Label57: TLabel
        Left = 48
        Top = 42
        Width = 14
        Height = 13
        Caption = '66'
      end
      object Label58: TLabel
        Left = 75
        Top = 81
        Width = 31
        Height = 13
        Caption = 'Baixa'
      end
      object Gauge3: TGauge
        Left = 78
        Top = 19
        Width = 26
        Height = 63
        BorderStyle = bsNone
        ForeColor = clRed
        Kind = gkVerticalBar
        MaxValue = 66
        Progress = 50
        ShowText = False
      end
      object Label59: TLabel
        Left = 80
        Top = 42
        Width = 14
        Height = 13
        Caption = '66'
      end
      object Bevel7: TBevel
        Left = 10
        Top = 19
        Width = 30
        Height = 64
        Shape = bsFrame
      end
      object Bevel8: TBevel
        Left = 43
        Top = 19
        Width = 30
        Height = 64
        Shape = bsFrame
      end
      object Bevel9: TBevel
        Left = 76
        Top = 19
        Width = 30
        Height = 64
        Shape = bsFrame
      end
    end
  end
  object TimerPanel: TTimer
    Interval = 100
    OnTimer = TimerPanelTimer
    Left = 312
    Top = 120
  end
end
