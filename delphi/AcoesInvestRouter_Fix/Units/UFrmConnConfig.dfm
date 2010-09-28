object FrmConnConfig: TFrmConnConfig
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Configura'#231#227'o de Conex'#245'es:'
  ClientHeight = 353
  ClientWidth = 314
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 289
    Height = 161
    Caption = 'Configura'#231#227'o para Servidor de Cota'#231#227'o:'
    TabOrder = 0
    object SpeedButton1: TSpeedButton
      Left = 135
      Top = 80
      Width = 23
      Height = 22
      Hint = 'O que '#233' isso?'
      Caption = '?'
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      Left = 135
      Top = 120
      Width = 23
      Height = 22
      Hint = 'O que '#233' isso?'
      Caption = '?'
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton2Click
    end
    object BitBtn1: TBitBtn
      Left = 196
      Top = 75
      Width = 75
      Height = 25
      Caption = 'Aplicar'
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 0
      OnClick = BitBtn1Click
    end
    object BitBtn2: TBitBtn
      Left = 184
      Top = 106
      Width = 97
      Height = 25
      Caption = 'Restaurar Padr'#227'o'
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 1
      OnClick = BitBtn2Click
    end
    object lblEditSvrSignal: TLabeledEdit
      Left = 11
      Top = 35
      Width = 199
      Height = 21
      EditLabel.Width = 102
      EditLabel.Height = 13
      EditLabel.Caption = 'Servidor de Cota'#231#227'o:'
      TabOrder = 2
    end
    object lblEditPortSignal: TLabeledEdit
      Left = 216
      Top = 35
      Width = 43
      Height = 21
      EditLabel.Width = 30
      EditLabel.Height = 13
      EditLabel.Caption = 'Porta:'
      TabOrder = 3
    end
    object lblEditConnTimeOutSignal: TLabeledEdit
      Left = 11
      Top = 80
      Width = 121
      Height = 21
      EditLabel.Width = 156
      EditLabel.Height = 13
      EditLabel.Caption = 'Limite para Conex'#227'o(segundos):'
      TabOrder = 4
    end
    object lblEditReadTimeOutSignal: TLabeledEdit
      Left = 11
      Top = 120
      Width = 121
      Height = 21
      EditLabel.Width = 150
      EditLabel.Height = 13
      EditLabel.Caption = 'Limite de Leitura(milisegundos):'
      TabOrder = 5
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 175
    Width = 289
    Height = 162
    Caption = 'Configura'#231#227'o para Servidor de Negocia'#231#227'o:'
    TabOrder = 1
    object SpeedButton3: TSpeedButton
      Left = 135
      Top = 120
      Width = 23
      Height = 22
      Hint = 'O que '#233' isso?'
      Caption = '?'
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton3Click
    end
    object SpeedButton4: TSpeedButton
      Left = 135
      Top = 80
      Width = 23
      Height = 22
      Hint = 'O que '#233' isso?'
      Caption = '?'
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton4Click
    end
    object BitBtn3: TBitBtn
      Left = 196
      Top = 75
      Width = 75
      Height = 25
      Caption = 'Aplicar'
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 0
      OnClick = BitBtn3Click
    end
    object BitBtn4: TBitBtn
      Left = 184
      Top = 106
      Width = 97
      Height = 25
      Caption = 'Restaurar Padr'#227'o'
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 1
      OnClick = BitBtn4Click
    end
    object lblEdtSvrBroker: TLabeledEdit
      Left = 11
      Top = 35
      Width = 199
      Height = 21
      EditLabel.Width = 117
      EditLabel.Height = 13
      EditLabel.Caption = 'Servidor de Negocia'#231#227'o:'
      TabOrder = 2
    end
    object lblEdtPortBroker: TLabeledEdit
      Left = 216
      Top = 35
      Width = 43
      Height = 21
      EditLabel.Width = 30
      EditLabel.Height = 13
      EditLabel.Caption = 'Porta:'
      TabOrder = 3
    end
    object lbLEdtReadTimeOutBroker: TLabeledEdit
      Left = 11
      Top = 121
      Width = 121
      Height = 21
      EditLabel.Width = 150
      EditLabel.Height = 13
      EditLabel.Caption = 'Limite de Leitura(milisegundos):'
      TabOrder = 4
    end
    object lblEdtConnTimeOutBroker: TLabeledEdit
      Left = 11
      Top = 81
      Width = 121
      Height = 21
      EditLabel.Width = 156
      EditLabel.Height = 13
      EditLabel.Caption = 'Limite para Conex'#227'o(segundos):'
      TabOrder = 5
    end
  end
end
