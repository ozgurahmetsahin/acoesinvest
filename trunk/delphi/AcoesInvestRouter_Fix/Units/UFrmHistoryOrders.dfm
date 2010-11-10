object FrmHistoryOrders: TFrmHistoryOrders
  Left = 335
  Top = 222
  Caption = 'Hist'#243'rico de Ordens'
  ClientHeight = 271
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
  object Panel1: TPanel
    Left = 0
    Top = 244
    Width = 881
    Height = 27
    Align = alBottom
    BevelOuter = bvNone
    Color = clBlack
    Ctl3D = False
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 0
    ExplicitTop = 243
    object Shape1: TShape
      Left = 61
      Top = 5
      Width = 18
      Height = 16
      Brush.Color = clLime
    end
    object Shape2: TShape
      Left = 145
      Top = 5
      Width = 18
      Height = 16
      Brush.Color = clRed
    end
    object Label1: TLabel
      Left = 87
      Top = 6
      Width = 51
      Height = 13
      Caption = 'Executada'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 170
      Top = 6
      Width = 46
      Height = 13
      Caption = 'Rejeitada'
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
      Brush.Color = clYellow
    end
    object Label3: TLabel
      Left = 248
      Top = 6
      Width = 44
      Height = 13
      Caption = 'Recebida'
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
      Brush.Color = 16744448
    end
    object Label4: TLabel
      Left = 326
      Top = 6
      Width = 50
      Height = 13
      Caption = 'Cancelada'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
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
    end
    object Label6: TLabel
      Left = 410
      Top = 8
      Width = 33
      Height = 13
      Caption = 'Outros'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 789
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
    object CheckBox1: TCheckBox
      Left = 769
      Top = 5
      Width = 97
      Height = 17
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      State = cbChecked
      TabOrder = 0
      OnClick = CheckBox1Click
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 881
    Height = 244
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 1
    TabPosition = tpBottom
    ExplicitHeight = 251
    object TabSheet1: TTabSheet
      Caption = 'Ordens'
      ExplicitHeight = 225
      object HistorySheet: TSheet
        Left = 0
        Top = 0
        Width = 873
        Height = 218
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
        ExplicitHeight = 225
        RowHeights = (
          17
          17)
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Start/Stop'
      ImageIndex = 1
      ExplicitHeight = 225
      object StartStopSheet: TSheet
        Left = 0
        Top = 0
        Width = 873
        Height = 218
        Align = alClient
        ColCount = 12
        DefaultRowHeight = 17
        FixedCols = 0
        RowCount = 2
        PopupMenu = PopupMenu2
        TabOrder = 0
        ColumsVisible = [clQuote, clPicture, clLast, clVar, clBuy, clSell, clStatus, clBaseIn, clObj1, clObj2, clObj3, clObj4]
        StringclQuote = 'C'#243'd.'
        StringclPicture = 'Start/Stop'
        StringclLast = 'Ativo'
        StringclVar = 'Qtde'
        StringclBuy = 'Start Compra Disparo'
        StringclSell = 'Start Lim.'
        StringclStatus = 'Stop Gain Disp.'
        StringclBaseIn = 'Stop Gain Lim.'
        StringclObj1 = 'Stop Loss Disp.'
        StringclObj2 = 'Stop Loss Lim.'
        StringclObj3 = 'Validade'
        StringclObj4 = 'Status'
        FilterColums = stAll
        FontColorPaint = clBlack
        EvenColorLine = clBlack
        OddColorLine = clBlack
        ShowClearLine = False
        ExplicitHeight = 225
        ColWidths = (
          64
          68
          64
          64
          64
          64
          94
          88
          90
          86
          96
          64)
        RowHeights = (
          17
          17)
      end
    end
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
  object PopupMenu2: TPopupMenu
    Left = 288
    Top = 160
    object Cancelar2: TMenuItem
      Caption = 'Cancelar'
      OnClick = Cancelar2Click
    end
  end
end
