object FrmOpenSheet: TFrmOpenSheet
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Abrir Planilha'
  ClientHeight = 226
  ClientWidth = 239
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object FileListBox1: TFileListBox
    Left = 0
    Top = 0
    Width = 239
    Height = 191
    Align = alClient
    ItemHeight = 13
    Mask = '*.sht'
    TabOrder = 0
    OnDblClick = FileListBox1DblClick
  end
  object Panel1: TPanel
    Left = 0
    Top = 191
    Width = 239
    Height = 35
    Align = alBottom
    TabOrder = 1
    object btnOpen: TBitBtn
      Left = 22
      Top = 6
      Width = 64
      Height = 25
      Caption = 'Abrir'
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 0
      OnClick = btnOpenClick
    end
    object btnCancel: TBitBtn
      Left = 165
      Top = 6
      Width = 65
      Height = 25
      Caption = 'Cancelar'
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 1
      OnClick = btnCancelClick
    end
    object btnDelete: TBitBtn
      Left = 92
      Top = 6
      Width = 67
      Height = 25
      Caption = 'Excluir'
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 2
      OnClick = btnDeleteClick
    end
  end
end
