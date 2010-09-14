object FrmStartStop: TFrmStartStop
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Start e Stop'
  ClientHeight = 375
  ClientWidth = 417
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = [fsBold]
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 417
    Height = 375
    ActivePage = TabSheet2
    Align = alClient
    TabOrder = 0
    OnChange = PageControl1Change
    object TabSheet1: TTabSheet
      Caption = 'Start'
      object Shape1: TShape
        Left = 0
        Top = 0
        Width = 409
        Height = 347
        Align = alClient
        Brush.Color = 8454143
        ExplicitWidth = 407
        ExplicitHeight = 246
      end
      object Label1: TLabel
        Left = 8
        Top = 132
        Width = 48
        Height = 13
        Caption = 'Validade'
      end
      object Label4: TLabel
        Left = 5
        Top = 16
        Width = 42
        Height = 13
        Caption = 'Cliente:'
      end
      object Label5: TLabel
        Left = 53
        Top = 16
        Width = 3
        Height = 13
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LabeledEdit1: TLabeledEdit
        Left = 8
        Top = 56
        Width = 121
        Height = 19
        CharCase = ecUpperCase
        Ctl3D = False
        EditLabel.Width = 30
        EditLabel.Height = 13
        EditLabel.Caption = 'Ativo'
        ParentCtl3D = False
        TabOrder = 0
        OnChange = LabeledEdit1Change
      end
      object LabeledEdit2: TLabeledEdit
        Left = 138
        Top = 56
        Width = 121
        Height = 19
        Ctl3D = False
        EditLabel.Width = 65
        EditLabel.Height = 13
        EditLabel.Caption = 'Quantidade'
        NumbersOnly = True
        ParentCtl3D = False
        TabOrder = 1
        OnChange = LabeledEdit2Change
      end
      object LabeledEdit3: TLabeledEdit
        Left = 8
        Top = 104
        Width = 121
        Height = 19
        Ctl3D = False
        EditLabel.Width = 81
        EditLabel.Height = 13
        EditLabel.Caption = 'Pre'#231'o Disparo:'
        ParentCtl3D = False
        TabOrder = 2
        OnChange = LabeledEdit3Change
        OnKeyPress = LabeledEdit3KeyPress
      end
      object DateTimePicker1: TDateTimePicker
        Left = 8
        Top = 151
        Width = 148
        Height = 21
        Date = 40115.827286203700000000
        Time = 40115.827286203700000000
        TabOrder = 4
      end
      object LabeledEdit4: TLabeledEdit
        Left = 149
        Top = 104
        Width = 121
        Height = 19
        Ctl3D = False
        EditLabel.Width = 82
        EditLabel.Height = 13
        EditLabel.Caption = 'Pre'#231'o Compra:'
        ParentCtl3D = False
        TabOrder = 3
        OnChange = LabeledEdit4Change
        OnKeyPress = LabeledEdit4KeyPress
      end
      object BitBtn1: TBitBtn
        Left = 104
        Top = 256
        Width = 75
        Height = 25
        Caption = 'Enviar'
        Default = True
        DoubleBuffered = True
        ParentDoubleBuffered = False
        TabOrder = 5
        OnClick = BitBtn1Click
      end
      object BitBtn2: TBitBtn
        Left = 208
        Top = 256
        Width = 75
        Height = 25
        Caption = 'Cancelar'
        DoubleBuffered = True
        ParentDoubleBuffered = False
        TabOrder = 6
        OnClick = BitBtn2Click
      end
      object GroupBox1: TGroupBox
        Left = 8
        Top = 186
        Width = 393
        Height = 47
        Caption = 'Informa'#231#245'es:'
        Color = 8454143
        ParentBackground = False
        ParentColor = False
        TabOrder = 7
        object Label3: TLabel
          Left = 16
          Top = 20
          Width = 3
          Height = 13
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 196
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
      end
    end
    object Stop: TTabSheet
      Caption = 'Stop'
      ImageIndex = 1
      object Shape2: TShape
        Left = 0
        Top = 0
        Width = 409
        Height = 347
        Align = alClient
        Brush.Color = 8454016
        ExplicitLeft = 240
        ExplicitTop = 107
        ExplicitWidth = 65
        ExplicitHeight = 65
      end
      object Label2: TLabel
        Left = 17
        Top = 206
        Width = 51
        Height = 13
        Caption = 'Validade:'
      end
      object Label7: TLabel
        Left = 10
        Top = 11
        Width = 42
        Height = 13
        Caption = 'Cliente:'
      end
      object Label8: TLabel
        Left = 56
        Top = 11
        Width = 3
        Height = 13
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LabeledEdit5: TLabeledEdit
        Left = 10
        Top = 49
        Width = 121
        Height = 19
        CharCase = ecUpperCase
        Ctl3D = False
        EditLabel.Width = 30
        EditLabel.Height = 13
        EditLabel.Caption = 'Ativo'
        ParentCtl3D = False
        TabOrder = 0
        OnChange = LabeledEdit5Change
      end
      object LabeledEdit6: TLabeledEdit
        Left = 144
        Top = 49
        Width = 121
        Height = 19
        Ctl3D = False
        EditLabel.Width = 65
        EditLabel.Height = 13
        EditLabel.Caption = 'Quantidade'
        NumbersOnly = True
        ParentCtl3D = False
        TabOrder = 1
        OnChange = LabeledEdit6Change
      end
      object DateTimePicker2: TDateTimePicker
        Left = 17
        Top = 219
        Width = 186
        Height = 21
        Date = 40115.892362187500000000
        Time = 40115.892362187500000000
        TabOrder = 4
      end
      object BitBtn3: TBitBtn
        Left = 116
        Top = 313
        Width = 75
        Height = 25
        Caption = 'Enviar'
        DoubleBuffered = True
        ParentDoubleBuffered = False
        TabOrder = 5
        OnClick = BitBtn3Click
      end
      object BitBtn4: TBitBtn
        Left = 208
        Top = 314
        Width = 75
        Height = 25
        Caption = 'Cancelar'
        DoubleBuffered = True
        ParentDoubleBuffered = False
        TabOrder = 6
        OnClick = BitBtn4Click
      end
      object GroupBox2: TGroupBox
        Left = 10
        Top = 246
        Width = 383
        Height = 61
        Caption = 'Informa'#231#245'es'
        Color = 8454016
        ParentBackground = False
        ParentColor = False
        TabOrder = 7
        object Label6: TLabel
          Left = 15
          Top = 19
          Width = 3
          Height = 13
        end
      end
      object GroupBox3: TGroupBox
        Left = 10
        Top = 79
        Width = 273
        Height = 58
        Caption = 'Ganho:'
        Color = 8454016
        ParentBackground = False
        ParentColor = False
        TabOrder = 2
        object LabeledEdit7: TLabeledEdit
          Left = 7
          Top = 32
          Width = 121
          Height = 19
          Ctl3D = False
          EditLabel.Width = 81
          EditLabel.Height = 13
          EditLabel.Caption = 'Pre'#231'o Disparo:'
          ParentCtl3D = False
          TabOrder = 0
          OnChange = LabeledEdit7Change
          OnKeyPress = LabeledEdit7KeyPress
        end
        object LabeledEdit9: TLabeledEdit
          Left = 143
          Top = 32
          Width = 121
          Height = 19
          Ctl3D = False
          EditLabel.Width = 87
          EditLabel.Height = 13
          EditLabel.Caption = 'Pre'#231'o de Venda'
          ParentCtl3D = False
          TabOrder = 1
          OnChange = LabeledEdit9Change
          OnKeyPress = LabeledEdit9KeyPress
        end
      end
      object GroupBox4: TGroupBox
        Left = 10
        Top = 140
        Width = 273
        Height = 65
        Caption = 'Venda:'
        Color = 8454016
        ParentBackground = False
        ParentColor = False
        TabOrder = 3
        object LabeledEdit8: TLabeledEdit
          Left = 8
          Top = 35
          Width = 121
          Height = 19
          Ctl3D = False
          EditLabel.Width = 81
          EditLabel.Height = 13
          EditLabel.Caption = 'Pre'#231'o Disparo:'
          ParentCtl3D = False
          TabOrder = 0
          OnChange = LabeledEdit8Change
          OnKeyPress = LabeledEdit8KeyPress
        end
        object LabeledEdit10: TLabeledEdit
          Left = 144
          Top = 35
          Width = 121
          Height = 19
          Ctl3D = False
          EditLabel.Width = 87
          EditLabel.Height = 13
          EditLabel.Caption = 'Pre'#231'o de Venda'
          ParentCtl3D = False
          TabOrder = 1
          OnChange = LabeledEdit10Change
          OnKeyPress = LabeledEdit10KeyPress
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Consultar Ordens'
      ImageIndex = 2
      object StartStopSheet: TSheet
        Left = 0
        Top = 0
        Width = 409
        Height = 347
        Align = alClient
        ColCount = 12
        DefaultRowHeight = 17
        FixedCols = 0
        RowCount = 2
        PopupMenu = PopupMenu1
        TabOrder = 0
        OnMouseDown = StartStopSheetMouseDown
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
    Left = 192
    Top = 136
    object Cancelar1: TMenuItem
      Caption = 'Cancelar'
      OnClick = Cancelar1Click
    end
  end
end
