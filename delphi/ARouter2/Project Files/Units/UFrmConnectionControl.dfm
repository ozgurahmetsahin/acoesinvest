object FrmConnectionControl: TFrmConnectionControl
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'FrmConnectionControl'
  ClientHeight = 76
  ClientWidth = 334
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 96
    Top = 11
    Width = 41
    Height = 13
    Caption = 'Estado:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 154
    Top = 11
    Width = 3
    Height = 13
  end
  object Label4: TLabel
    Left = 96
    Top = 33
    Width = 51
    Height = 13
    Caption = 'Servidor:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 154
    Top = 32
    Width = 3
    Height = 13
  end
  object Label5: TLabel
    Left = 213
    Top = 11
    Width = 72
    Height = 13
    Caption = 'Reconex'#245'es:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label6: TLabel
    Left = 293
    Top = 11
    Width = 6
    Height = 13
    Caption = '0'
  end
  object BtnConnection: TBitBtn
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = 'BtnConnection'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 0
    OnClick = BtnConnectionClick
  end
  object Configurar: TBitBtn
    Left = 8
    Top = 39
    Width = 75
    Height = 25
    Caption = 'Configurar'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 1
  end
  object CkAutoReconnect: TCheckBox
    Left = 96
    Top = 53
    Width = 97
    Height = 17
    Caption = 'Auto-Reconectar'
    TabOrder = 2
  end
  object TimerCheckConnection: TTimer
    Enabled = False
    OnTimer = TimerCheckConnectionTimer
    Left = 192
    Top = 16
  end
end
