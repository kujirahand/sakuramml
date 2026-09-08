object frmReplace: TfrmReplace
  Left = 302
  Top = 186
  BorderStyle = bsDialog
  Caption = #32622#25563#12480#12452#12450#12525#12464
  ClientHeight = 76
  ClientWidth = 326
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 36
    Height = 12
    Caption = #26908#32034#35486
  end
  object Label2: TLabel
    Left = 8
    Top = 32
    Width = 36
    Height = 12
    Caption = #32622#25563#35486
  end
  object edtKey: TEdit
    Left = 56
    Top = 8
    Width = 185
    Height = 20
    PopupMenu = popRep
    TabOrder = 0
    OnEnter = edtKeyEnter
  end
  object edtReplace: TEdit
    Left = 56
    Top = 32
    Width = 185
    Height = 20
    PopupMenu = popRep
    TabOrder = 1
    OnEnter = edtReplaceEnter
  end
  object btnReplace: TButton
    Left = 248
    Top = 8
    Width = 73
    Height = 19
    Caption = #65297#12388#32622#25563'(&R)'
    TabOrder = 2
    OnClick = btnReplaceClick
  end
  object btnReplaceAll: TButton
    Left = 248
    Top = 32
    Width = 73
    Height = 19
    Caption = #20840#12390#32622#25563'(&A)'
    TabOrder = 3
    OnClick = btnReplaceAllClick
  end
  object chkSelectArea: TCheckBox
    Left = 8
    Top = 56
    Width = 113
    Height = 17
    Caption = #36984#25246#31684#22258#12434#32622#25563
    TabOrder = 4
  end
  object popRep: TPopupMenu
    Left = 152
    Top = 40
    object Copy1: TMenuItem
      Caption = #12467#12500#12540
      ShortCut = 16451
      OnClick = Copy1Click
    end
    object Cut1: TMenuItem
      Caption = #20999#12426#21462#12426
      ShortCut = 16472
      OnClick = Cut1Click
    end
    object popPaste: TMenuItem
      Caption = #36028#20184#12369
      ShortCut = 16470
      OnClick = popPasteClick
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object popAll: TMenuItem
      Caption = #20840#12390#36984#25246
      OnClick = popAllClick
    end
  end
end
