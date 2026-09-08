object frmHokan: TfrmHokan
  Left = 331
  Top = 186
  BorderStyle = bsNone
  Caption = #21336#35486#35036#23436
  ClientHeight = 104
  ClientWidth = 318
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  OnDeactivate = FormDeactivate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 12
  object grdWord: TStringGrid
    Left = 0
    Top = 0
    Width = 318
    Height = 104
    Align = alClient
    DefaultRowHeight = 20
    Font.Charset = SHIFTJIS_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #65325#65331' '#12468#12471#12483#12463
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
    ParentFont = False
    TabOrder = 0
    OnDblClick = grdWordDblClick
    OnKeyDown = grdWordKeyDown
    OnKeyPress = grdWordKeyPress
  end
end
