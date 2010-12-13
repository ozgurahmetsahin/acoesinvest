object FrmWebBrowser: TFrmWebBrowser
  Left = 0
  Top = 0
  Caption = 'WebBrowser A'#231#245'es Invest Router'
  ClientHeight = 474
  ClientWidth = 675
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object WebBrowser1: TWebBrowser
    Left = 0
    Top = 0
    Width = 675
    Height = 474
    Align = alClient
    TabOrder = 0
    OnDownloadComplete = WebBrowser1DownloadComplete
    ExplicitLeft = 120
    ExplicitTop = 144
    ExplicitWidth = 300
    ExplicitHeight = 150
    ControlData = {
      4C000000C3450000FD3000000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E12620E000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object ImageList1: TImageList
    Left = 312
    Top = 144
  end
end
