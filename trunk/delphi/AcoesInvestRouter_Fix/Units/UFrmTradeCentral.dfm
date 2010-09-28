object FrmCentral: TFrmCentral
  Left = 0
  Top = 0
  Caption = 'FrmCentral'
  ClientHeight = 431
  ClientWidth = 1517
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object CentralSheet: TSheet
    Left = 0
    Top = 0
    Width = 1517
    Height = 431
    Align = alClient
    ColCount = 31
    DefaultRowHeight = 17
    FixedCols = 0
    RowCount = 2
    TabOrder = 0
    ColumsVisible = [clQuote, clPicture, clLast, clVar, clBuy, clSell, clStatus, clBaseIn, clObj1, clObj2, clObj3, clObj4, clMax, clMin, clOpen, clClose, clNeg, clVarWeek, clVarMonth, clVarYear, clStop, clPtnBuy, clPtnSell, clObj1B, clObj2B, clObj3B, clObj4B, clObj1S, clObj2S, clObj3S, clObj4S]
    StringclQuote = 'Ativo'
    StringclPicture = '#'
    StringclVarWeek = 'Var Sem'
    StringclVarMonth = 'Var Mes'
    StringclStop = 'Stop'
    StringclVarYear = 'Var ano'
    StringclPtnBuy = 'Pt Compra'
    StringclPtnSell = 'Pt Venda'
    StrinclObj4S = 'f'
    FilterColums = stAll
    FontColorPaint = clBlack
    EvenColorLine = clBlack
    OddColorLine = clBlack
    ShowClearLine = False
    ExplicitWidth = 345
    RowHeights = (
      17
      17)
  end
end
