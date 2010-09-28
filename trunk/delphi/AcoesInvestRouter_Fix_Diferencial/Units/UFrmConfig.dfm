object FrmConfig: TFrmConfig
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Configura'#231#245'es'
  ClientHeight = 137
  ClientWidth = 314
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 314
    Height = 102
    ActivePage = TabSheet2
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Servidor Cota'#231#245'es'
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 306
        Height = 74
        Align = alClient
        BevelKind = bkFlat
        BevelOuter = bvLowered
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 0
        object LabeledEdit3: TLabeledEdit
          Left = 16
          Top = 36
          Width = 121
          Height = 19
          EditLabel.Width = 102
          EditLabel.Height = 13
          EditLabel.Caption = 'Servidor de Cota'#231#227'o:'
          TabOrder = 0
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Servidores de Negocia'#231#227'o'
      ImageIndex = 1
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 306
        Height = 74
        Align = alClient
        BevelKind = bkFlat
        BevelOuter = bvLowered
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 0
        object LabeledEdit1: TLabeledEdit
          Left = 16
          Top = 36
          Width = 121
          Height = 19
          EditLabel.Width = 88
          EditLabel.Height = 13
          EditLabel.Caption = 'Servidor Bovespa:'
          TabOrder = 0
        end
        object LabeledEdit2: TLabeledEdit
          Left = 167
          Top = 36
          Width = 121
          Height = 19
          EditLabel.Width = 70
          EditLabel.Height = 13
          EditLabel.Caption = 'Servidor BM&&F'
          TabOrder = 1
        end
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 102
    Width = 314
    Height = 35
    Align = alBottom
    TabOrder = 1
    object BitBtn1: TBitBtn
      Left = 154
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Aplicar'
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 0
    end
    object BitBtn2: TBitBtn
      Left = 235
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Cancelar'
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 1
    end
  end
end
