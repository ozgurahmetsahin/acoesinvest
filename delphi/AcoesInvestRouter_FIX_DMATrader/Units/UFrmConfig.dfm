object FrmConfig: TFrmConfig
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Status das Conex'#245'es'
  ClientHeight = 195
  ClientWidth = 307
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 281
    Height = 89
    Caption = 'Sinal de Cota'#231#245'es:'
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 16
      Width = 35
      Height = 13
      Caption = 'Status:'
    end
    object Label2: TLabel
      Left = 57
      Top = 16
      Width = 68
      Height = 13
      Caption = 'Desconectado'
    end
    object LabeledEdit1: TLabeledEdit
      Left = 16
      Top = 51
      Width = 121
      Height = 21
      EditLabel.Width = 40
      EditLabel.Height = 13
      EditLabel.Caption = 'Usu'#225'rio:'
      TabOrder = 0
    end
    object LabeledEdit2: TLabeledEdit
      Left = 143
      Top = 51
      Width = 121
      Height = 21
      EditLabel.Width = 34
      EditLabel.Height = 13
      EditLabel.Caption = 'Senha:'
      PasswordChar = '*'
      TabOrder = 1
    end
    object Button1: TButton
      Left = 205
      Top = 10
      Width = 75
      Height = 25
      Caption = 'Conectar'
      TabOrder = 2
      OnClick = Button1Click
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 103
    Width = 281
    Height = 89
    Caption = 'Sinal de Negocia'#231#245'es:'
    TabOrder = 1
    object Label3: TLabel
      Left = 16
      Top = 16
      Width = 35
      Height = 13
      Caption = 'Status:'
    end
    object Label4: TLabel
      Left = 57
      Top = 16
      Width = 68
      Height = 13
      Caption = 'Desconectado'
    end
    object LabeledEdit3: TLabeledEdit
      Left = 16
      Top = 51
      Width = 121
      Height = 21
      EditLabel.Width = 40
      EditLabel.Height = 13
      EditLabel.Caption = 'Usu'#225'rio:'
      TabOrder = 0
    end
    object LabeledEdit4: TLabeledEdit
      Left = 143
      Top = 51
      Width = 121
      Height = 21
      EditLabel.Width = 34
      EditLabel.Height = 13
      EditLabel.Caption = 'Senha:'
      PasswordChar = '*'
      TabOrder = 1
    end
    object Button2: TButton
      Left = 205
      Top = 11
      Width = 75
      Height = 25
      Caption = 'Conectar'
      TabOrder = 2
      OnClick = Button2Click
    end
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 152
    Top = 88
  end
end
