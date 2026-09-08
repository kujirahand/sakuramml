object frmInputNum: TfrmInputNum
  Left = 447
  Top = 233
  BorderStyle = bsNone
  Caption = 'frmInputNum'
  ClientHeight = 24
  ClientWidth = 126
  Color = clWhite
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  OldCreateOrder = False
  OnDeactivate = FormDeactivate
  PixelsPerInch = 96
  TextHeight = 12
  object Shape1: TShape
    Left = 1
    Top = 0
    Width = 35
    Height = 22
    Brush.Color = clSkyBlue
    Pen.Color = clMaroon
  end
  object lblNum: TLabel
    Left = 5
    Top = 5
    Width = 18
    Height = 12
    Caption = '127'
    Transparent = True
  end
  object bar: TScrollBar
    Left = 40
    Top = 3
    Width = 81
    Height = 18
    Max = 127
    PageSize = 0
    TabOrder = 0
    OnChange = barChange
  end
end
