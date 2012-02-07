object ConnectionCenter: TConnectionCenter
  Left = 0
  Top = 0
  Caption = 'ConnectionCenter'
  ClientHeight = 65
  ClientWidth = 266
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object FixLibrary: TRouterLibrary
    FixSession.SecurityExchange = 'XBSP'
    FixSession.TargetCompId = 'CDRFIX'
    OnLogout = FixLibraryLogout
    OnLogon = FixLibraryLogon
    OnHeartBeat = FixLibraryHeartBeat
    OnTestRequest = FixLibraryTestRequest
    OnUserListReport = FixLibraryUserListReport
    Left = 16
    Top = 8
  end
  object tmrCheckConnFixStatus: TTimer
    Enabled = False
    Interval = 5000
    Left = 96
    Top = 8
  end
end
