object frmFind: TfrmFind
  Left = 233
  Top = 158
  BorderStyle = bsDialog
  Caption = #26908#32034#12480#12452#12450#12525#12464
  ClientHeight = 51
  ClientWidth = 347
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 36
    Height = 12
    Caption = #26908#32034#35486
  end
  object edtKey: TEdit
    Left = 56
    Top = 8
    Width = 225
    Height = 20
    PopupMenu = PopupMenu1
    TabOrder = 0
    OnKeyDown = edtKeyKeyDown
  end
  object chkUpperCase: TCheckBox
    Left = 8
    Top = 32
    Width = 129
    Height = 17
    Caption = #22823#25991#23383#23567#25991#23383#12434#21306#21029
    TabOrder = 1
  end
  object btnFind: TButton
    Left = 288
    Top = 8
    Width = 57
    Height = 25
    Caption = #26908#32034'(&F)'
    TabOrder = 2
    OnClick = btnFindClick
  end
  object PopupMenu1: TPopupMenu
    Left = 160
    Top = 24
    object mnuCut1: TMenuItem
      Caption = #20999#12426#21462#12426'(&T)'
      ShortCut = 16472
      OnClick = mnuCut1Click
    end
    object mnuCopy1: TMenuItem
      Caption = #12467#12500#12540'(&C)'
      ShortCut = 16451
      OnClick = mnuCopy1Click
    end
    object mnuPaste1: TMenuItem
      Caption = #36028#12426#20184#12369'(&P)'
      ShortCut = 16470
      OnClick = mnuPaste1Click
    end
  end
end
