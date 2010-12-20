object FrmBrokerBuy: TFrmBrokerBuy
  Left = 510
  Top = 222
  BorderStyle = bsDialog
  Caption = 'Compra'
  ClientHeight = 285
  ClientWidth = 407
  Color = 8454143
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = [fsBold]
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesigned
  OnClose = FormClose
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Shape1: TShape
    Left = 0
    Top = 0
    Width = 407
    Height = 285
    Align = alClient
    Brush.Color = 8454143
    ExplicitHeight = 246
  end
  object Label1: TLabel
    Left = 16
    Top = 74
    Width = 48
    Height = 13
    Caption = 'Validade'
  end
  object Label2: TLabel
    Left = 143
    Top = 74
    Width = 53
    Height = 13
    Caption = 'At'#233' o dia:'
  end
  object Label16: TLabel
    Left = 16
    Top = 8
    Width = 42
    Height = 13
    Caption = 'Cliente:'
  end
  object Label17: TLabel
    Left = 62
    Top = 8
    Width = 3
    Height = 13
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label22: TLabel
    Left = 16
    Top = 24
    Width = 68
    Height = 13
    Caption = 'C'#243'd. Ordem:'
    Visible = False
  end
  object Label23: TLabel
    Left = 90
    Top = 24
    Width = 3
    Height = 13
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
  end
  object LabeledEdit1: TLabeledEdit
    Left = 16
    Top = 52
    Width = 121
    Height = 19
    CharCase = ecUpperCase
    Ctl3D = False
    EditLabel.Width = 33
    EditLabel.Height = 13
    EditLabel.Caption = 'Ativo:'
    ParentCtl3D = False
    TabOrder = 0
    OnChange = LabeledEdit1Change
    OnExit = LabeledEdit1Exit
  end
  object LabeledEdit2: TLabeledEdit
    Left = 143
    Top = 52
    Width = 121
    Height = 19
    Ctl3D = False
    EditLabel.Width = 68
    EditLabel.Height = 13
    EditLabel.Caption = 'Quantidade:'
    NumbersOnly = True
    ParentCtl3D = False
    TabOrder = 1
    OnChange = LabeledEdit2Change
  end
  object LabeledEdit3: TLabeledEdit
    Left = 270
    Top = 52
    Width = 93
    Height = 19
    Ctl3D = False
    EditLabel.Width = 35
    EditLabel.Height = 13
    EditLabel.Caption = 'Pre'#231'o:'
    ParentCtl3D = False
    TabOrder = 2
    OnChange = LabeledEdit2Change
    OnKeyPress = LabeledEdit3KeyPress
  end
  object ComboBox1: TComboBox
    Left = 16
    Top = 93
    Width = 121
    Height = 22
    Style = csOwnerDrawFixed
    ItemIndex = 0
    TabOrder = 3
    Text = 'Hoje'
    OnChange = ComboBox1Change
    Items.Strings = (
      'Hoje'
      'At'#233' cancelar'
      'Data espec.'
      'Tudo ou Nada'
      'Exec. ou Canc.')
  end
  object DateTimePicker1: TDateTimePicker
    Left = 143
    Top = 93
    Width = 121
    Height = 21
    Date = 40114.471061990740000000
    Time = 40114.471061990740000000
    TabOrder = 4
    OnChange = DateTimePicker1Change
  end
  object BitBtn1: TBitBtn
    Left = 288
    Top = 147
    Width = 59
    Height = 25
    Caption = 'Enviar'
    Default = True
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 6
    OnClick = BitBtn1Click
  end
  object BitBtn2: TBitBtn
    Left = 288
    Top = 178
    Width = 60
    Height = 25
    Caption = 'Cancelar'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 7
    OnClick = BitBtn2Click
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 325
    Width = 391
    Height = 81
    Caption = 'Resumo da ordem:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 8
    OnMouseMove = GroupBox1MouseMove
    object Label3: TLabel
      Left = 8
      Top = 16
      Width = 33
      Height = 13
      Caption = 'Ativo:'
    end
    object Label4: TLabel
      Left = 48
      Top = 16
      Width = 3
      Height = 13
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsUnderline]
      ParentFont = False
    end
    object Label5: TLabel
      Left = 113
      Top = 15
      Width = 30
      Height = 13
      Caption = 'Qtde.'
    end
    object Label6: TLabel
      Left = 153
      Top = 15
      Width = 3
      Height = 13
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsUnderline]
      ParentFont = False
    end
    object Label7: TLabel
      Left = 240
      Top = 14
      Width = 32
      Height = 13
      Caption = 'Total:'
    end
    object Label8: TLabel
      Left = 280
      Top = 14
      Width = 3
      Height = 13
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsUnderline]
      ParentFont = False
    end
    object Label9: TLabel
      Left = 62
      Top = 35
      Width = 22
      Height = 13
      Caption = 'Hoje'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsUnderline]
      ParentFont = False
    end
    object Label10: TLabel
      Left = 8
      Top = 35
      Width = 48
      Height = 13
      Caption = 'Validade'
    end
    object Label11: TLabel
      Left = 113
      Top = 34
      Width = 53
      Height = 13
      Caption = 'At'#233' o dia:'
    end
    object Label12: TLabel
      Left = 171
      Top = 34
      Width = 3
      Height = 13
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsUnderline]
      ParentFont = False
    end
    object Label13: TLabel
      Left = 113
      Top = 54
      Width = 71
      Height = 13
      Caption = #218'lt. Cota'#231#227'o:'
    end
    object Label14: TLabel
      Left = 189
      Top = 54
      Width = 3
      Height = 13
      Cursor = crHandPoint
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsUnderline]
      ParentFont = False
      OnClick = Label14Click
      OnMouseMove = Label14MouseMove
    end
    object Label24: TLabel
      Left = 8
      Top = 54
      Width = 52
      Height = 13
      Caption = 'Mercado:'
    end
    object Label25: TLabel
      Left = 66
      Top = 54
      Width = 3
      Height = 13
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object GroupBox2: TGroupBox
    Left = 16
    Top = 232
    Width = 383
    Height = 42
    Caption = 'Informa'#231#245'es:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 9
    object Label15: TLabel
      Left = 9
      Top = 19
      Width = 3
      Height = 13
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 225
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object LabeledEdit4: TLabeledEdit
    Left = 128
    Top = 412
    Width = 93
    Height = 19
    Ctl3D = False
    EditLabel.Width = 72
    EditLabel.Height = 13
    EditLabel.Caption = 'LabeledEdit4'
    ParentCtl3D = False
    TabOrder = 5
    Visible = False
  end
  object CheckBox1: TCheckBox
    Left = 301
    Top = 20
    Width = 103
    Height = 17
    Caption = 'Sempre Vis'#237'vel'
    Checked = True
    State = cbChecked
    TabOrder = 10
    OnClick = CheckBox1Click
  end
  object GroupBox4: TGroupBox
    Left = 16
    Top = 119
    Width = 248
    Height = 107
    Caption = 'Op'#231#245'es:'
    TabOrder = 11
    object Label26: TLabel
      Left = 94
      Top = 46
      Width = 54
      Height = 13
      Caption = '(Stop Gain)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label27: TLabel
      Left = 94
      Top = 79
      Width = 54
      Height = 13
      Caption = '(Stop Loss)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label28: TLabel
      Left = 170
      Top = 19
      Width = 35
      Height = 13
      Caption = 'Pre'#231'o:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object CheckBox2: TCheckBox
      Left = 16
      Top = 28
      Width = 145
      Height = 17
      Caption = 'Fechar com ganhos: '
      TabOrder = 0
      OnClick = CheckBox2Click
    end
    object Edit1: TEdit
      Left = 157
      Top = 33
      Width = 73
      Height = 21
      TabOrder = 1
    end
    object CheckBox3: TCheckBox
      Left = 16
      Top = 65
      Width = 167
      Height = 17
      Caption = 'Fechar com perdas:'
      TabOrder = 2
      OnClick = CheckBox3Click
    end
    object Edit2: TEdit
      Left = 157
      Top = 67
      Width = 73
      Height = 21
      TabOrder = 3
    end
  end
  object GroupBox3: TGroupBox
    Left = 270
    Top = 77
    Width = 129
    Height = 55
    Caption = 'Compra/Venda'
    TabOrder = 12
    object Label20: TLabel
      Left = 9
      Top = 38
      Width = 38
      Height = 13
      Caption = 'Venda:'
    end
    object Label21: TLabel
      Left = 62
      Top = 38
      Width = 30
      Height = 13
      Cursor = crHandPoint
      Caption = '69000'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      OnClick = Label21Click
      OnMouseMove = Label21MouseMove
    end
    object Label19: TLabel
      Left = 62
      Top = 19
      Width = 30
      Height = 13
      Cursor = crHandPoint
      Caption = '69000'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      OnClick = Label19Click
      OnMouseMove = Label19MouseMove
    end
    object Label18: TLabel
      Left = 9
      Top = 19
      Width = 47
      Height = 13
      Caption = 'Compra:'
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer1Timer
    Left = 208
    Top = 120
  end
end
