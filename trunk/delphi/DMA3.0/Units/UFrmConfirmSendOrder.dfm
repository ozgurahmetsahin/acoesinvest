object frmConfirmOrderBeforeSend: TfrmConfirmOrderBeforeSend
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Confirme o envio da Ordem'
  ClientHeight = 215
  ClientWidth = 390
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
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 390
    Height = 215
    Align = alClient
    BevelKind = bkFlat
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
    object Label1: TLabel
      Left = 7
      Top = 3
      Width = 299
      Height = 13
      Caption = 'Antes de enviar, confirme os dados da ordem abaixo:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Shape1: TShape
      Left = 7
      Top = 18
      Width = 369
      Height = 1
    end
    object Label2: TLabel
      Left = 16
      Top = 32
      Width = 42
      Height = 13
      Caption = 'Cliente:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblClientAccount: TLabel
      Left = 16
      Top = 48
      Width = 76
      Height = 13
      Caption = 'lblClientAccount'
    end
    object lblClientName: TLabel
      Left = 62
      Top = 48
      Width = 64
      Height = 13
      Caption = 'lblClientName'
    end
    object Label5: TLabel
      Left = 78
      Top = 72
      Width = 33
      Height = 13
      Caption = 'Ativo:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblSymbol: TLabel
      Left = 78
      Top = 88
      Width = 44
      Height = 13
      Caption = 'lblSymbol'
    end
    object Label7: TLabel
      Left = 131
      Top = 72
      Width = 68
      Height = 13
      Caption = 'Quantidade:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblQuantity: TLabel
      Left = 131
      Top = 88
      Width = 52
      Height = 13
      Caption = 'lblQuantity'
    end
    object Label9: TLabel
      Left = 218
      Top = 72
      Width = 32
      Height = 13
      Caption = 'Pre'#231'o'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblPrice: TLabel
      Left = 218
      Top = 88
      Width = 33
      Height = 13
      Caption = 'lblPrice'
    end
    object Label11: TLabel
      Left = 282
      Top = 72
      Width = 51
      Height = 13
      Caption = 'Validade:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblValidity: TLabel
      Left = 282
      Top = 88
      Width = 44
      Height = 13
      Caption = 'lblValidity'
    end
    object Label13: TLabel
      Left = 7
      Top = 120
      Width = 135
      Height = 13
      Caption = 'Informa'#231#245'es Adicionais:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblInformations: TLabel
      Left = 16
      Top = 139
      Width = 8
      Height = 13
      Caption = '--'
    end
    object Shape2: TShape
      Left = 7
      Top = 116
      Width = 369
      Height = 1
    end
    object Shape3: TShape
      Left = 7
      Top = 172
      Width = 369
      Height = 1
    end
    object Label15: TLabel
      Left = 16
      Top = 72
      Width = 46
      Height = 13
      Caption = 'Dire'#231#227'o:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblOrderDirection: TLabel
      Left = 16
      Top = 88
      Width = 31
      Height = 13
      Caption = 'Label6'
    end
    object Button1: TButton
      Left = 220
      Top = 179
      Width = 75
      Height = 25
      Caption = 'Enviar'
      ModalResult = 1
      TabOrder = 0
    end
    object Button2: TButton
      Left = 301
      Top = 179
      Width = 75
      Height = 25
      Caption = 'Cancelar'
      ModalResult = 2
      TabOrder = 1
    end
  end
end
