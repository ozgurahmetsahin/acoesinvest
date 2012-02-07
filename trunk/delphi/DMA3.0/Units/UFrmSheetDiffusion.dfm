object frmSheetDiffusion: TfrmSheetDiffusion
  Left = 0
  Top = 0
  Caption = 'Planilha de Cota'#231#245'es'
  ClientHeight = 529
  ClientWidth = 914
  Color = clBackground
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWhite
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object panTop: TPanel
    Left = 0
    Top = 0
    Width = 914
    Height = 33
    Align = alTop
    Color = clBlack
    ParentBackground = False
    TabOrder = 0
    object lblActive: TLabel
      Left = 9
      Top = 8
      Width = 29
      Height = 13
      Caption = 'Ativo:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblVisible: TLabel
      Left = 868
      Top = 1
      Width = 45
      Height = 31
      Align = alRight
      Alignment = taCenter
      AutoSize = False
      Caption = 'Vis'#237'vel'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      ExplicitLeft = 608
    end
    object edtActive: TEdit
      Left = 44
      Top = 5
      Width = 78
      Height = 19
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 0
    end
    object btnOk: TButton
      Left = 128
      Top = 2
      Width = 40
      Height = 25
      Caption = 'Ok'
      TabOrder = 1
    end
    object btnDelete: TButton
      Left = 174
      Top = 2
      Width = 75
      Height = 25
      Caption = 'Excluir'
      TabOrder = 2
    end
    object chbVisible: TCheckBox
      Left = 853
      Top = 1
      Width = 15
      Height = 31
      Align = alRight
      TabOrder = 3
    end
    object btnClear: TButton
      Left = 255
      Top = 2
      Width = 75
      Height = 25
      Caption = 'Limpar'
      TabOrder = 4
    end
  end
  object grdDiffusion: TStringGrid
    Left = 8
    Top = 39
    Width = 905
    Height = 458
    Margins.Left = 1
    Margins.Top = 1
    Margins.Right = 1
    Margins.Bottom = 1
    Color = clBackground
    ColCount = 16
    Ctl3D = False
    DefaultColWidth = 55
    DrawingStyle = gdsClassic
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goTabs]
    ParentCtl3D = False
    TabOrder = 1
  end
end
