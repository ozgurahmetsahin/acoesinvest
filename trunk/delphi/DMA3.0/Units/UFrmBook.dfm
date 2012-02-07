object frmBook: TfrmBook
  Left = 0
  Top = 0
  Caption = 'Livro de Ofertas'
  ClientHeight = 375
  ClientWidth = 668
  Color = clBackground
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object panTop: TPanel
    Left = 0
    Top = 0
    Width = 668
    Height = 33
    Align = alTop
    TabOrder = 0
    object lblActive: TLabel
      Left = 9
      Top = 8
      Width = 25
      Height = 13
      Caption = 'Ativo'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblVisivel: TLabel
      Left = 638
      Top = 1
      Width = 29
      Height = 31
      Align = alRight
      Caption = 'Vis'#237'vel'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      ExplicitHeight = 13
    end
    object Edit1: TEdit
      Left = 44
      Top = 5
      Width = 78
      Height = 21
      TabOrder = 0
    end
    object Button1: TButton
      Left = 128
      Top = 3
      Width = 41
      Height = 25
      Caption = 'Ok'
      TabOrder = 1
    end
    object chbVisivel: TCheckBox
      Left = 621
      Top = 1
      Width = 17
      Height = 31
      Align = alRight
      TabOrder = 2
    end
  end
  object panCenter: TPanel
    Left = 0
    Top = 33
    Width = 668
    Height = 342
    Align = alClient
    TabOrder = 1
  end
end
