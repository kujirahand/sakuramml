object frmFindHelpF: TfrmFindHelpF
  Left = 187
  Top = 155
  Width = 526
  Height = 453
  Caption = #26908#32034' - '#35486#21477#26908#32034
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 518
    Height = 57
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 9
      Top = 5
      Width = 55
      Height = 12
      Caption = #12461#12540#12527#12540#12489
    end
    object Label2: TLabel
      Left = 280
      Top = 11
      Width = 48
      Height = 12
      Caption = #26908#32034#31684#22258
    end
    object edtKey: TEdit
      Left = 8
      Top = 20
      Width = 201
      Height = 20
      TabOrder = 0
      OnKeyDown = edtKeyKeyDown
    end
    object btnFind: TButton
      Left = 214
      Top = 18
      Width = 52
      Height = 25
      Caption = #26908#32034'(&F)'
      TabOrder = 1
      OnClick = btnFindClick
    end
    object cmbRange: TComboBox
      Left = 336
      Top = 8
      Width = 145
      Height = 22
      Style = csOwnerDrawFixed
      ItemHeight = 16
      ItemIndex = 0
      TabOrder = 2
      Text = #12510#12491#12517#12450#12523#20869
      Items.Strings = (
        #12510#12491#12517#12450#12523#20869
        'WEB'#12506#12540#12472'(text2music.com'#38480#23450')'
        #36074#21839#25522#31034#26495#12398#20013)
    end
    object chkUpper: TCheckBox
      Left = 280
      Top = 32
      Width = 161
      Height = 17
      Caption = #22823#25991#23383#23567#25991#23383#12434#21306#21029#12375#12394#12356
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 57
    Width = 518
    Height = 369
    Align = alClient
    BevelOuter = bvLowered
    BevelWidth = 2
    Caption = 'Panel2'
    TabOrder = 1
    object browser: TWebBrowser
      Left = 2
      Top = 2
      Width = 514
      Height = 365
      Align = alClient
      TabOrder = 0
      ControlData = {
        4C00000020350000B92500000000000000000000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E126208000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
  end
end
