object FrmSheet: TFrmSheet
  Left = 0
  Top = 0
  Caption = 'Planilha de Cota'#231#245'es'
  ClientHeight = 341
  ClientWidth = 719
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
  object Sheet: TStringGrid
    Left = 0
    Top = 26
    Width = 719
    Height = 296
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    Color = 4194304
    ColCount = 10
    Ctl3D = False
    DefaultRowHeight = 17
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
    ParentCtl3D = False
    PopupMenu = PopupMenu1
    TabOrder = 0
    OnDrawCell = SheetDrawCell
    OnKeyPress = SheetKeyPress
    ColWidths = (
      64
      64
      64
      85
      88
      64
      64
      64
      64
      67)
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 719
    Height = 26
    Align = alTop
    BevelOuter = bvNone
    Ctl3D = False
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 1
    object lblEdtNewSymbol: TLabeledEdit
      Left = 63
      Top = 2
      Width = 73
      Height = 19
      EditLabel.Width = 57
      EditLabel.Height = 13
      EditLabel.Caption = 'Novo Ativo:'
      EditLabel.Color = clBlack
      EditLabel.Font.Charset = DEFAULT_CHARSET
      EditLabel.Font.Color = clBlack
      EditLabel.Font.Height = -11
      EditLabel.Font.Name = 'Tahoma'
      EditLabel.Font.Style = []
      EditLabel.ParentColor = False
      EditLabel.ParentFont = False
      LabelPosition = lpLeft
      TabOrder = 0
    end
    object btnOpenDeleteSheet: TBitBtn
      Left = 314
      Top = 0
      Width = 87
      Height = 25
      Caption = 'Abrir/Excluir'
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 1
      OnClick = btnOpenDeleteSheetClick
    end
    object btnNewSheet: TBitBtn
      Left = 254
      Top = 0
      Width = 54
      Height = 25
      Caption = 'Nova'
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 2
      OnClick = btnNewSheetClick
    end
    object btnDeleteSymbol: TBitBtn
      Left = 174
      Top = 0
      Width = 27
      Height = 25
      Caption = '-'
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 3
      OnClick = btnDeleteSymbolClick
    end
    object btnClearSheet: TBitBtn
      Left = 207
      Top = 0
      Width = 27
      Height = 25
      Caption = '--'
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 4
      OnClick = btnClearSheetClick
    end
    object btnAddSymbol: TBitBtn
      Left = 142
      Top = 1
      Width = 26
      Height = 24
      Caption = '+'
      Default = True
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 5
      OnClick = btnAddSymbolClick
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 322
    Width = 719
    Height = 19
    Panels = <
      item
        Text = 'Planilha:'
        Width = 150
      end
      item
        Text = 'Ativos:'
        Width = 70
      end
      item
        Width = 50
      end>
  end
  object PopupMenu1: TPopupMenu
    Left = 304
    Top = 168
    object DeleteSymbol: TMenuItem
      Caption = 'Excluir Ativo'
      ShortCut = 46
      OnClick = DeleteSymbolClick
    end
  end
end
