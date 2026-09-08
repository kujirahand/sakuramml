object frmPlayMonitor: TfrmPlayMonitor
  Left = 210
  Top = 159
  Width = 545
  Height = 311
  BorderStyle = bsSizeToolWin
  Caption = #28436#22863#12514#12491#12479#12540
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object splitC: TSplitter
    Left = 88
    Top = 22
    Width = 2
    Height = 239
    Beveled = True
    OnMoved = splitCMoved
  end
  object panelCC: TPanel
    Left = 17
    Top = 22
    Width = 71
    Height = 239
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    object boxCC: TPaintBox
      Left = 0
      Top = 0
      Width = 71
      Height = 239
      Align = alClient
      OnClick = boxCCClick
    end
  end
  object panelNoteInfo: TPanel
    Left = 90
    Top = 22
    Width = 447
    Height = 239
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object boxNoteInfo: TPaintBox
      Left = 0
      Top = 0
      Width = 447
      Height = 239
      Align = alClient
      OnClick = boxNoteInfoClick
    end
  end
  object panelBottom: TPanel
    Left = 0
    Top = 0
    Width = 537
    Height = 22
    Align = alTop
    BevelOuter = bvLowered
    Font.Charset = SHIFTJIS_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object panelCol: TPanel
      Left = 1
      Top = 1
      Width = 88
      Height = 20
      Align = alLeft
      TabOrder = 0
      object imgCol: TImage
        Left = 1
        Top = 1
        Width = 86
        Height = 18
        Align = alClient
        OnClick = imgColClick
      end
    end
    object panelSwitch: TPanel
      Left = 89
      Top = 1
      Width = 447
      Height = 20
      Align = alClient
      Color = clWhite
      TabOrder = 1
      object lblPort: TLabel
        Left = 357
        Top = 4
        Width = 21
        Height = 11
        Caption = 'Port'
      end
      object pntTop: TPaintBox
        Left = 1
        Top = 1
        Width = 216
        Height = 18
      end
      object scrTempo: TScrollBar
        Left = 127
        Top = 2
        Width = 84
        Height = 13
        Max = 500
        Min = 30
        PageSize = 0
        Position = 120
        TabOrder = 0
        OnChange = scrTempoChange
      end
      object chkVolume: TCheckBox
        Left = 224
        Top = 2
        Width = 40
        Height = 17
        Caption = #38899#37327
        Checked = True
        Color = clWhite
        ParentColor = False
        State = cbChecked
        TabOrder = 3
        OnClick = chkVolumeClick
      end
      object chkParam: TCheckBox
        Left = 267
        Top = 2
        Width = 43
        Height = 17
        Caption = #35443#32048
        TabOrder = 2
      end
      object chkLog: TCheckBox
        Left = 311
        Top = 2
        Width = 43
        Height = 17
        Caption = #12525#12464
        TabOrder = 4
        OnClick = chkLogClick
      end
      object spnPort: TSpinEdit
        Left = 381
        Top = 1
        Width = 33
        Height = 19
        MaxValue = 5
        MinValue = 0
        TabOrder = 1
        Value = 0
        OnChange = spnPortChange
      end
    end
  end
  object panelCH: TPanel
    Left = 0
    Top = 22
    Width = 17
    Height = 239
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 3
    object boxCH: TPaintBox
      Left = 0
      Top = 0
      Width = 17
      Height = 239
      Align = alClient
      OnMouseDown = boxCHMouseDown
      OnPaint = boxCHPaint
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 261
    Width = 537
    Height = 19
    Align = alBottom
    TabOrder = 4
    object Label1: TLabel
      Left = 10
      Top = 4
      Width = 58
      Height = 11
      Caption = #12452#12505#12531#12488#20986#21147
      Font.Charset = SHIFTJIS_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
      Font.Style = []
      ParentFont = False
    end
    object chkSysEx: TCheckBox
      Left = 80
      Top = 0
      Width = 57
      Height = 17
      Caption = 'SysEx'
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = chkBendClick
    end
    object chkCtrlChg: TCheckBox
      Left = 144
      Top = 0
      Width = 65
      Height = 17
      Caption = 'CtrlChg'
      Checked = True
      State = cbChecked
      TabOrder = 1
      OnClick = chkBendClick
    end
    object chkBend: TCheckBox
      Left = 216
      Top = 0
      Width = 49
      Height = 17
      Caption = 'Bend'
      Checked = True
      State = cbChecked
      TabOrder = 2
      OnClick = chkBendClick
    end
  end
end
