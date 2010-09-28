object FrmOpenChart: TFrmOpenChart
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Novo Gr'#225'fico:'
  ClientHeight = 80
  ClientWidth = 280
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 95
    Top = 13
    Width = 40
    Height = 13
    Caption = 'Periodo:'
  end
  object LabeledEdit1: TLabeledEdit
    Left = 8
    Top = 32
    Width = 81
    Height = 21
    EditLabel.Width = 29
    EditLabel.Height = 13
    EditLabel.Caption = 'Ativo:'
    TabOrder = 0
  end
  object ComboBox1: TComboBox
    Left = 95
    Top = 32
    Width = 90
    Height = 21
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 1
    Text = '1 minuto'
    Items.Strings = (
      '1 minuto'
      '5 mintos'
      '10 minutos'
      '15 minutos'
      '30 minutos'
      'Di'#225'rio'
      'Mensal')
  end
  object Button1: TButton
    Left = 195
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Abrir'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 195
    Top = 39
    Width = 75
    Height = 25
    Caption = 'Cancelar'
    TabOrder = 3
    OnClick = Button2Click
  end
end
