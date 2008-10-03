object frmSplashWindow: TfrmSplashWindow
  Left = 192
  Top = 107
  BorderStyle = bsNone
  Caption = 'Splash!'
  ClientHeight = 201
  ClientWidth = 300
  Color = clWhite
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 88
    Top = 72
    Width = 110
    Height = 12
    Caption = #12486#12461#12473#12488#38899#27005#12300#12469#12463#12521#12301
  end
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 300
    Height = 200
    OnClick = Image1Click
  end
  object timerClose: TTimer
    Interval = 2000
    OnTimer = timerCloseTimer
    Left = 136
    Top = 88
  end
end
