object FrmMain: TFrmMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'TS 4.0 Live - BETA'
  ClientHeight = 459
  ClientWidth = 225
  Color = clBtnFace
  Constraints.MaxWidth = 241
  Constraints.MinWidth = 241
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnActivate = FormActivate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 0
    Width = 225
    Height = 440
    Align = alClient
    BorderStyle = bsNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
    object PStock: TPanel
      Left = 0
      Top = 0
      Width = 225
      Height = 34
      Align = alTop
      Caption = 'PStock'
      TabOrder = 0
      object GStock: TCategoryPanelGroup
        Left = 1
        Top = 1
        Width = 223
        Height = 32
        VertScrollBar.Tracking = True
        Align = alClient
        HeaderFont.Charset = DEFAULT_CHARSET
        HeaderFont.Color = clWindowText
        HeaderFont.Height = -11
        HeaderFont.Name = 'Tahoma'
        HeaderFont.Style = []
        HeaderStyle = hsThemed
        TabOrder = 0
        object Stock: TCategoryPanel
          Top = 0
          Height = 30
          Caption = 'Cota'#231#227'o'
          Collapsed = True
          TabOrder = 0
          OnCollapse = StockCollapse
          OnExpand = StockExpand
          ExpandedHeight = 155
          object Label1: TLabel
            Left = 8
            Top = 22
            Width = 193
            Height = 13
            Cursor = crHandPoint
            Alignment = taCenter
            AutoSize = False
            Caption = 'Planilha de Cota'#231#245'es'
            OnClick = Label1Click
          end
          object Label3: TLabel
            Left = 8
            Top = 55
            Width = 193
            Height = 13
            Cursor = crHandPoint
            Alignment = taCenter
            AutoSize = False
            Caption = 'Book de Ofertas'
          end
          object Label4: TLabel
            Left = 8
            Top = 88
            Width = 193
            Height = 13
            Cursor = crHandPoint
            Alignment = taCenter
            AutoSize = False
            Caption = 'Resumo do Ativo'
            OnClick = Label4Click
          end
        end
      end
    end
    object PChart: TPanel
      Left = 0
      Top = 34
      Width = 225
      Height = 34
      Align = alTop
      Caption = 'PChart'
      TabOrder = 1
      object GChart: TCategoryPanelGroup
        Left = 1
        Top = 1
        Width = 223
        Height = 32
        VertScrollBar.Tracking = True
        Align = alClient
        HeaderFont.Charset = DEFAULT_CHARSET
        HeaderFont.Color = clWindowText
        HeaderFont.Height = -11
        HeaderFont.Name = 'Tahoma'
        HeaderFont.Style = []
        HeaderStyle = hsThemed
        TabOrder = 0
        object Chart: TCategoryPanel
          Top = 0
          Height = 30
          Caption = 'Gr'#225'fico'
          Collapsed = True
          TabOrder = 0
          OnCollapse = ChartCollapse
          OnExpand = ChartExpand
          ExpandedHeight = 155
        end
      end
    end
    object PTrade: TPanel
      Left = 0
      Top = 68
      Width = 225
      Height = 34
      Align = alTop
      Caption = 'PChart'
      TabOrder = 2
      object GTrade: TCategoryPanelGroup
        Left = 1
        Top = 1
        Width = 223
        Height = 32
        VertScrollBar.Tracking = True
        Align = alClient
        HeaderFont.Charset = DEFAULT_CHARSET
        HeaderFont.Color = clWindowText
        HeaderFont.Height = -11
        HeaderFont.Name = 'Tahoma'
        HeaderFont.Style = []
        HeaderStyle = hsThemed
        TabOrder = 0
        object Trade: TCategoryPanel
          Top = 0
          Height = 30
          Caption = 'Negocia'#231#227'o'
          Collapsed = True
          TabOrder = 0
          OnCollapse = TradeCollapse
          OnExpand = TradeExpand
          ExpandedHeight = 155
        end
      end
    end
    object POthers: TPanel
      Left = 0
      Top = 102
      Width = 225
      Height = 34
      Align = alTop
      Caption = 'PChart'
      TabOrder = 3
      object GOthers: TCategoryPanelGroup
        Left = 1
        Top = 1
        Width = 223
        Height = 32
        VertScrollBar.Tracking = True
        Align = alClient
        HeaderFont.Charset = DEFAULT_CHARSET
        HeaderFont.Color = clWindowText
        HeaderFont.Height = -11
        HeaderFont.Name = 'Tahoma'
        HeaderFont.Style = []
        HeaderStyle = hsThemed
        TabOrder = 0
        object Others: TCategoryPanel
          Top = 0
          Height = 30
          Caption = 'Outros'
          Collapsed = True
          TabOrder = 0
          OnCollapse = OthersCollapse
          OnExpand = OthersExpand
          ExpandedHeight = 155
          object Label2: TLabel
            Left = 8
            Top = 32
            Width = 193
            Height = 13
            Cursor = crHandPoint
            Alignment = taCenter
            AutoSize = False
            Caption = 'Conex'#245'es'
            OnClick = Label2Click
          end
        end
      end
    end
    object PTradingSystem: TPanel
      Left = 0
      Top = 136
      Width = 225
      Height = 34
      Align = alTop
      Caption = 'PTradingSystem'
      TabOrder = 4
      object GTradingSystem: TCategoryPanelGroup
        Left = 1
        Top = 1
        Width = 223
        Height = 32
        VertScrollBar.Tracking = True
        Align = alClient
        HeaderFont.Charset = DEFAULT_CHARSET
        HeaderFont.Color = clWindowText
        HeaderFont.Height = -11
        HeaderFont.Name = 'Tahoma'
        HeaderFont.Style = []
        HeaderStyle = hsThemed
        TabOrder = 0
        object TradingSystem: TCategoryPanel
          Top = 0
          Height = 30
          Caption = 'TradingSystem'
          Collapsed = True
          TabOrder = 0
          OnCollapse = TradingSystemCollapse
          OnExpand = TradingSystemExpand
          ExpandedHeight = 155
          object Label5: TLabel
            Left = 8
            Top = 34
            Width = 193
            Height = 13
            Cursor = crHandPoint
            Alignment = taCenter
            AutoSize = False
            Caption = 'Planilha Trading System'
            OnClick = Label5Click
          end
          object Label6: TLabel
            Left = 8
            Top = 72
            Width = 193
            Height = 13
            Cursor = crHandPoint
            Alignment = taCenter
            AutoSize = False
            Caption = 'Trading System Agressivo'
            OnClick = Label6Click
          end
        end
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 440
    Width = 225
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object DaileonFW: TIdTCPClient
    ConnectTimeout = 500
    Host = '200.152.246.206'
    IPVersion = Id_IPv4
    Port = 8587
    ReadTimeout = 250
    Left = 56
    Top = 256
  end
  object SkinData1: TSkinData
    Active = True
    DisableTag = 99
    SkinControls = [xcMainMenu, xcPopupMenu, xcToolbar, xcControlbar, xcCombo, xcCheckBox, xcRadioButton, xcProgress, xcScrollbar, xcEdit, xcButton, xcBitBtn, xcSpeedButton, xcSpin, xcPanel, xcGroupBox, xcStatusBar, xcTab, xcTrackBar, xcSystemMenu]
    Options = [xoPreview, xoToolbarBK]
    Skin3rd.Strings = (
      'TCategoryButtons=scrollbar'
      'TPngSpeedbutton=pngspeedbutton'
      'TPngBitBtn=pngbitbtn'
      'TVirtualStringTree=scrollbar'
      'TVirtualDrawTree=scrollbar'
      'TTBXDockablePanel=Panel'
      'TAdvPanelGroup=scrollbar'
      'TComboboxex=combobox'
      'TRxSpeedButton=speedbutton'
      'THTMLViewer=scrollbar'
      'TDBCtrlGrid=scrollbar'
      'TfrSpeedButton=speedbutton'
      'TfrTBButton=speedbutton'
      'TControlBar=Panel'
      'TTBDock=Panel'
      'TTBToolbar=Panel'
      'TImageEnMView=scrollbar'
      'TImageEnView=scrollbar'
      'TAdvMemo=scrollbar'
      'TDBAdvMemo=scrollbar'
      'TcxDBLookupComboBox=combobox'
      'TcxDBComboBox=combobox'
      'TcxDBDateEdit=combobox'
      'TcxDBImageComboBox=combobox'
      'TcxDBCalcEdit=combobox'
      'TcxDBBlobEdit=combobox'
      'TcxDBPopupEdit=combobox'
      'TcxDBFontNameComboBox=combobox'
      'TcxDBShellComboBox=combobox'
      'TRxLookupEdit=combobox'
      'TRxDBLookupCombo=combobox'
      'TRzGroup=panel'
      'TRzButton=button'
      'TRzBitbtn=bitbtn'
      'TRzMenuButton=menubtn'
      'TRzCheckGroup=CheckGroup'
      'TRzRadioGroup=Radiogroup'
      'TRzButtonEdit=Edit'
      'TRzDBRadioGroup=Radiogroup'
      'TRzDBRadioButton=Radiobutton'
      'TRzDateTimeEdit=combobox'
      'TRzColorEdit=combobox'
      'TRzDateTimePicker=combobox'
      'TRzDBDateTimeEdit=combobox'
      'TRzDbColorEdit=combobox'
      'TRzDBDateTimePicker=combobox'
      'TLMDButton=bitbtn'
      'TLMDGroupBox=Groupbox'
      'TDBCheckboxEh=Checkbox'
      'TDBCheckboxEh=Checkbox'
      'TLMDCHECKBOX=Checkbox'
      'TLMDDBCHECKBOX=Checkbox'
      'TLMDRadiobutton=Radiobutton'
      'TLMDCalculator=panel'
      'TLMDGROUPBOX=Panel'
      'TLMDSIMPLEPANEL=Panel'
      'TLMDDBCalendar=Panel'
      'TLMDButtonPanel=Panel'
      'TLMDLMDCalculator=Panel'
      'TLMDHeaderPanel=Panel'
      'TLMDTechnicalLine=Panel'
      'TLMDLMDClock=Panel'
      'TLMDTrackbar=panel'
      'TLMDListCombobox=combobox'
      'TLMDCheckListCombobox=combobox'
      'TLMDHeaderListCombobox=combobox'
      'TLMDImageCombobox=combobox'
      'TLMDColorCombobox=combobox'
      'TLMDFontCombobox=combobox'
      'TLMDFontSizeCombobox=combobox'
      'TLMDFontSizeCombobox=combobox'
      'TLMDPrinterCombobox=combobox'
      'TLMDDriveCombobox=combobox'
      'TLMDCalculatorComboBox=combobox'
      'TLMDTrackBarComboBox=combobox'
      'TLMDCalendarComboBox=combobox'
      'TLMDTreeComboBox=combobox'
      'TLMDRADIOGROUP=radiogroup'
      'TLMDCheckGroup=CheckGroup'
      'TLMDDBRADIOGROUP=radiogroup'
      'TLMDDBCheckGroup=CheckGroup'
      'TLMDCalculatorEdit=edit'
      'TLMDEDIT=Edit'
      'TLMDMASKEDIT=Edit'
      'TLMDBROWSEEDIT=Edit'
      'TLMDEXTSPINEDIT=Edit'
      'TLMDCALENDAREDIT=Edit'
      'TLMDFILEOPENEDIT=Edit'
      'TLMDFILESAVEEDIT=Edit'
      'TLMDCOLOREDIT=Edit'
      'TLMDDBEDIT=Edit'
      'TLMDDBMASKEDIT=Edit'
      'TLMDDBEXTSPINEDIT=Edit'
      'TLMDDBSPINEDIT=Edit'
      'TLMDDBEDITDBLookup=Edit'
      'TLMDEDITDBLookup=Edit'
      'TDBLookupCombobox=Combobox'
      'TWWDBCombobox=Combobox'
      'TWWDBLookupCombo=Combobox'
      'TWWDBCombobox=Combobox'
      'TWWKeyCombo=Combobox'
      'TWWTempKeyCombo=combobox'
      'TWWDBDateTimePicker=Combobox'
      'TWWRADIOGROUP=radiogroup'
      'TWWDBEDIT=Edit'
      'TcxButton=bitbtn'
      'TcxDBRadioGroup=radiogroup'
      'TcxRadioGroup=radiogroup'
      'TcxGroupbox=groupbox'
      'TOVCPICTUREFIELD=Edit'
      'TOVCDBPICTUREFIELD=Edit'
      'TOVCSLIDEREDIT=Edit'
      'TOVCDBSLIDEREDIT=Edit'
      'TOVCSIMPLEFIELD=Edit'
      'TOVCDBSIMPLEFIELD=Edit'
      'TO32DBFLEXEDIT=Edit'
      'TOVCNUMERICFIELD=Edit'
      'TOVCDBNUMERICFIELD=Edit')
    SkinFile = 'LE4-BLACKC.skn'
    SkinStore = '(none)'
    SkinFormtype = sfMainform
    Version = '5.10.09.17'
    MenuUpdate = True
    MenuMerge = False
    Left = 112
    Top = 240
    SkinStream = {00000000}
  end
  object DaileonData: TIdTCPClient
    ConnectTimeout = 500
    Host = '200.152.246.206'
    IPVersion = Id_IPv4
    Port = 8585
    ReadTimeout = 250
    Left = 56
    Top = 312
  end
end
