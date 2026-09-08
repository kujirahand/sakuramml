object frmMML2Midi: TfrmMML2Midi
  Left = 192
  Top = 107
  Width = 498
  Height = 347
  Caption = 'frmMML2Midi'
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 179
    Height = 12
    Caption = 'MML'#12501#12449#12452#12523#12434#12489#12525#12483#12503#12375#12390#12367#12384#12373#12356#12290
  end
  object lstMML: TListBox
    Left = 8
    Top = 24
    Width = 465
    Height = 257
    ItemHeight = 12
    TabOrder = 0
  end
  object btnConvert: TButton
    Left = 376
    Top = 288
    Width = 99
    Height = 25
    Caption = #19968#25324#22793#25563
    TabOrder = 1
    OnClick = btnConvertClick
  end
  object btnClear: TButton
    Left = 16
    Top = 288
    Width = 75
    Height = 25
    Caption = #12463#12522#12450
    TabOrder = 2
    OnClick = btnClearClick
  end
  object FileDrop1: TFileDrop
    Control = lstMML
    OnFileDrop = FileDrop1FileDrop
    Left = 176
    Top = 160
  end
end
