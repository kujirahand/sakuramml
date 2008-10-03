object Form1: TForm1
  Left = 192
  Top = 107
  Width = 481
  Height = 401
  Caption = #28436#22863#12486#12473#12479#65374
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object Splitter1: TSplitter
    Left = 0
    Top = 273
    Width = 473
    Height = 3
    Cursor = crVSplit
    Align = alTop
  end
  object Memo1: TMemo
    Left = 0
    Top = 33
    Width = 473
    Height = 240
    Align = alTop
    Font.Charset = SHIFTJIS_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = #65325#65331' '#12468#12471#12483#12463
    Font.Style = []
    Lines.Strings = (
      'cdefg')
    ParentFont = False
    TabOrder = 0
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 473
    Height = 33
    ButtonHeight = 25
    Caption = 'ToolBar1'
    TabOrder = 1
    object Button1: TButton
      Left = 0
      Top = 2
      Width = 97
      Height = 25
      Caption = #28436#22863#38283#22987
      TabOrder = 0
      OnClick = Button1Click
    end
    object ToolButton1: TToolButton
      Left = 97
      Top = 2
      Width = 8
      Caption = 'ToolButton1'
      Style = tbsSeparator
    end
    object Button2: TButton
      Left = 105
      Top = 2
      Width = 88
      Height = 25
      Caption = #12456#12487#12451#12479#21021#26399#21270
      TabOrder = 1
      OnClick = Button2Click
    end
  end
  object memErr: TMemo
    Left = 0
    Top = 276
    Width = 473
    Height = 98
    Align = alClient
    TabOrder = 2
  end
end
