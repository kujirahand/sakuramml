object frmSelList: TfrmSelList
  Left = 192
  Top = 107
  BorderStyle = bsDialog
  Caption = #20197#19979#12424#12426#36984#25246#12375#12390#12367#12384#12373#12356#12290
  ClientHeight = 321
  ClientWidth = 333
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object lstMain: TListBox
    Left = 0
    Top = 0
    Width = 329
    Height = 249
    Style = lbOwnerDrawVariable
    ItemHeight = 16
    TabOrder = 0
    OnClick = lstMainClick
    OnDblClick = lstMainDblClick
  end
  object edtKey: TEdit
    Left = 0
    Top = 256
    Width = 329
    Height = 24
    Font.Charset = SHIFTJIS_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = #65325#65331' '#12468#12471#12483#12463
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object btnOk: TButton
    Left = 152
    Top = 288
    Width = 89
    Height = 25
    Caption = #27770#23450
    TabOrder = 2
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 248
    Top = 288
    Width = 81
    Height = 25
    Caption = #12461#12515#12531#12475#12523
    TabOrder = 3
    OnClick = btnCancelClick
  end
end
