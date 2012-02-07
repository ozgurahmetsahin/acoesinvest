object frmSendOrders: TfrmSendOrders
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Boleta'
  ClientHeight = 151
  ClientWidth = 384
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 384
    Height = 151
    Align = alClient
    BevelKind = bkFlat
    BevelOuter = bvNone
    Color = 8454143
    Ctl3D = False
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 0
    object Label1: TLabel
      Left = 247
      Top = 45
      Width = 44
      Height = 13
      Caption = 'Validade:'
    end
    object Label10: TLabel
      Left = 71
      Top = 45
      Width = 60
      Height = 13
      Caption = 'Quantidade:'
    end
    object Label11: TLabel
      Left = 148
      Top = 45
      Width = 31
      Height = 13
      Caption = 'Pre'#231'o:'
    end
    object edtClientAccount: TLabeledEdit
      Left = 3
      Top = 16
      Width = 62
      Height = 19
      EditLabel.Width = 37
      EditLabel.Height = 13
      EditLabel.Caption = 'Cliente:'
      TabOrder = 0
      OnExit = edtClientAccountExit
    end
    object edtSymbol: TLabeledEdit
      Left = 3
      Top = 61
      Width = 62
      Height = 19
      CharCase = ecUpperCase
      EditLabel.Width = 29
      EditLabel.Height = 13
      EditLabel.Caption = 'Ativo:'
      TabOrder = 1
    end
    object cbValidity: TComboBox
      Left = 247
      Top = 61
      Width = 124
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 4
      Text = 'Dia'
      OnChange = cbValidityChange
      Items.Strings = (
        'Dia'
        'At'#233' Cancelar'
        'Exec. ou Canc.'
        'At'#233' o dia')
    end
    object edtClientName: TEdit
      Left = 71
      Top = 16
      Width = 300
      Height = 19
      TabOrder = 5
    end
    object dtUntilDate: TDateTimePicker
      Left = 247
      Top = 88
      Width = 124
      Height = 21
      Date = 40941.788631006940000000
      Time = 40941.788631006940000000
      TabOrder = 6
      Visible = False
    end
    object btnSendOrder: TButton
      Left = 215
      Top = 115
      Width = 75
      Height = 25
      Caption = 'Enviar'
      TabOrder = 7
      OnClick = btnSendOrderClick
    end
    object btnOptions: TButton
      Left = 296
      Top = 115
      Width = 75
      Height = 25
      Caption = 'Op'#231#245'es'
      Style = bsSplitButton
      TabOrder = 8
      OnClick = btnOptionsClick
    end
    object GroupBox1: TGroupBox
      Left = 3
      Top = 86
      Width = 206
      Height = 54
      Caption = 'Cota'#231#245'es:'
      TabOrder = 9
      object Label2: TLabel
        Left = 13
        Top = 16
        Width = 21
        Height = 13
        Caption = #218'lt.:'
      end
      object Label3: TLabel
        Left = 48
        Top = 16
        Width = 34
        Height = 13
        Caption = '0.0000'
      end
      object Label4: TLabel
        Left = 8
        Top = 33
        Width = 26
        Height = 13
        Caption = 'Osc.:'
      end
      object Label5: TLabel
        Left = 48
        Top = 35
        Width = 34
        Height = 13
        Caption = '0.0000'
      end
      object Label6: TLabel
        Left = 97
        Top = 16
        Width = 28
        Height = 13
        Caption = 'M'#225'x.:'
      end
      object Label7: TLabel
        Left = 145
        Top = 16
        Width = 34
        Height = 13
        Caption = '0.0000'
      end
      object Label8: TLabel
        Left = 101
        Top = 35
        Width = 24
        Height = 13
        Caption = 'M'#237'n.:'
      end
      object Label9: TLabel
        Left = 145
        Top = 35
        Width = 34
        Height = 13
        Caption = '0.0000'
      end
    end
    object rdDirectionSell: TRadioButton
      Left = 313
      Top = 0
      Width = 58
      Height = 15
      Caption = 'Venda'
      TabOrder = 10
      OnClick = rdDirectionSellClick
    end
    object rdDirectionBuy: TRadioButton
      Left = 248
      Top = 0
      Width = 59
      Height = 15
      Caption = 'Compra'
      TabOrder = 11
      OnClick = rdDirectionBuyClick
    end
    object edtQuantity: TEdit
      Left = 71
      Top = 61
      Width = 71
      Height = 19
      BiDiMode = bdRightToLeft
      ParentBiDiMode = False
      TabOrder = 2
      OnClick = edtQuantityClick
      OnDblClick = edtQuantityDblClick
      OnKeyDown = edtQuantityKeyDown
      OnKeyPress = edtQuantityKeyPress
      OnMouseActivate = edtQuantityMouseActivate
    end
    object edtPrice: TEdit
      Left = 148
      Top = 61
      Width = 93
      Height = 19
      BiDiMode = bdRightToLeft
      ParentBiDiMode = False
      TabOrder = 3
      OnClick = edtPriceClick
      OnDblClick = edtPriceDblClick
      OnKeyDown = edtPriceKeyDown
      OnKeyPress = edtPriceKeyPress
      OnMouseActivate = edtPriceMouseActivate
    end
  end
  object popOptions: TPopupMenu
    Left = 328
    Top = 24
    object popOptConfirmBeforeSend: TMenuItem
      AutoCheck = True
      Caption = 'Confirmar ao enviar'
      Checked = True
    end
    object popOptClearAfterSend: TMenuItem
      AutoCheck = True
      Caption = 'Limpar dados ao enviar'
      Checked = True
    end
    object popOptCloseAfterSend: TMenuItem
      AutoCheck = True
      Caption = 'Fechar ao enviar'
      Checked = True
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object popOptChangeColor: TMenuItem
      Caption = 'Alterar cor da boleta'
      OnClick = popOptChangeColorClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object popOptAdvanceSendOrder: TMenuItem
      Caption = 'Boleta Avan'#231'ada'
    end
  end
  object cdlgChangeColor: TColorDialog
    Left = 272
    Top = 24
  end
end
